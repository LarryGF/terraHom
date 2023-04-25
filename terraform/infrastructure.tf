resource "null_resource" "backup" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "mkdir -p .backups && test -f terraform.tfstate.backup && cp terraform.tfstate.backup .backups/$(date +%Y.%m.%d.%H.%M).terraform.tfstate.backup"
  }

}

module "cert-manager" {
  source             = "./modules/cert-manager"
  letsencrypt_email  = var.letsencrypt_email
  letsencrypt_server = var.letsencrypt_server
  depends_on = [
    null_resource.backup
  ]
}

module "traefik" {

  source             = "./modules/traefik"
  source_range       = var.source_range
  timezone           = var.timezone
  namespace          = "internal-services"
  log_level          = "WARNING"
  master_hostname    = var.master_hostname
  access_log_enabled = true
  depends_on         = [module.cert-manager, kubernetes_namespace.internal-services]
}

# module "rancher" {
#   count = contains(local.modules_to_run, "rancher") ? 1 : 0

#   source            = "./modules/rancher"
#   letsencrypt_email = var.letsencrypt_email
#   duckdns_domain    = var.duckdns_domain
#   depends_on = [
#     module.traefik
#   ]
# }

module "longhorn" {
  count = contains(local.modules_to_run, "longhorn") ? 1 : 0

  source            = "./modules/longhorn"
  duckdns_domain    = var.duckdns_domain
  nfs_backupstore   = var.nfs_backupstore
  default_data_path = "/mnt/external-disk/storage"
  depends_on = [
    module.traefik
  ]
}
