package test

import (
	"encoding/json"
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func getSupportedPorts() []string {
	return []string{"80", "8080", "443", "9000", "3000", "8000"}
}

func TestIT_ECS_Service(t *testing.T) {
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Set up a VPC
	baseOptions := &terraform.Options{
		TerraformDir: "./base",
		Vars: map[string]interface{}{
			"region": awsRegion,
		},
		NoColor: true,
	}
	defer terraform.Destroy(t, baseOptions)
	terraform.InitAndApply(t, baseOptions)

	// Pick a random port
	port := random.RandomString(getSupportedPorts())

	// Get VPC and dummy service name
	vpcID := terraform.Output(t, baseOptions, "vpc_id")
	serviceName := terraform.Output(t, baseOptions, "svc_name")

	// Run the IaC code to be tested with test parameters
	tfOptions := &terraform.Options{
		TerraformDir: "../terraform",
		Vars: map[string]interface{}{
			"region":            awsRegion,
			"vpc_id":            vpcID,
			"svc_name":          serviceName,
			"svc_port":          port,
			"svc_internal_port": "80",
			"svc_container":     "traefik/whoami",
		},
		NoColor: true,
	}

	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndApply(t, tfOptions)

	// Test parameters
	maxRetries := 20
	timeBetweenRetries := 15 * time.Second

	// Get the DNS name of the load balancer
	lb := terraform.Output(t, tfOptions, "dns_name")

	// Attempt to access the service and validate that we got expected data
	url := fmt.Sprintf("http://%s:%s/api", lb, port)
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, maxRetries, timeBetweenRetries, func(code int, body string) bool {
		var data map[string]interface{}
		if code != 200 {
			return false
		}
		if err := json.Unmarshal([]byte(body), &data); err != nil {
			panic(err)
		}
		fmt.Printf("Got == Expected: %s == %s\n", data["url"], "/api")
		return data["url"] == "/api"
	})
}
