module "prometheus" {
  count = contains(local.modules_to_run, "prometheus") ? 1 : 0

  source = "./modules/prometheus"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    

  ]
}

module "grafana" {
  count = contains(local.modules_to_run, "grafana") ? 1 : 0

  source = "./modules/grafana"
  sc_name = local.sc_name
  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    

  ]
}

module "promtail" {
  count = contains(local.modules_to_run, "promtail") ? 1 : 0

  source = "./modules/promtail"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    

  ]
}

module "loki" {
  count = contains(local.modules_to_run, "loki") ? 1 : 0

  source = "./modules/loki"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    

  ]
}