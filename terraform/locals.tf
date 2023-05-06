locals {
  k3s_config_file = "~/.kube/config"

  sc_name = var.use_longhorn ? "longhorn" : "local-path"

  applications = yamldecode(templatefile("applications.yaml",
    {
      duckdns_domain   = var.duckdns_domain
      master_hostname  = var.master_hostname
      allowed_networks = var.allowed_networks
    }
  ))

  duplicati_mounts = { for app in local.applications :
    app.deploy && app.namespace == "services" && app.volumes.config.name => {
      enabled = true,
      mountPath = "/config/${replace(app.volumes.config.name, "-config", "")}",
      existingClaim = app.volumes.config.name
    }
  }
}

output "duplicati" {
  value = local.duplicati_mounts
}