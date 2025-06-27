##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  lambda_publisher_role = var.lambda_bucket_name != "" ? [
    {
      name_prefix = "lambda-pub-with-apigw"
      description = "Lambda Publisher w/ApiGateway Deployment Role"
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
          name = "lambda-publisher-access"
          statements = [
            {
              actions = [
                "lambda:*",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "LambdaDeployment"
            },
            {
              actions = [
                "logs:DescribeLogGroups",
                "logs:DeleteLogGroup",
                "logs:CreateLogGroup",
                "logs:TagLogGroup",
                "logs:TagResource",
                "logs:UntagLogGroup",
                "logs:UntagResource",
                "logs:Link",
                "logs:DisassociateKmsKey",
                "logs:AssociateKmsKey",
                "logs:PutResourcePolicy",
                "logs:DeleteResourcePolicy",
                "logs:ListTagsForResource",
                "logs:ListTagsForLogGroup",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "CRUDCloudWatchLogs"
            },
            {
              actions = [
                "iam:AttachRolePolicy",
                "iam:CreatePolicy",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:DeleteRolePermissionsBoundary",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:DeletePolicy",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListPolicyTags",
                "iam:ListPolicyVersions",
                "iam:ListRolePolicies",
                "iam:ListRoleTags",
                "iam:ListRoles",
                "iam:PutRolePermissionsBoundary",
                "iam:PutRolePolicy",
                "iam:TagPolicy",
                "iam:TagRole",
                "iam:UntagPolicy",
                "iam:UntagRole",
                "iam:UpdateAssumeRolePolicy",
                "iam:UpdateRole",
                "iam:UpdateRoleDescription",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "CRUDRolesPoliciesIAM"
            },
            {
              actions = [
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteNetworkInterface",
                "ec2:CreateSecurityGroup",
                "ec2:CreateNetworkInterface",
                "ec2:AssignPrivateIpAddresses",
                "ec2:DescribeTags",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeSecurityGroupRules",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeSecurityGroupVpcAssociations",
                "ec2:GetSecurityGroupsForVpc",
                "ec2:AssociateSecurityGroupVpc",
                "ec2:ModifySecurityGroupRules",
                "ec2:DisassociateSecurityGroupVpc",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "LambdaEC2Operations"
            },
            {
              actions = [
                "scheduler:CreateSchedule",
                "scheduler:UpdateSchedule",
                "scheduler:DeleteSchedule",
                "scheduler:GetSchedule",
                "scheduler:ListSchedules",
                "scheduler:CreateScheduleGroup",
                "scheduler:GetScheduleGroup",
                "scheduler:ListScheduleGroups",
                "scheduler:DeleteScheduleGroup",
                "scheduler:TagResource",
                "scheduler:UntagResource",
                "scheduler:ListTagsForResource",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "CRUDScheduler"
            },
            {
              actions = [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:GetObject",
              ]
              effect = "Allow"
              resources = [
                data.aws_s3_bucket.lambda_bucket[0].arn,
                "${data.aws_s3_bucket.lambda_bucket[0].arn}/*",
              ]
              sid = "S3PackageDeploy"
            },
            {
              actions = [
                "s3:GetBucketLocation",
                "s3:GetBucketAcl",
                "s3:GetBucketCors",
                "s3:GetBucketLogging",
                "s3:GetBucketPolicy",
                "s3:GetBucketTagging",
                "s3:GetBucketVersioning",
                "s3:GetBucketWebsite",
                "s3:GetEncryptionConfiguration",
                "s3:GetLifecycleConfiguration",
                "s3:GetReplicationConfiguration",
                "s3:PutBucketNotification",
                "s3:GetBucketNotification",
                "s3:ListBucket",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:s3:::*",
              ]
              sid = "S3ListBucketsTrigger"
            },
            {
              actions = [
                "sqs:ListQueues",
                "sqs:ListDeadLetterSourceQueues",
                "sqs:ListQueueTags",
                "sqs:GetQueueAttributes",
                "sqs:GetQueueUrl",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:sqs:*:*:*",
              ]
              sid = "SQSTrigger"
            },
          ]
        },
      ]
      policy_refs = [
        "api-gateway-deployer",
        "build-deploy-secrets-user",
      ]
    },
  ] : []
}