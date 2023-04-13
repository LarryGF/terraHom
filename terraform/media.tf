resource "kubernetes_namespace" "public-services" {
  metadata {
    annotations = {
      name = "Public Services"
    }
    name = "public-services"
  }
}

module "sonarr" {
    source = "./modules/sonarr"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
}

module "radarr" {
    source = "./modules/radarr"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
}

module "jackett" {
    source = "./modules/jackett"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
}