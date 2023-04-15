module "sonarr" {
    source = "./modules/sonarr"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
    depends_on = [
      kubernetes_namespace.public-services
    ]
}

module "radarr" {
    source = "./modules/radarr"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
    depends_on = [
      kubernetes_namespace.public-services
    ]
}

module "jackett" {
    source = "./modules/jackett"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
    depends_on = [
      kubernetes_namespace.public-services
    ]
}

module "bazarr" {
    source = "./modules/bazarr"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
    depends_on = [
      kubernetes_namespace.public-services
    ]
}
