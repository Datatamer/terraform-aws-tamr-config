package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

func initTestCases() []ConfigTestCase {
	return []ConfigTestCase{
		{
			testName:         "TestMinimal",
			tfDir:            "test_examples/minimal",
			expectApplyError: false,
			vars: map[string]interface{}{
				"name_prefix":         "",
				"ingress_cidr_blocks": []string{"0.0.0.0/0"},
				"egress_cidr_blocks":  []string{"0.0.0.0/0"},
				"license_key":         "averysecretkey",
				"tags":                make(map[string]string),
				"emr_tags":            make(map[string]string),
				"emr_abac_valid_tags": make(map[string][]string),
			},
		},
		{
			testName:         "TestEphemeralSpark",
			tfDir:            "test_examples/ephemeral-spark",
			expectApplyError: false,
			vars: map[string]interface{}{
				"name_prefix":         "",
				"ingress_cidr_blocks": []string{"0.0.0.0/0"},
				"egress_cidr_blocks":  []string{"0.0.0.0/0"},
				"license_key":         "averysecretkey",
				"tags":                make(map[string]string),
				"emr_tags":            make(map[string]string),
				"emr_abac_valid_tags": make(map[string][]string),
			},
		},
		{
			testName:         "TestRootModuleYaml",
			tfDir:            "test_examples/root_module",
			expectApplyError: false,
			vars: map[string]interface{}{
				"name_prefix": "",
			},
		},
	}
}

func TestAllCases(t *testing.T) {
	// os.Setenv("TERRATEST_REGION", "us-east-1")

	// os.Setenv("SKIP_pick_new_randoms", "true")
	// os.Setenv("SKIP_setup_options", "true")
	// os.Setenv("SKIP_create", "true")
	// os.Setenv("SKIP_validate", "true")
	// os.Setenv("SKIP_teardown", "true")

	testCases := initTestCases()

	for _, testCase := range testCases {
		testCase := testCase

		t.Run(testCase.testName, func(t *testing.T) {
			t.Parallel()

			tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "../", testCase.tfDir)

			test_structure.RunTestStage(t, "pick_new_randoms", func() {

				usRegions := []string{"us-east-1", "us-east-1", "us-west-1", "us-west-2"}
				// This function will first check for the Env Var TERRATEST_REGION and return its value if it is set.
				awsRegion := aws.GetRandomStableRegion(t, usRegions, nil)

				test_structure.SaveString(t, tempTestFolder, "region", awsRegion)
				// some resources require a lowercase alphabet as first char
				test_structure.SaveString(t, tempTestFolder, "unique_id", fmt.Sprintf("a%s", strings.ToLower(random.UniqueId())))
			})

			test_structure.RunTestStage(t, "setup_options", func() {
				awsRegion := test_structure.LoadString(t, tempTestFolder, "region")
				uniqueID := test_structure.LoadString(t, tempTestFolder, "unique_id")

				testCase.vars["name_prefix"] = uniqueID

				terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
					TerraformDir: tempTestFolder,
					Vars:         testCase.vars,
					EnvVars: map[string]string{
						"AWS_REGION": awsRegion,
					},
				})

				test_structure.SaveTerraformOptions(t, tempTestFolder, terraformOptions)
			})

			test_structure.RunTestStage(t, "create", func() {
				terraformOptions := test_structure.LoadTerraformOptions(t, tempTestFolder)

				_, err := terraform.InitAndApplyE(t, terraformOptions)

				if testCase.expectApplyError {
					require.Error(t, err)
					// If it failed as expected, we should skip the rest (validate function).
					t.SkipNow()
				}

			})

			defer test_structure.RunTestStage(t, "teardown", func() {
				teraformOptions := test_structure.LoadTerraformOptions(t, tempTestFolder)
				terraform.Destroy(t, teraformOptions)
			})

			test_structure.RunTestStage(t, "validate", func() {
				terraformOptions := test_structure.LoadTerraformOptions(t, tempTestFolder)
				rendered := terraform.Output(t, terraformOptions, "tamr-config")
				validateModuleOutputs(t,
					terraformOptions,
				)

				t.Run("validate_output_exists", func(t *testing.T) {
					require.NotNil(t, rendered)
				})

				t.Run("validate_unmarshal_to_yaml", func(t *testing.T) {
					// allocates a new map so that we can pass its address to the `yaml.Unmarshal` function
					configMap := make(map[interface{}]interface{})

					// converts the string rendered to a list of bytes and assigns decoded values to `configMap` as a
					// map that we could type cast later (if needed)
					err := yaml.Unmarshal([]byte(rendered), &configMap)
					assert.NoError(t, err)
				})
			})
		})
	}
}
