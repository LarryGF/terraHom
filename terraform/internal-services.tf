module "duckdns" {
    count = contains(local.modules_to_run, "duckdns") ? 1 : 0

    source = "./modules/duckdns"
    
    duckdns_domain = var.duckdns_domain
    duckdns_token  = var.duckdns_token
    timezone       = var.timezone

    depends_on = [
      kubernetes_namespace.internal-services
    ]
}

module "adguard" {
    count = contains(local.modules_to_run, "adguard") ? 1 : 0

    source = "./modules/adguard"
    
    duckdns_domain = var.duckdns_domain
    timezone       = var.timezone

    depends_on = [
      kubernetes_namespace.internal-services

    ]
}

