package test

type ConfigTestCase struct {
	testName         string
	tfDir            string
	tempDir          string
	expectApplyError bool
	vars             map[string]interface{}
}
