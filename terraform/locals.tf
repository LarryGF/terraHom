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

  applications = { for app, values in local.template_applications : app => merge(values, {
      volumes = { for vol_name, vol_data in values.volumes : vol_name => merge({
        create       = false,
        backup       = "disabled",
        name         = "",
        size         = "0Mi",
        access_modes = [],
        mountPath    = null,
        subpath      = null
      }, vol_data) }
    })}
  # applications = merge(local.template_applications, local.duplicati_definition)

  

  cluster_storage = {
    for key,value in var.nfs_servers : key => value if try(value.longhorn == false, false)
  }
}

