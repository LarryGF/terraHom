# module "duckdns" {

#   source = "./submodules/duckdns"

#   domain  = var.domain
#   duckdns_token   = var.duckdns_token
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   depends_on = [
#     kubernetes_namespace.services,
#   ]
# }

module "adguardhome" {

  source = "./submodules/adguard"

  domain  = var.domain
  timezone        = var.timezone
  master_hostname = var.master_hostname
  master_ip       = var.master_ip
  depends_on = [
    kubernetes_namespace.services,
  ]
}


# module "pihole" {

#   source = "./submodules/pihole"

#   domain  = var.domain
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   master_ip       = var.master_ip
#   sc_name = var.sc_name
#   pihole_key = var.api_keys["pihole_key"]
#   depends_on = [
#     kubernetes_namespace.services,
#   ]
# }
