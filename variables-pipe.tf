##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# usernames:
#   account_id: ""                   # (Optional) The AWS account ID. Default: ""
#   preview_publisher: "eks-preview-publisher" # (Optional) The username for the preview publisher. Default: "eks-preview-publisher"
#   terraform: "terraform-access"    # (Optional) The username for Terraform access. Default: "terraform-access"
#   build_publisher: "build-publisher" # (Optional) The username for the build publisher. Default: "build-publisher"
variable "usernames" {
  description = "A map of usernames for various IAM users"
  type = object({
    account_id        = optional(string, "")
    preview_publisher = optional(string, "eks-preview-publisher")
    terraform         = optional(string, "terraform-access")
    build_publisher   = optional(string, "build-publisher")
  })
  default = {}
}

# lambda_bucket_name: ""             # (Optional) The name of the S3 bucket for Lambda functions. Default: ""
variable "lambda_bucket_name" {
  description = "The name of the S3 bucket for Lambda functions"
  type        = string
  default     = ""
}

# apideploy_bucket_name: ""          # (Optional) The name of the S3 bucket for API deployment Lambda functions. Default: ""
variable "apideploy_bucket_name" {
  description = "The name of the S3 bucket for API deployment Lambda functions"
  type        = string
  default     = ""
}

# beanstalk:
#   bucket_name: ""                  # (Optional) Elastic Beanstalk bucket name. Default: ""
#   service_role_name: "aws-elasticbeanstalk-service-role" # (Optional) Elastic Beanstalk service role name. Default: "aws-elasticbeanstalk-service-role"
#   additional_buckets: []           # (Optional) List of additional S3 buckets for Beanstalk. Default: []
#   additional_pass_roles: []        # (Optional) List of additional IAM roles to pass to Beanstalk. Default: []
variable "beanstalk" {
  description = "Elastic Beanstalk configuration"
  type = object({
    bucket_name           = optional(string, "")
    service_role_name     = optional(string, "aws-elasticbeanstalk-service-role")
    additional_buckets    = optional(list(string), [])
    additional_pass_roles = optional(list(string), [])
  })
  default = {}
}

# argocd:
#   namespace: "argocd"              # (Optional) ArgoCD namespace. Default: "argocd"
#   cluster_name: ""                 # (Optional) ArgoCD cluster name. Default: ""
#   controller_serviceaccount_name: "argocd-application-controller" # (Optional) ArgoCD controller service account name. Default: "argocd-application-controller"
#   server_serviceaccount_name: "argocd-server" # (Optional) ArgoCD server service account name. Default: "argocd-server"
#   role_arns: []                    # (Optional) List of role ARNs for ArgoCD. Default: []
variable "argocd" {
  description = "ArgoCD configuration"
  type = object({
    namespace                      = optional(string, "argocd")
    cluster_name                   = optional(string, "")
    controller_serviceaccount_name = optional(string, "argocd-application-controller")
    server_serviceaccount_name     = optional(string, "argocd-server")
    role_arns                      = optional(list(string), [])
  })
  default = {}
}

# dns_manager:
#   enabled: false                   # (Optional) Enable DNS Manager. Default: false
#   role_arns: []                    # (Optional) List of role ARNs for DNS Manager. Default: []
variable "dns_manager" {
  description = "DNS Manager configuration"
  type = object({
    enabled   = optional(bool, false)
    role_arns = optional(list(string), [])
  })
  default = {}
}

# ssm_session_manager:
#   logs_bucket_name: ""             # (Optional) S3 bucket name for SSM Session Manager logs. Default: ""
#   kms_key_arn: ""                  # (Optional) KMS key ARN for SSM Session Manager. Default: ""
variable "ssm_session_manager" {
  description = "SSM Session Manager configuration"
  type = object({
    logs_bucket_name = optional(string, "")
    kms_key_arn      = optional(string, "")
  })
  default = {
    logs_bucket_name = ""
    kms_key_arn      = ""
  }
}

# dms_enabled: false                 # (Optional) Flag to enable DMS (Database Migration Service) resources. Default: false
variable "dms_enabled" {
  description = "Flag to enable DMS (Database Migration Service) resources"
  type        = bool
  default     = false
}

# eks:
#   enabled: false                   # (Optional) Enable EKS cluster configuration. Default: false
#   clusters:                        # (Optional) List of EKS clusters configuration. Default: []
#     - name: "my-cluster"           # (Required) EKS cluster name.
#       excluded: false              # (Optional) Exclude this cluster. Default: false
variable "eks" {
  description = "The EKS cluster configuration"
  type = object({
    enabled = optional(bool, false)
    clusters = optional(list(
      object({
        name     = string
        excluded = optional(bool, false)
      })
    ), [])
  })
  default = {}
}

# hoop:
#   enabled: false                   # (Optional) Enable Hoop configuration. Default: false
#   namespace: "hoopagent"           # (Optional) Hoop namespace. Default: "hoopagent"
#   serviceaccount_name: "hoopagent" # (Optional) Hoop service account name. Default: "hoopagent"
variable "hoop" {
  description = "The Hoop configuration"
  type = object({
    enabled             = optional(bool, false)
    namespace           = optional(string, "hoopagent")
    serviceaccount_name = optional(string, "hoopagent")
  })
  default = {}
}

# secrets_manager_arns: []           # (Optional) A list of ARNs for Secrets Manager secrets. Default: []
variable "secrets_manager_arns" {
  description = "A list of ARNs for Secrets Manager secrets"
  type        = list(string)
  default     = []
}

# lambda_pass_role_arns: []          # (Optional) A list of ARNs for Lambda pass roles. Default: []
variable "lambda_pass_role_arns" {
  description = "A list of ARNs for Lambda pass roles"
  type        = list(string)
  default     = []
}

# service_linked_roles: []           # (Optional) A list of service-linked roles to create. Default: []
variable "service_linked_roles" {
  description = "A list of service-linked roles to create"
  type        = list(string)
  default     = []
}

# groups:
#   preview_publisher:               # (Optional) Preview publisher group settings.
#     name: "eks-preview-publisher"  # (Required) Group name.
#     roles:                         # (Required) List of roles for the group.
#       - account_id: "123456789012" # (Required) AWS Account ID.
#         role_names: ["role1"]      # (Required) List of role names.
#   terraform:                       # (Optional) Terraform access group settings.
#     name: "terraform-access"       # (Required) Group name.
#     roles:                         # (Required) List of roles for the group.
#       - account_id: "123456789012" # (Required) AWS Account ID.
#         role_names: ["role1"]      # (Required) List of role names.
#   build_publisher:                 # (Optional) Build publisher group settings.
#     name: "terraform-access"       # (Required) Group name.
#     roles:                         # (Required) List of roles for the group.
#       - account_id: "123456789012" # (Required) AWS Account ID.
#         role_names: ["role1"]      # (Required) List of role names.
variable "groups" {
  description = "Group Settings configuration"
  type = object({
    preview_publisher = optional(object({
      name = string
      roles = list(object({
        account_id = string
        role_names = list(string)
      }))
      }), {
      name  = "eks-preview-publisher"
      roles = []
    })
    terraform = optional(object({
      name = string
      roles = list(object({
        account_id = string
        role_names = list(string)
      }))
      }), {
      name  = "terraform-access"
      roles = []
    })
    build_publisher = optional(object({
      name = string
      roles = list(object({
        account_id = string
        role_names = list(string)
      }))
      }), {
      name  = "terraform-access"
      roles = []
    })
  })
  default = {}
}

# device_farm_enabled: false         # (Optional) Flag to enable Device Farm resources. Default: false
variable "device_farm_enabled" {
  description = "Flag to enable Device Farm resources"
  type        = bool
  default     = false
}