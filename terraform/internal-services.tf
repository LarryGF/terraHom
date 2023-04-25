module "duckdns" {

  source = "./modules/duckdns"

  duckdns_domain  = var.duckdns_domain
  duckdns_token   = var.duckdns_token
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services
  ]
}

module "adguardhome" {
  count = contains(local.modules_to_run, "adguardhome") ? 1 : 0

  source = "./modules/adguard"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services

  ]
}

