# Vulnpryer infrastructure

> *DEPRECATED* This component has been merged into my primary mono-repo.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.7 |
| aws | ~> 2.70 |
| random | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.7 ~> 2.70 |
| aws.us-east-1 | ~> 2.7 ~> 2.70 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_profile | Name of AWS profile to use for API access. | `string` | `"default"` | no |
| aws\_region | n/a | `string` | `"us-west-2"` | no |
| project | Default value for project tag. | `string` | `"vulnpryer"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront\_dns | n/a |
| cloudfront\_id | n/a |
| vulnpryer\_nameservers | n/a |
| vulnpryer\_zoneid | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
