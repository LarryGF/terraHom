locals {
  k3s_config_file = "~/.kube/config"

  sc_name = var.use_longhorn ? "longhorn" : "local-path"

  template_applications = yamldecode(templatefile("applications.yaml",
    {
      duckdns_domain   = var.duckdns_domain
      master_hostname  = var.master_hostname
      allowed_networks = var.allowed_networks
      timezone = var.timezone

    }
  ))

  applications = merge(local.template_applications, local.duplicati_definition)

  duplicati_mounts = { for app in local.template_applications :
    app.name => {
      enabled       = true,
      mountPath     = "/config/${app.name}",
      existingClaim = app.volumes.config.name
    } if app.deploy && app.namespace == "services" && contains(keys(app.volumes), "config")
  }

  vscode_mounts = [
    for key, value in local.duplicati_mounts : { "name" : key, "mountPath" : value["mountPath"] }
  ]

  duplicati_definition = {
    "duplicati" : {
      "name" : "duplicati",
      "namespace" : "services",
      "deploy" : true,
      "volumes" : {}
      "override" : {
        "duckdns_domain" : var.duckdns_domain,
        "volume_mounts" : indent(4,yamlencode(local.duplicati_mounts))
        "vscode_volume_mounts" : indent(8, yamlencode(local.vscode_mounts))
      }
    }
  }
}

