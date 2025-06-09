##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "preview_publisher_username" {
  description = "The username of the preview publisher IAM user"
  type        = string
  default     = "eks-preview-publisher"
}

variable "terraform_username" {
  description = "The username of the Terraform IAM user"
  type        = string
  default     = "terraform-access"
}

variable "build_username" {
  description = "The username of the build publisher IAM user"
  type        = string
  default     = "build-publisher"
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
    bucket_name       = optional(string, "")
    service_role_name = optional(string, "aws-elasticbeanstalk-service-role")
  })
  default = {}
}

variable "argocd" {
  description = "ArgoCD configuration"
  type = object({
    namespace                      = optional(string, "argocd")
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

variable "ssm_session_manager_logs_bucket_name" {
  description = "The name of the S3 bucket for SSM Session Manager logs"
  type        = string
  default     = ""
}

variable "ssm_session_manager_kms_key_arn" {
  description = "The ARN of the KMS key for SSM Session Manager encryption"
  type        = string
  default     = ""
}

variable "dms_enabled" {
  description = "Flag to enable DMS (Database Migration Service) resources"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
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