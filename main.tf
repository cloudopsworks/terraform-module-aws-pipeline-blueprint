##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

data "aws_iam_user" "preview_pub" {
  count     = var.usernames.account_id == "" ? 1 : 0
  user_name = var.usernames.preview_publisher
}

data "aws_iam_user" "terraform_user" {
  count     = var.usernames.account_id == "" ? 1 : 0
  user_name = var.usernames.terraform
}

data "aws_iam_user" "build_publisher" {
  count     = var.usernames.account_id == "" ? 1 : 0
  user_name = var.usernames.build_publisher
}

data "aws_s3_bucket" "lambda_bucket" {
  count  = var.lambda_bucket_name != "" ? 1 : 0
  bucket = var.lambda_bucket_name
}

data "aws_s3_bucket" "apidepoy_bucket" {
  count  = var.apideploy_bucket_name != "" ? 1 : 0
  bucket = var.apideploy_bucket_name
}

data "aws_s3_bucket" "beanstalk_bucket" {
  count  = var.beanstalk.bucket_name != "" ? 1 : 0
  bucket = var.beanstalk.bucket_name
}

data "aws_iam_role" "beanstalk_service_role" {
  count = var.beanstalk.bucket_name != "" && var.beanstalk.service_role_name != "" ? 1 : 0
  name  = var.beanstalk.service_role_name
}

data "aws_eks_cluster" "eks_cluster" {
  for_each = {
    for cluster in var.eks.clusters : cluster.name => cluster
  }
  name = each.value.name
}

data "aws_iam_openid_connect_provider" "eks_cluster" {
  for_each = {
    for cluster in var.eks.clusters : cluster.name => cluster
  }
  url = data.aws_eks_cluster.eks_cluster[each.key].identity[0].oidc[0].issuer
}

data "aws_s3_bucket" "ssm_session_manager_logs_bucket" {
  count  = var.ssm_session_manager.logs_bucket_name != "" ? 1 : 0
  bucket = var.ssm_session_manager.logs_bucket_name
}

module "blueprint" {
  source               = "git::https://github.com/cloudopsworks/terraform-module-aws-iam-roles-policies.git//?ref=v1.2.0"
  is_hub               = var.is_hub
  spoke_def            = var.spoke_def
  org                  = var.org
  extra_tags           = var.extra_tags
  roles                = local.blueprint_roles
  policies             = local.blueprint_policies
  service_linked_roles = local.blueprint_service_linked_roles
}