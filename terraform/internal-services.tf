# module "duplicati" {
#   count = contains(local.modules_to_run, "duplicati") ? 1 : 0

#   source          = "./modules/duplicati"
#   pvcs            = module.storage.pvcs
#   duckdns_domain  = var.duckdns_domain
#   timezone        = var.timezone
#   master_hostname = var.master_hostname
#   sc_name         = local.sc_name
#   depends_on = [
#     module.mylar.pvc,
#     module.radarr.pvc,
#     module.sonarr.pvc,
#     module.jellyseerr.pvc,
#     module.prowlarr.pvc,
#     module.whisparr.pvc,
#     module.sabnzbd.pvc,
#   ]
# }
