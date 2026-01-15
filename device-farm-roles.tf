##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  device_farm_publisher_role = var.device_farm_enabled ? [
    {
      name_prefix = "devicefarm-publisher"
      description = "Device Farm Publisher Role"
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
          name = "devicefarm-publisher-upload-access"
          statements = [
            {
              actions = [
                "devicefarm:CreateUpload",
                "devicefarm:GetUpload",
                "devicefarm:ListUploads",
                "devicefarm:DeleteUpload",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "DeviceFarmUploadAccess"
            }
          ]
        },
        {
          name = "devicefarm-publisher-tagging-access"
          statements = [
            {
              actions = [
                "devicefarm:TagResource",
                "devicefarm:UntagResource",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "DeviceFarmTaggingAccess"
            }
          ]
        },
        {
          name = "devicefarm-publisher-read-access"
          statements = [
            {
              actions = [
                "devicefarm:List*",
                "devicefarm:Get*",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "DeviceFarmReadAccess"
            }
          ]
        },
        {
          name = "devicefarm-publisher-run-job-full-access"
          statements = [
            {
              actions = [
                "devicefarm:ScheduleRun",
                "devicefarm:StopRun",
                "devicefarm:StopJob",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "DeviceFarmRunFullAccess"
            }
          ]
        },
        {
          name = "devicefarm-publisher-remote-session-access"
          statements = [
            {
              actions = [
                "devicefarm:CreateRemoteAccessSession",
                "devicefarm:GetRemoteAccessSession",
                "devicefarm:DeleteRemoteAccessSession",
                "devicefarm:StopRemoteAccessSession",
                "devicefarm:InstallToRemoteAccessSession",
              ]
              effect = "Allow"
              resources = [
                "*",
              ]
              sid = "DeviceFarmRemoteSessionAccess"
            }
          ]
        }
      ]
    }
  ] : []
}