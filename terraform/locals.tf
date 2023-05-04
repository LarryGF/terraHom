locals {
  k3s_config_file = "~/.kube/config"

  modules_to_run = var.modules_to_run

  persistent_volume_claims = {
    for key, value in local.storage_definitions : key => value if contains(local.modules_to_run, key)
  }

  service_keys = keys(local.storage_definitions)

  deploy_media = contains([for service in local.modules_to_run : contains(local.service_keys, service)], true)

  sc_name = contains(var.modules_to_run, "longhorn") ? "longhorn" : "local-path"

  # storage_depends_on = contains(var.modules_to_run, "longhorn") ? module.longhorn : null
}
