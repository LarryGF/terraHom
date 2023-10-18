locals {
  k3s_config_file = "~/.kube/config"

  sc_name = var.use_longhorn ? "longhorn" : "local-path"

  template_applications = yamldecode(templatefile("applications.yaml",
    {
      domain   = var.domain
      master_hostname  = var.master_hostname
      master_ip  = var.master_ip
      allowed_networks = var.allowed_networks
      timezone = var.timezone
      plex_claim_token = var.plex_claim_token
      api_keys = var.api_keys
      gh_username = var.gh_username
      gh_token = var.gh_token
      letsencrypt_email = var.letsencrypt_email
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
      "deploy" : false,
      "volumes" : {}
      "override" : {
        "domain" : var.domain,
        "volume_mounts" : indent(4,yamlencode(local.duplicati_mounts))
        "vscode_volume_mounts" : indent(8, yamlencode(local.vscode_mounts))
      }
    }
  }

  cluster_storage = {
    for key,value in var.nfs_servers : key => value if try(value.longhorn == false, false)
  }
}

