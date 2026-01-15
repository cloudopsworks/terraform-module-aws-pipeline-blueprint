##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  eks_publisher_role = var.eks.enabled ? [
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
            var.usernames.account_id == "" ? data.aws_iam_user.terraform_user[0].arn : "arn:aws:iam::${var.usernames.account_id}:user/${var.usernames.terraform}",
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
}