module "heimdall" {
    source = "./modules/heimdall"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
}