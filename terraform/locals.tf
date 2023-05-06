locals {
  k3s_config_file = "~/.kube/config"

  sc_name = var.use_longhorn ? "longhorn" : "local-path"

  applications = yamldecode(templatefile("applications.yaml",
    {
      duckdns_domain   = var.duckdns_domain
      master_hostname  = var.master_hostname
      allowed_networks = var.allowed_networks
      volume_mounts = local.duplicati_mounts

    }
  ))

  duplicati_mounts = { for app in local.applications :
     app.name => {
      enabled = true,
      mountPath = "/config/${app.name}",
      existingClaim = app.volumes.config.name
    } if app.deploy && app.namespace == "services" && contains(keys(app.volumes),"config")
  }
}

output "duplicati" {
  value = local.duplicati_mounts
}