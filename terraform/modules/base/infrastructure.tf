
module "cert-manager" {
  source             = "./submodules/cert-manager"
  letsencrypt_email  = var.letsencrypt_email
  letsencrypt_server = var.letsencrypt_server
  master_hostname    = var.master_hostname
}

module "traefik" {

  source             = "./submodules/traefik"
  source_range       = var.source_range
  source_range_ext       = var.source_range_ext
  timezone           = var.timezone
  namespace          = "services"
  log_level          = "WARNING"
  master_hostname    = var.master_hostname
  access_log_enabled = true
  duckdns_domain    = var.duckdns_domain

  depends_on         = [module.cert-manager, kubernetes_namespace.services]
}



module "longhorn" {
  count = var.use_longhorn ? 1 : 0

  source            = "./submodules/longhorn"
  duckdns_domain    = var.duckdns_domain
  nfs_backupstore   = var.nfs_backupstore
  default_data_path = "/mnt/external-disk/storage"
  depends_on = [
    module.cert-manager,
    
  ]
}

module "argo-cd" {

  source = "./submodules/argo-cd"

  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.gitops,
    module.prometheus-crds

  ]
}



module "prometheus-crds" {
  source = "./submodules/prometheus-crds"

  depends_on = [
    kubernetes_namespace.monitoring,

  ]
}

# VPN configuration
resource "kubernetes_secret" "vpnconfig" {

  metadata {
    name      = "vpnconfig"
    namespace = "services"

  }

  binary_data = {
    vpnConfigfile = var.vpn_config
  }

  depends_on = [ kubernetes_namespace.services ]
}
