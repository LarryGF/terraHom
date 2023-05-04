resource "null_resource" "backup" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "mkdir -p .backups && test -f terraform.tfstate.backup && cp terraform.tfstate.backup .backups/$(date +%Y.%m.%d.%H.%M).terraform.tfstate.backup"
  }

}

module "cert-manager" {
  source             = "./submodules/cert-manager"
  letsencrypt_email  = var.letsencrypt_email
  letsencrypt_server = var.letsencrypt_server
  master_hostname    = var.master_hostname
  depends_on = [
    null_resource.backup
  ]
}

module "traefik" {

  source             = "./submodules/traefik"
  source_range       = var.source_range
  timezone           = var.timezone
  namespace          = "services"
  log_level          = "WARNING"
  master_hostname    = var.master_hostname
  access_log_enabled = true
  depends_on         = [module.cert-manager, kubernetes_namespace.services]
}



module "longhorn" {
  count = contains(local.modules_to_run, "longhorn") ? 1 : 0

  source            = "./submodules/longhorn"
  duckdns_domain    = var.duckdns_domain
  nfs_backupstore   = var.nfs_backupstore
  default_data_path = "/mnt/external-disk/storage"
  depends_on = [
    module.traefik,
    
  ]
}

module "argo-cd" {

  source = "./submodules/argo-cd"

  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.gitops,
    module.traefik

  ]
}

module "homepage" {

  source         = "./submodules/homepage"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services,
    module.traefik

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
