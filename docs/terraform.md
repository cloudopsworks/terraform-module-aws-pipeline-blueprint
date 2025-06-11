## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_blueprint"></a> [blueprint](#module\_blueprint) | git::https://github.com/cloudopsworks/terraform-module-aws-iam-roles-policies.git// | v1.0.7 |
| <a name="module_blueprint-users"></a> [blueprint-users](#module\_blueprint-users) | git::https://github.com/cloudopsworks/terraform-module-aws-iam-user-groups.git// | v1.2.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_openid_connect_provider.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_role.beanstalk_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_user.build_publisher](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |
| [aws_iam_user.preview_pub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |
| [aws_iam_user.terraform_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.apidepoy_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.beanstalk_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.lambda_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
| [aws_s3_bucket.ssm_session_manager_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apideploy_bucket_name"></a> [apideploy\_bucket\_name](#input\_apideploy\_bucket\_name) | The name of the S3 bucket for API deployment Lambda functions | `string` | `""` | no |
| <a name="input_argocd"></a> [argocd](#input\_argocd) | ArgoCD configuration | <pre>object({<br/>    namespace                      = optional(string, "argocd")<br/>    controller_serviceaccount_name = optional(string, "argocd-application-controller")<br/>    server_serviceaccount_name     = optional(string, "argocd-server")<br/>    role_arns                      = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_beanstalk"></a> [beanstalk](#input\_beanstalk) | Elastic Beanstalk configuration | <pre>object({<br/>    bucket_name       = optional(string, "")<br/>    service_role_name = optional(string, "aws-elasticbeanstalk-service-role")<br/>  })</pre> | `{}` | no |
| <a name="input_dms_enabled"></a> [dms\_enabled](#input\_dms\_enabled) | Flag to enable DMS (Database Migration Service) resources | `bool` | `false` | no |
| <a name="input_dns_manager"></a> [dns\_manager](#input\_dns\_manager) | DNS Manager configuration | <pre>object({<br/>    enabled   = optional(bool, false)<br/>    role_arns = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The name of the EKS cluster | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | Group Settings configuration | <pre>object({<br/>    preview_publisher = optional(object({<br/>      name = string<br/>      roles = list(object({<br/>        account_id = string<br/>        role_names = list(string)<br/>      }))<br/>      }), {<br/>      name  = "eks-preview-publisher"<br/>      roles = []<br/>    })<br/>    terraform = optional(object({<br/>      name = string<br/>      roles = list(object({<br/>        account_id = string<br/>        role_names = list(string)<br/>      }))<br/>      }), {<br/>      name      = "terraform-access"<br/>      role_arns = []<br/>    })<br/>    build_publisher = optional(object({<br/>      name = string<br/>      roles = list(object({<br/>        account_id = string<br/>        role_names = list(string)<br/>      }))<br/>      }), {<br/>      name      = "terraform-access"<br/>      role_arns = []<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_lambda_bucket_name"></a> [lambda\_bucket\_name](#input\_lambda\_bucket\_name) | The name of the S3 bucket for Lambda functions | `string` | `""` | no |
| <a name="input_lambda_pass_role_arns"></a> [lambda\_pass\_role\_arns](#input\_lambda\_pass\_role\_arns) | A list of ARNs for Lambda pass roles | `list(string)` | `[]` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_secrets_manager_arns"></a> [secrets\_manager\_arns](#input\_secrets\_manager\_arns) | A list of ARNs for Secrets Manager secrets | `list(string)` | `[]` | no |
| <a name="input_service_linked_roles"></a> [service\_linked\_roles](#input\_service\_linked\_roles) | A list of service-linked roles to create | `list(string)` | `[]` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_ssm_session_manager"></a> [ssm\_session\_manager](#input\_ssm\_session\_manager) | SSM Session Manager configuration | <pre>object({<br/>    logs_bucket_name = optional(string, "")<br/>    kms_key_arn      = optional(string, "")<br/>  })</pre> | <pre>{<br/>  "kms_key_arn": "",<br/>  "logs_bucket_name": ""<br/>}</pre> | no |
| <a name="input_usernames"></a> [usernames](#input\_usernames) | A map of usernames for various IAM users | <pre>object({<br/>    account_id        = optional(string, "")<br/>    preview_publisher = optional(string, "eks-preview-publisher")<br/>    terraform         = optional(string, "terraform-access")<br/>    build_publisher   = optional(string, "build-publisher")<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_policies"></a> [iam\_policies](#output\_iam\_policies) | n/a |
| <a name="output_iam_roles"></a> [iam\_roles](#output\_iam\_roles) | n/a |
| <a name="output_service_linked_roles"></a> [service\_linked\_roles](#output\_service\_linked\_roles) | n/a |
