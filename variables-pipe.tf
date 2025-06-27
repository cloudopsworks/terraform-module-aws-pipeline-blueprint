##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

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

variable "lambda_bucket_name" {
  description = "The name of the S3 bucket for Lambda functions"
  type        = string
  default     = ""
}

variable "apideploy_bucket_name" {
  description = "The name of the S3 bucket for API deployment Lambda functions"
  type        = string
  default     = ""
}

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

variable "dns_manager" {
  description = "DNS Manager configuration"
  type = object({
    enabled   = optional(bool, false)
    role_arns = optional(list(string), [])
  })
  default = {}
}

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

variable "dms_enabled" {
  description = "Flag to enable DMS (Database Migration Service) resources"
  type        = bool
  default     = false
}

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

variable "hoop" {
  description = "The Hoop configuration"
  type = object({
    enabled             = optional(bool, false)
    namespace           = optional(string, "hoopagent")
    serviceaccount_name = optional(string, "hoopagent")
  })
  default = {}
}

variable "secrets_manager_arns" {
  description = "A list of ARNs for Secrets Manager secrets"
  type        = list(string)
  default     = []
}

variable "lambda_pass_role_arns" {
  description = "A list of ARNs for Lambda pass roles"
  type        = list(string)
  default     = []
}

variable "service_linked_roles" {
  description = "A list of service-linked roles to create"
  type        = list(string)
  default     = []
}

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