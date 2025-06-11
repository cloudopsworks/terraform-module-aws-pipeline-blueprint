##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

moved {
  from = data.aws_iam_policy.managed
  to   = module.blueprint.data.aws_iam_policy.managed
}

moved {
  from = data.aws_iam_policy_document.assume_role
  to   = module.blueprint.data.aws_iam_policy_document.assume_role
}

moved {
  from = data.aws_iam_policy_document.inline
  to   = module.blueprint.data.aws_iam_policy_document.inline
}

moved {
  from = data.aws_iam_policy_document.policy
  to   = module.blueprint.data.aws_iam_policy_document.policy
}

moved {
  from = aws_iam_instance_profile.this
  to   = module.blueprint.aws_iam_instance_profile.this
}

moved {
  from = aws_iam_policy.this
  to   = module.blueprint.aws_iam_policy.this
}

moved {
  from = aws_iam_role.this
  to   = module.blueprint.aws_iam_role.this
}

moved {
  from = aws_iam_role_policy.inline
  to   = module.blueprint.aws_iam_role_policy.inline
}

moved {
  from = aws_iam_role_policy_attachment.managed
  to   = module.blueprint.aws_iam_role_policy_attachment.managed
}

moved {
  from = aws_iam_role_policy_attachment.policy_ref
  to   = module.blueprint.aws_iam_role_policy_attachment.policy_ref
}