# Sample Terraform CI module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS Region | `string` | `"eu-central-1"` | no |
| svc\_container | Container to run | `string` | n/a | yes |
| svc\_internal\_port | Port exposed inside the container.  If 0 is specified, then this will default to the same value of `service_port` | `number` | `0` | no |
| svc\_name | Name of the service | `string` | `"dummy"` | no |
| svc\_port | Service port (on instance) to connect to | `number` | `80` | no |
| vpc\_id | VPC to run inside | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | The DNS name of the load balancer |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->