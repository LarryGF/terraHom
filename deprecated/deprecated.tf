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

# module "heimdall" {
#   count = contains(local.modules_to_run, "heimdall") ? 1 : 0

#   source         = "./modules/heimdall"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services,

#   ]
# }

# module "jackett" {
#   count = contains(local.modules_to_run, "jackett") ? 1 : 0
# sc_name = local.sc_name
#   source         = "./modules/jackett"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }


# module "ombi" {
#   count = contains(local.modules_to_run, "ombi") ? 1 : 0
# sc_name = local.sc_name
#   source         = "./modules/ombi"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

# module "plex" {
#   count = contains(local.modules_to_run, "plex") ? 1 : 0
# sc_name = local.sc_name
#   source         = "./modules/plex"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   allowed_networks = var.allowed_networks
#   depends_on = [
#     kubernetes_namespace.services
#   ]
# }

# module "rancher" {
#   count = contains(local.modules_to_run, "rancher") ? 1 : 0

#   source            = "./modules/rancher"
#   letsencrypt_email = var.letsencrypt_email
#   duckdns_domain    = var.duckdns_domain
#   depends_on = [
#     module.traefik
#   ]
# }


# module "ombi" {
#   count          = contains(local.modules_to_run, "ombi") ? 1 : 0
#   source         = "./modules/ombi"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   sc_name = local.sc_name
#   depends_on = [
#     kubernetes_namespace.services,
#     kubernetes_persistent_volume_claim.media,


#   ]
# }

# module "homer" {
#   count = contains(local.modules_to_run, "homer") ? 1 : 0

#   source         = "./modules/homer"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   modules_to_run = local.modules_to_run
#   depends_on = [
#     kubernetes_namespace.services,

#   ]
#   sc_name = local.sc_name
# }

# module "jellyfin" {
#   count           = contains(local.modules_to_run, "jellyfin") ? 1 : 0
#   sc_name         = local.sc_name
#   source          = "./modules/jellyfin"
#   duckdns_domain  = var.duckdns_domain
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   depends_on = [
#     kubernetes_namespace.services,
#     kubernetes_persistent_volume_claim.media,



#   ]
# }