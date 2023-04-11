module "cert-manager" {
  source             = "./modules/cert-manager"
  letsencrypt_email  = var.letsencrypt_email
  letsencrypt_server = var.letsencrypt_server
}

module "traefik" {
  source       = "./modules/traefik"
  source_range = var.source_range
  timezone     = var.timezone
  namespace    = "internal-services"
  depends_on = [
    module.cert-manager
  ]
}

module "rancher" {
  source            = "./modules/rancher"
  letsencrypt_email = var.letsencrypt_email
  duckdns_domain    = var.duckdns_domain
  depends_on = [
    module.traefik
  ]
}