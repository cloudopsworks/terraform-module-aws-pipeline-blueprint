##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "iam_roles" {
  value = module.blueprint.iam_roles
}

output "iam_policies" {
  value = module.blueprint.iam_policies
}

output "service_linked_roles" {
  value = module.blueprint.service_linked_roles
}