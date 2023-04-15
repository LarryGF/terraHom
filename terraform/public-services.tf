module "heimdall" {
  count = contains(local.modules_to_run, "heimdall") ? 1 : 0

  source         = "./modules/heimdall"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.public-services,

  ]
}

module "home-assistant" {
  count = contains(local.modules_to_run, "home-assistant") ? 1 : 0

  source = "./modules/home-assistant"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.public-services,

  ]
}
