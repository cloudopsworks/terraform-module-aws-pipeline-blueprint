##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  hoopagent_role = var.eks.enabled && var.hoop.enabled ? [
    {
      name_prefix = "hoopagent"
      description = "HoopAgent EKS ServiceAccount Role"
      assume_roles = [
        for cluster in var.eks.clusters : {
          type = "Federated"
          principals = [
            data.aws_iam_openid_connect_provider.eks_cluster[cluster.name].arn,
          ]
          actions = [
            "sts:AssumeRoleWithWebIdentity",
          ]
          conditions = [
            {
              test = "StringEquals"
              values = [
                "system:serviceaccount:${var.hoop.namespace}:${var.hoop.serviceaccount_name}",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[cluster.name].url}:sub"
            },
            {
              test = "StringEquals"
              values = [
                "sts.amazonaws.com",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[cluster.name].url}:aud"
            },
          ]
        }
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
}