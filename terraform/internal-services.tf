module "duckdns" {
    source = "./modules/duckdns"
    
    duckdns_domain = var.duckdns_domain
    duckdns_token  = var.duckdns_token
    timezone       = var.timezone

    depends_on = [
      kubernetes_namespace.internal-services
    ]
}

module "adguard" {
    source = "./modules/adguard"
    
    duckdns_domain = var.duckdns_domain
    timezone       = var.timezone

    depends_on = [
      kubernetes_namespace.internal-services

    ]
}

