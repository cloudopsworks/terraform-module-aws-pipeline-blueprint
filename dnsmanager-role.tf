##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  dns_manager_role = var.is_hub && var.dns_manager.enabled ? [
    {
      name_prefix = "dns-manager"
      description = "DNS Manager Role w/cross account assume roles permit"
      assume_roles = [
        {
          actions = [
            "sts:AssumeRole",
            "sts:TagSession",
          ]
          "principals" = concat([
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            ],
          var.dns_manager.role_arns)
          type = "AWS"
        },
      ]
      inline_policies = [
        {
          name = "route53-management"
          statements = [
            {
              sid    = "Route53GetChange"
              effect = "Allow"
              actions = [
                "route53:GetChange",
              ]
              resources = [
                "arn:aws:route53:::change/*",
              ]
            },
            {
              sid    = "Route53RSChange"
              effect = "Allow"
              actions = [
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets",
              ]
              resources = [
                "arn:aws:route53:::hostedzone/*",
              ]
            },
            {
              sid    = "Route53List"
              effect = "Allow"
              actions = [
                "route53:ListHostedZonesByName",
              ]
              resources = [
                "*",
              ]
            },
          ]
        },
      ]
    },
  ] : []

}