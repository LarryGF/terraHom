module "sonarr" {
  count          = contains(local.modules_to_run, "sonarr") ? 1 : 0
  sc_name        = local.sc_name
  source         = "./modules/sonarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "radarr" {
  count          = contains(local.modules_to_run, "radarr") ? 1 : 0
  sc_name        = local.sc_name
  source         = "./modules/radarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}


module "whisparr" {
  count          = contains(local.modules_to_run, "whisparr") ? 1 : 0
  sc_name        = local.sc_name
  source         = "./modules/whisparr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "jellyseerr" {
  count          = contains(local.modules_to_run, "jellyseerr") ? 1 : 0
  sc_name        = local.sc_name
  source         = "./modules/jellyseerr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services,
    kubernetes_persistent_volume_claim.media,


  ]
}



module "plex" {
  count           = contains(local.modules_to_run, "plex") ? 1 : 0
  sc_name         = local.sc_name
  source          = "./modules/plex"
  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  allowed_networks = var.allowed_networks
  depends_on = [
    kubernetes_namespace.services,
    kubernetes_persistent_volume_claim.media,



  ]
}


module "bazarr" {
  count          = contains(local.modules_to_run, "bazarr") ? 1 : 0
  source         = "./modules/bazarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services,
    kubernetes_persistent_volume_claim.media,


  ]
}

module "prowlarr" {
  count          = contains(local.modules_to_run, "prowlarr") ? 1 : 0
  sc_name        = local.sc_name
  source         = "./modules/prowlarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services,
    kubernetes_persistent_volume_claim.media,
  ]
}
