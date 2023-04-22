module "duckdns" {
  count = contains(local.modules_to_run, "duckdns") ? 1 : 0

  source = "./modules/duckdns"

  duckdns_domain  = var.duckdns_domain
  duckdns_token   = var.duckdns_token
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services
  ]
}

module "adguard" {
  count = contains(local.modules_to_run, "adguard") ? 1 : 0

  source = "./modules/adguard"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services

  ]
}

module "prometheus" {
  count = contains(local.modules_to_run, "prometheus") ? 1 : 0

  source = "./modules/prometheus"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services

  ]
}

module "grafana" {
  count = contains(local.modules_to_run, "grafana") ? 1 : 0

  source = "./modules/grafana"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.internal-services

  ]
}

