module "heimdall" {
  count = contains(local.modules_to_run, "heimdall") ? 1 : 0

  source         = "./modules/heimdall"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services,

  ]
}

module "homer" {
  count = contains(local.modules_to_run, "homer") ? 1 : 0

  source         = "./modules/homer"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  modules_to_run = local.modules_to_run
  depends_on = [
    kubernetes_namespace.services,

  ]
}

module "home-assistant" {
  count = contains(local.modules_to_run, "home-assistant") ? 1 : 0

  source = "./modules/home-assistant"

  duckdns_domain  = var.duckdns_domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.services,
    module.storage
    
  ]
}

# https://filebrowser.org/
module "filebrowser" {
  count = contains(local.modules_to_run, "filebrowser") ? 1 : 0

  source         = "./modules/filebrowser"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

# https://github.com/mylar3/mylar3
module "mylar" {
  count = contains(local.modules_to_run, "mylar") ? 1 : 0

  source         = "./modules/mylar"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}

module "readarr" {
  count = contains(local.modules_to_run, "readarr") ? 1 : 0

  source         = "./modules/readarr"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}
# https://games-on-whales.github.io/gow/overview.html 
## TODO - this is broken, needs to pass GPU
# module "gow" {
#   count = contains(local.modules_to_run, "gow") ? 1 : 0

#   source         = "./modules/gow"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

module "flood" {
  count = contains(local.modules_to_run, "flood") ? 1 : 0
  vpn_config = var.vpn_config
  namespace = "services"
  source         = "./modules/rtorrent"
  duckdns_domain = var.duckdns_domain
  timezone       = var.timezone
  depends_on = [
    kubernetes_namespace.services
  ]
}
