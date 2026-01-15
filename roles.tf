##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  preview_role = [
    {
      name_prefix = "eks-preview-pub"
      description = "EKS Preview Publisher role"
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
            var.usernames.account_id == "" ? data.aws_iam_user.preview_pub[0].arn : "arn:aws:iam::${var.usernames.account_id}:user/${var.usernames.preview_publisher}",
          ]
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "eks-publisher-EKSAccess"
          statements = [
            {
              actions = [
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:AccessKubernetesApi",
                "eks:ListIdentityProviderConfigs",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "EKSRead"
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

  dms_role = var.dms_enabled ? [
    {
      name_prefix = "dms-secrets-reader"
      description = "DMS Secrets Reader Role"
      assume_roles = [
        {
          actions = [
            "sts:AssumeRole",
          ]
          principals = [
            "dms.amazonaws.com",
            "dms.us-east-1.amazonaws.com",
            "dms-data-migrations.amazonaws.com",
          ]
          type = "Service"
        },
      ]
      inline_policies = [
        {
          name = "secrets-reader"
          statements = [
            {
              actions = [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:secretsmanager:*:*:secret:*",
              ]
              sid = "SecretsReader"
            },
            {
              actions = [
                "secretsmanager:ListSecrets",
                "secretsmanager:BatchGetSecretValue",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "ListSecrets"
            },
          ]
        },
        {
          name = "kms-decrypt"
          statements = [
            {
              actions = [
                "kms:Decrypt",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "KMSDecrypt"
            },
          ]
        },
      ]
    },
    {
      name_prefix = "dms-data-migrations"
      description = "DMS Data Migrations Role"
      assume_roles = [
        {
          actions = [
            "sts:AssumeRole",
          ]
          principals = [
            "dms.amazonaws.com",
            "dms.us-east-1.amazonaws.com",
            "dms-data-migrations.amazonaws.com",
          ]
          type = "Service"
        },
      ]
      inline_policies = [
        {
          name = "data-migrations"
          statements = [
            {
              actions = [
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs",
                "ec2:DescribePrefixLists",
                "logs:DescribeLogGroups",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "EC2"
            },
            {
              actions = [
                "servicequotas:GetServiceQuota",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:servicequotas:*:*:vpc/*",
              ]
              sid = "ServiceQuotas"
            },
            {
              actions = [
                "logs:CreateLogGroup",
                "logs:DescribeLogStreams",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:logs:*:*:log-group:dms-data-migration-*",
              ]
              sid = "Logs"
            },
            {
              actions = [
                "logs:PutLogEvents",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:logs:*:*:log-group:dms-data-migration-*:log-stream:dms-data-migration-*",
              ]
              sid = "LogsEvents"
            },
            {
              actions = [
                "cloudwatch:PutMetricData",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "MetricsData"
            },
            {
              actions = [
                "ec2:CreateRoute",
                "ec2:DeleteRoute",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:route-table/*",
              ]
              sid = "ec2route"
            },
            {
              actions = [
                "ec2:CreateTags",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:security-group-rule/*",
                "arn:aws:ec2:*:*:route-table/*",
                "arn:aws:ec2:*:*:vpc-peering-connection/*",
                "arn:aws:ec2:*:*:vpc/*",
              ]
              sid = "ec2tags"
            },
            {
              actions = [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:AuthorizeSecurityGroupEgress",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:security-group-rule/*",
              ]
              sid = "ec2sgr"
            },
            {
              actions = [
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:security-group/*",
              ]
              sid = "ec2sg"
            },
            {
              actions = [
                "ec2:AcceptVpcPeeringConnection",
                "ec2:ModifyVpcPeeringConnectionOptions",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:vpc-peering-connection/*",
              ]
              sid = "ec2vpc"
            },
            {
              actions = [
                "ec2:AcceptVpcPeeringConnection",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:ec2:*:*:vpc/*",
              ]
              sid = "ec2vpcs"
            },
          ]
        },
      ]
    },
  ] : []

  blueprint_roles = concat(
    local.preview_role,
    local.eks_publisher_role,
    local.argocd_management_role_hub,
    local.argocd_management_role,
    local.hoopagent_role,
    local.lambda_publisher_role,
    local.beanstalk_publisher_role,
    local.build_publisher_role,
    local.dns_manager_role,
    local.dms_role,
    local.device_farm_publisher_role
  )
}