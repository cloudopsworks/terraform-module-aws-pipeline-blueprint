##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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
            data.aws_iam_user.preview_pub.arn,
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
  eks_publisher_role = var.eks_cluster_name != "" ? [
    {
      name_prefix = "eks-pub-with-apigw"
      description = "EKS Main Publisher w/ApiGateway Deployment Role"
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
            data.aws_iam_user.terraform_user.arn,
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
          ]
        },
      ]
      policy_refs = [
        "api-gateway-deployer",
        "build-deploy-secrets-user",
      ]
    },
  ] : []
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
            data.aws_iam_user.terraform_user.arn,
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
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListPolicyTags",
                "iam:ListRolePolicies",
                "iam:ListRoleTags",
                "iam:ListRoles",
                "iam:PassRole",
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
  beanstalk_publisher_role = var.beanstalk_bucket_name != "" && var.beanstalk_service_role_name != "" ? [
    {
      name_prefix = "beanstalk-pub-with-apigw"
      description = "Beanstalk Publisher w/ApiGateway Deployment Role"
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
            data.aws_iam_user.terraform_user.arn,
          ]
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "beanstalk-route53-deploy"
          statements = [
            {
              actions = [
                "route53:GetChange",
                "route53:ListHostedZones",
                "route53:GetHostedZone",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
                "route53:ListTagsForResource",
                "route53:ChangeTagsForResource",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "Route53"
            },
            {
              actions = [
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:CreateLoadBalancer",
                "elasticloadbalancing:DeleteLoadBalancer",
                "elasticloadbalancing:ModifyLoadBalancerAttributes",
                "elasticloadbalancing:AddTags",
                "elasticloadbalancing:RemoveTags",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "ELB"
            },
          ]
        },
        {
          name = "beanstalk-s3-version"
          statements = [
            {
              actions = [
                "s3:PutObjectVersionTagging",
                "s3:PutObjectVersionAcl",
                "s3:PutObjectAcl",
                "s3:PutObject",
                "s3:List*",
                "s3:Get*",
                "s3:DeleteObjectVersionTagging",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:PutObjectTagging",
                "s3:PutBucketTagging",
                "s3:DeleteObjectTagging",
                "s3:TagResource",
                "s3:UntagResource",
              ]
              effect = "Allow"
              resources = [
                data.aws_s3_bucket.beanstalk_bucket[0].arn,
                "${data.aws_s3_bucket.beanstalk_bucket[0].arn}/*",
              ]
              sid = "S3Bucket"
            },
            {
              actions = [
                "s3:ListAllMyBuckets",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "ListAllBuckets"
            },
          ]
        },
        {
          name = "beanstalk-iam"
          statements = [
            {
              actions = [
                "iam:CreateRole",
                "iam:PutRolePolicy",
                "iam:AttachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:AddRoleToInstanceProfile",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "IAM"
            },
            {
              actions = [
                "iam:PassRole",
              ]
              effect = "Allow"
              resources = [
                data.aws_iam_role.beanstalk_service_role[0].arn,
              ]
              sid = "PassRole"
            },
          ]
        },
        {
          name = "beanstalk-clouwatch-rw"
          statements = [
            {
              actions = [
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "logs:CreateLogGroup",
                "logs:DeleteLogGroup",
                "logs:DescribeLogGroups",
                "logs:PutRetentionPolicy",
                "logs:DeleteRetentionPolicy",
                "logs:ListTagsLogGroup",
                "logs:TagLogGroup",
                "logs:UntagLogGroup",
                "logs:ListTagsForResource",
              ]
              effect = "Allow"
              resources = [
                "arn:aws:cloudwatch:*:${data.aws_caller_identity.current.account_id}:alarm:*",
                "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:*",
                "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group",
              ]
              sid = "CloudWatch"
            },
          ]
        },
      ]
      "managed_policies" = [
        "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk",
      ]
      "policy_refs" = [
        "api-gateway-deployer",
        "build-deploy-secrets-user",
      ]
    },
  ] : []
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
            data.aws_iam_user.build_publisher.arn,
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
  argocd_management_role = var.eks_cluster_name != "" ? [
    {
      name_prefix = "argocd"
      description = "ArgoCD Management Role"
      assume_roles = [
        {
          actions = [
            "sts:SetContext",
            "sts:SetSourceIdentity",
            "sts:TagSession",
            "sts:AssumeRole",
            "sts:AssumeRoleWithWebIdentity",
          ]
          principals = [
            data.aws_iam_role.argocd_role.arn,
          ]
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "argocd-management-eks-read-only"
          statements = [
            {
              actions = [
                "eks:DescribeCluster",
                "eks:ListClusters",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "ArgoCDManagementEKSReadOnly"
            },
          ]
        },
      ]
    },
  ] : []
  hoopagent_role = var.eks_cluster_name != "" ? [
    {
      name_prefix = "hoopagent"
      description = "HoopAgent EKS ServiceAccount Role"
      assume_roles = [
        {
          actions = [
            "sts:AssumeRoleWithWebIdentity",
          ]
          "conditions" = [
            {
              test = "StringEquals"
              values = [
                "system:serviceaccount:hoopagent:hoopagent",
              ]
              "variable" = "${data.aws_iam_openid_connect_provider.eks_cluster[0].client_id_list[0]}:sub"
            },
            {
              test = "StringEquals"
              values = [
                "sts.amazonaws.com",
              ]
              "variable" = "${data.aws_iam_openid_connect_provider.eks_cluster[0].client_id_list[0]}:aud"
            },
          ]
          principals = [
            data.aws_iam_openid_connect_provider.eks_cluster[0].arn,
          ]
          type = "Federated"
        },
      ]
      inline_policies = [
        {
          name = "hoopagent-secrets-access"
          statements = [
            {
              actions = [
                "secretsmanager:GetSecretValue",
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "SecretsAccess"
            },
          ]
        },
      ]
    },
  ] : []
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
    local.argocd_management_role,
    local.hoopagent_role,
    local.lambda_publisher_role,
    local.beanstalk_publisher_role,
    local.build_publisher_role,
    local.dms_role
  )
}