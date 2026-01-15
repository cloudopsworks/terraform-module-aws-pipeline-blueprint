##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  preview_pub_group = length(var.groups.preview_publisher.roles) > 0 ? [
    {
      name     = var.groups.preview_publisher.name
      existing = true
      inline_policies = [
        for role_account in var.groups.preview_publisher.roles : {
          name = "preview-publisher-STS-allow-${role_account.account_id}"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = [
                for role in role_account.role_names : "arn:aws:iam::${role_account.account_id}:role/${role}"
              ]
            }
          ]
        }
      ]
    }
  ] : []
  terraform_group = length(var.groups.terraform.roles) > 0 ? [
    {
      name     = var.groups.terraform.name
      existing = true
      inline_policies = [
        for role_account in var.groups.terraform.roles : {
          name = "terraform-access-STS-allow-${role_account.account_id}"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = [
                for role in role_account.role_names : "arn:aws:iam::${role_account.account_id}:role/${role}"
              ]
            }
          ]
        }
      ]
    }
  ] : []
  build_group = length(var.groups.build_publisher.roles) > 0 ? [
    {
      name     = var.groups.build_publisher.name
      existing = true
      inline_policies = [
        for role_account in var.groups.build_publisher.roles : {
          name = "build-publisher-STS-allow-${role_account.account_id}"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = [
                for role in role_account.role_names : "arn:aws:iam::${role_account.account_id}:role/${role}"
              ]
            }
          ]
        }
      ]
    }
  ] : []
  groups = concat(
    local.preview_pub_group,
    local.terraform_group,
    local.build_group
  )
}

module "blueprint-users" {
  count      = var.is_hub ? 1 : 0
  source     = "git::https://github.com/cloudopsworks/terraform-module-aws-iam-user-groups.git//?ref=v1.3.1"
  is_hub     = var.is_hub
  org        = var.org
  groups     = local.groups
  extra_tags = var.extra_tags
}