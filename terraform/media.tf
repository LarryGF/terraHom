module "sonarr" {
  count = contains(local.modules_to_run, "sonarr") ? 1 : 0

  source         = "./modules/sonarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "radarr" {
  count = contains(local.modules_to_run, "radarr") ? 1 : 0

  source         = "./modules/radarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

# module "ombi" {
#   count = contains(local.modules_to_run, "ombi") ? 1 : 0

#   source         = "./modules/ombi"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

# module "plex" {
#   count = contains(local.modules_to_run, "plex") ? 1 : 0

#   source         = "./modules/plex"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   allowed_networks = var.allowed_networks
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

module "whisparr" {
  count = contains(local.modules_to_run, "whisparr") ? 1 : 0

  source         = "./modules/whisparr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "jellyseerr" {
  count = contains(local.modules_to_run, "jellyseerr") ? 1 : 0

  source         = "./modules/jellyseerr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "jellyfin" {
  count = contains(local.modules_to_run, "jellyfin") ? 1 : 0

  source         = "./modules/jellyfin"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.services
  ]
}

# module "jackett" {
#   count = contains(local.modules_to_run, "jackett") ? 1 : 0

#   source         = "./modules/jackett"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

module "bazarr" {
  count = contains(local.modules_to_run, "bazarr") ? 1 : 0

  source         = "./modules/bazarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "prowlarr" {
  count = contains(local.modules_to_run, "prowlarr") ? 1 : 0

  source         = "./modules/prowlarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}
