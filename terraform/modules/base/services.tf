module "duckdns" {

  source = "./submodules/duckdns"

  duckdns_domain  = var.duckdns_domain
  duckdns_token   = var.duckdns_token
  timezone        = var.timezone
  master_hostname = var.master_hostname
  depends_on = [
    kubernetes_namespace.services,
  ]
}

# module "adguardhome" {

#   source = "./submodules/adguard"

#   duckdns_domain  = var.duckdns_domain
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   master_ip       = var.master_ip
#   depends_on = [
#     kubernetes_namespace.services,
#   ]
# }
