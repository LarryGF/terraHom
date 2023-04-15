module "heimdall" {
    source = "./modules/heimdall"
    duckdns_domain = var.duckdns_domain
    timezone = var.timezone
    depends_on = [
      kubernetes_namespace.public-services,

    ]
}

# module "home-assistant" {
#     source = "./modules/home-assistant"
    
#     duckdns_domain = var.duckdns_domain
#     timezone       = var.timezone

#     depends_on = [
#       kubernetes_namespace.internal-services,
#       module.storage

#     ]
# }