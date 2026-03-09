##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  s3_publisher_role = var.s3.enabled != "" ? [
    {
      name_prefix = "s3-pub"
      description = "S3 Static Content Publisher Deployment Role"
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
            var.usernames.account_id == "" ? data.aws_iam_user.terraform_user[0].arn : "arn:aws:iam::${var.usernames.account_id}:user/${var.usernames.terraform}",
          ]
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "s3-publisher-access"
          statements = [
            {
              actions = [
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketCors",
                "s3:GetBucketLocation",
                "s3:GetBucketLogging",
                "s3:GetBucketNotification",
                "s3:GetBucketPolicy",
                "s3:GetBucketTagging",
                "s3:GetBucketVersioning",
                "s3:GetBucketWebsite",
                "s3:GetEncryptionConfiguration",
                "s3:GetLifecycleConfiguration",
                "s3:GetObject",
                "s3:GetObjectTagging",
                "s3:GetObjectVersion",
                "s3:GetReplicationConfiguration",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:ListObjectVersions",
                "s3:PutBucketNotification",
                "s3:PutObject",
                "s3:PutObjectVersion",
                "s3:TagResource",
                "s3:UntagResource",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:s3:::*",
              ]
              sid = "S3Deployment"
            },
          ]
        },
      ]
      policy_refs = [
      ]
    },
  ] : []
}