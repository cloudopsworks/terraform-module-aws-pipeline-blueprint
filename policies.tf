##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  api_gateway_policy = [
    {
      name_prefix = "api-gateway-deployer"
      description = "API Gateway Deployer Policy"
      statements = concat([
        {
          actions = [
            "apigateway:POST",
            "apigateway:PUT",
            "apigateway:PATCH",
            "apigateway:DELETE",
            "apigateway:GET",
            "apigateway:TagResource",
          ]
          effect = "Allow"
          resources = [
            "*",
          ]
          sid = "DeployApiGateway"
        },
        {
          actions = [
            "logs:CreateLogGroup",
            "logs:DescribeLogGroups",
            "logs:ListTagsLogGroup",
            "logs:PutRetentionPolicy",
            "logs:DeleteRetentionPolicy",
            "logs:TagLogGroup",
            "logs:UntagLogGroup",
            "logs:DeleteLogGroup",
            "logs:ListTagsForResource",
          ]
          effect = "Allow"
          resources = [
            "arn:aws:logs:*:*:log-group:*",
          ]
          sid = "CloudwatchLogs"
        },
        {
          actions = [
            "logs:CreateLogDelivery",
            "logs:Describe*",
            "logs:ListLogDeliveries",
            "logs:GetLogDelivery",
            "logs:UpdateLogDelivery",
          ]
          effect = "Allow"
          resources = [
            "*",
          ]
          sid = "CloudwatchLogDelivery"
        },
        {
          actions = [
            "lambda:List*",
            "lambda:Get*",
            "lambda:Describe*",
            "lambda:AddPermission",
            "lambda:RemovePermission",
          ]
          effect = "Allow"
          resources = [
            "*",
          ]
          sid = "LambdaBinding"
        },
        {
          actions = [
            "iam:GetRole",
          ]
          effect = "Allow"
          resources = [
            "*",
          ]
          sid = "IAMRead"
        },
        ],
        var.lambda_apideploy_bucket_name != "" ? [
          {
            actions = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject",
              "s3:ListBucket",
              "s3:GetObjectTagging",
              "s3:GetBucketWebsite",
            ]
            effect = "Allow"
            resources = [
              data.aws_s3_bucket.apidepoy_bucket[0].arn,
              "${data.aws_s3_bucket.apidepoy_bucket[0].arn}/*",
            ]
            sid = "S3publishBucket"
          },
        ] : [],
        length(var.lambda_pass_role_arns) > 0 ? [
          {
            actions = [
              "iam:PassRole",
            ]
            effect    = "Allow"
            resources = var.lambda_pass_role_arns
            sid       = "IAMPassRole"
          },
        ] : []
      )
    },
  ]
  build_deploy_secrets_policy = [
    {
      description = "Build Deploy Secrets User Policy"
      name_prefix = "build-deploy-secrets-user"
      statements = [
        {
          actions = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecrets",
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
  database_secrets_policy = length(var.secrets_manager_arns) > 0 ? [
    {
      description = "Secrets User Policy"
      name_prefix = "database-secrets-user"
      statements = [
        {
          actions = [
            "secretsmanager:GetSecretValue",
          ]
          effect    = "Allow"
          resources = var.secrets_manager_arns
          sid       = "SecretsAccess"
        },
      ]
    },
  ] : []
  allow_dns = var.dns_manager_role_name != "" ? [
    {
      description = "Allow AssumeRole to DNS Manager in main account"
      name_prefix = "allow-dns-manager"
      statements = [
        {
          actions = [
            "sts:AssumeRole",
            "sts:TagSession",
          ]
          effect = "Allow"
          resources = [
            data.aws_iam_role.dns_manager_role[0].arn,
          ]
          sid = "AllowAssumeRole"
        },
      ]
    },
  ] : []
  blueprint_policies = concat(
    local.api_gateway_policy,
    local.build_deploy_secrets_policy,
    local.database_secrets_policy,
    local.allow_dns
  )
}