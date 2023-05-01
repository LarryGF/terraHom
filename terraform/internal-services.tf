module "duckdns" {

  source = "./modules/duckdns"

  duckdns_domain  = var.duckdns_domain
  duckdns_token   = var.duckdns_token
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "adguardhome" {
  count = contains(local.modules_to_run, "adguardhome") ? 1 : 0

  source = "./modules/adguard"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "duplicati" {
  count = contains(local.modules_to_run, "duplicati") ? 1 : 0

  source          = "./modules/duplicati"
  pvcs            = module.storage.pvcs
  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  sc_name         = local.sc_name
  depends_on = [
    kubernetes_namespace.services,
    module.mylar.pvc,
    module.radarr.pvc,
    module.sonarr.pvc,
    module.jellyfin.pvc,
    module.jellyseerr.pvc,
    module.prowlarr.pvc,
    module.whisparr.pvc,
    module.sabnzbd.pvc,
  ]
}
