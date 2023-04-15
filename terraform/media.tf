module "sonarr" {
  count = contains(local.modules_to_run, "sonarr") ? 1 : 0

  source         = "./modules/sonarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.public-services
  ]
}

module "radarr" {
  count = contains(local.modules_to_run, "radarr") ? 1 : 0

  source         = "./modules/radarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.public-services
  ]
}

module "jackett" {
  count = contains(local.modules_to_run, "jackett") ? 1 : 0

  source         = "./modules/jackett"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.public-services
  ]
}

module "bazarr" {
  count = contains(local.modules_to_run, "bazarr") ? 1 : 0

  source         = "./modules/bazarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.public-services
  ]
}
