##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  build_publisher_role = [
    {
      name_prefix = "build-publisher"
      description = "Build Publisher role"
      assume_roles = [
        {
          actions = [
            "sts:AssumeRoleWithWebIdentity",
            "sts:AssumeRoleWithSAML",
            "sts:AssumeRole",
            "sts:SetContext",
            "sts:SetSourceIdentity",
            "sts:TagSession",
          ]
          principals = [
            var.usernames.account_id == "" ? data.aws_iam_user.build_publisher[0].arn : "arn:aws:iam::${var.usernames.account_id}:user/${var.usernames.build_publisher}",
          ]
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "build-publisher-FullReadWriteECR"
          statements = [
            {
              actions = [
                "ecr:GetRegistryPolicy",
                "ecr:CreateRepository",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:GetAuthorizationToken",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:CreatePullThroughCacheRule",
                "ecr:DeletePullThroughCacheRule",
                "ecr:PutRegistryPolicy",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:BatchImportUpstreamImage",
                "ecr:DeleteRegistryPolicy",
                "ecr:PutReplicationConfiguration",
                "ecr:InitiateLayerUpload",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "ECRRead"
            },
            {
              actions = [
                "translate:TranslateText",
                "translate:TranslateDocument",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "TranslateAccess"
            },
            {
              actions = [
                "ecr:*",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*",
              ]
              sid = "AllAccessRepo"
            },
          ]
        },
      ]
    },
  ]
}