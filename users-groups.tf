##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  preview_pub_group = length(var.groups.preview_publisher.role_arns) > 0 ? [
    {
      name     = var.groups.preview_publisher.name
      existing = true
      inline_policies = [
        {
          name = "preview-publisher-STS-allow"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = var.groups.preview_publisher.role_arns
            }
          ]
        }
      ]
    }
  ] : []
  terraform_group = length(var.groups.terraform.role_arns) > 0 ? [
    {
      name     = var.groups.terraform.name
      existing = true
      inline_policies = [
        {
          name = "terraform-access-STS-allow"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = var.groups.terraform.role_arns
            }
          ]
        }
      ]
    }
  ] : []
  build_group = length(var.groups.build_publisher.role_arns) > 0 ? [
    {
      name     = var.groups.build_publisher.name
      existing = true
      inline_policies = [
        {
          name = "build-publisher-STS-allow"
          statements = [
            {
              sid    = "AllowSTS"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession"
              ]
              resources = var.groups.build_publisher.role_arns
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
  source     = "git::https://github.com/cloudopsworks/terraform-module-aws-iam-user-groups.git//?ref=v1.2.1"
  is_hub     = var.is_hub
  org        = var.org
  groups     = local.groups
  extra_tags = var.extra_tags
}