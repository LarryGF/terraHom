# module "home-assistant" {
#   count = contains(local.modules_to_run, "home-assistant") ? 1 : 0

#   source = "./modules/home-assistant"

#   duckdns_domain  = var.duckdns_domain
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   depends_on = [
    
#     module.storage

#   ]
#   sc_name = local.sc_name
# }

# # https://filebrowser.org/
# module "filebrowser" {
#   count = contains(local.modules_to_run, "filebrowser") ? 1 : 0

#   source         = "./modules/filebrowser"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
    
#   ]
#   sc_name = local.sc_name
# }

# # https://github.com/mylar3/mylar3
# module "mylar" {
#   count = contains(local.modules_to_run, "mylar") ? 1 : 0

#   source         = "./modules/mylar"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
    
#   ]
#   sc_name = local.sc_name
# }

# module "readarr" {
#   count = contains(local.modules_to_run, "readarr") ? 1 : 0

#   source         = "./modules/readarr"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
    
#   ]
#   sc_name = local.sc_name
# }

# module "flood" {
#   count          = contains(local.modules_to_run, "flood") ? 1 : 0
#   # vpn_config     = var.vpn_config
#   namespace      = "services"
#   source         = "./modules/rtorrent"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
    
#   ]
#   sc_name = local.sc_name
# }

# module "sabnzbd" {
#   count          = contains(local.modules_to_run, "sabnzbd") ? 1 : 0
#   source         = "./modules/sabnzbd"
#   duckdns_domain = var.duckdns_domain
#   timezone       = var.timezone
#   depends_on = [
    
#   ]
#   sc_name = local.sc_name
# }