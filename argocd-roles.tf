##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  argocd_management_role_hub = var.eks.enabled && var.is_hub ? [
    {
      name_prefix = "argocd"
      description = "ArgoCD Management Role"
      assume_roles = [
        {
          type = "Federated"
          principals = [
            data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].arn,
          ]
          actions = [
            "sts:AssumeRoleWithWebIdentity",
          ]
          conditions = [
            {
              test = "StringEquals"
              values = [
                "system:serviceaccount:${var.argocd.namespace}:${var.argocd.controller_serviceaccount_name}",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].url}:sub"
            },
            {
              test = "StringEquals"
              values = [
                "sts.amazonaws.com",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].url}:aud"
            },
          ]
        },
        {
          type = "Federated"
          principals = [
            data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].arn,
          ]
          actions = [
            "sts:AssumeRoleWithWebIdentity",
          ]
          conditions = [
            {
              test = "StringEquals"
              values = [
                "system:serviceaccount:${var.argocd.namespace}:${var.argocd.server_serviceaccount_name}",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].url}:sub"
            },
            {
              test = "StringEquals"
              values = [
                "sts.amazonaws.com",
              ]
              variable = "${data.aws_iam_openid_connect_provider.eks_cluster[var.argocd.cluster_name].url}:aud"
            },
          ]
        },
      ]
      inline_policies = [
        {
          name = "argocd-management-eks-read-only"
          statements = [
            {
              sid    = "ArgoCDManagementEKSReadOnly"
              effect = "Allow"
              actions = [
                "eks:DescribeCluster",
                "eks:ListClusters",
              ]
              resources = [
                "*",
              ]
            },
            {
              sid    = "AssumeRoles"
              effect = "Allow"
              actions = [
                "sts:AssumeRole",
                "sts:TagSession",
                "sts:AssumeRoleWithWebIdentity",
              ]
              resources = var.argocd.role_arns
            },
          ]
        },
      ]
    },
  ] : []

  argocd_management_role = length(var.argocd.role_arns) > 0 && !var.is_hub ? [
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
          principals = var.argocd.role_arns
          type       = "AWS"
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
}