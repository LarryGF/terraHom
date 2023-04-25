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
