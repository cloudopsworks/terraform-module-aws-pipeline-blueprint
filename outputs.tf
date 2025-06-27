##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
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