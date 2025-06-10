##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  blueprint_service_linked_roles = [
    for service in var.service_linked_roles : {
      service = service
    }
  ]
}