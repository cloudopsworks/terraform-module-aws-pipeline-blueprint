##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  beanstalk_publisher_role = var.beanstalk.bucket_name != "" && var.beanstalk.service_role_name != "" ? [
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
            var.usernames.account_id == "" ? data.aws_iam_user.terraform_user[0].arn : "arn:aws:iam::${var.usernames.account_id}:user/${var.usernames.terraform}",
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
                "iam:ListPolicyVersions",
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
                "logs:TagResource",
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
      managed_policies = [
        "arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk",
      ]
      policy_refs = [
        "api-gateway-deployer",
        "build-deploy-secrets-user",
      ]
    },
  ] : []
}