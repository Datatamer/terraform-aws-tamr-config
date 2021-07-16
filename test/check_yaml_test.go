package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

func TestYamlCheck(t *testing.T) {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../test_examples/test_minimal",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	rendered := terraform.Output(t, terraformOptions, "tamr-config")
	require.NotNil(t, rendered)

	// allocates a new map so that we can pass its address to the `yaml.Unmarshal` function
	m := make(map[interface{}]interface{})

	// converts the string rendered to a list of bytes and assigns decoded values to `m` as a
	// map that we may type cast later
	err := yaml.Unmarshal([]byte(rendered), &m)
	require.NoError(t, err)
}
