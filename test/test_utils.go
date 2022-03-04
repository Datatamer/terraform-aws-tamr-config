package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type ConfigTestCase struct {
	testName         string
	tfDir            string
	tempDir          string
	expectApplyError bool
	vars             map[string]interface{}
}

// validateModuleOutputs validates the output from the module that was created by using assert.NotNil function.

func validateModuleOutputs(t *testing.T, terraformOptions *terraform.Options) {

	tamr_config := terraform.Output(t, terraformOptions, "tamr-config")

	assert.NotNil(t, tamr_config)

}
