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

variable "beanstalk_bucket_name" {
  description = "The name of the S3 bucket for Elastic Beanstalk"
  type        = string
  default     = ""
}

variable "beanstalk_service_role_name" {
  description = "The name of the Elastic Beanstalk service role"
  type        = string
  default     = "aws-elasticbeanstalk-service-role"
}

variable "argocd_role_name" {
  description = "The name of the ArgoCD IAM role"
  type        = string
  default     = ""
}

variable "dns_manager_role_name" {
  description = "The name of the DNS manager IAM role"
  type        = string
  default     = ""
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