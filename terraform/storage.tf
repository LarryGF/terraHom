locals {
  storage_definitions = {
    sonarr = {
      name      = "sonarr",
      namespace = "public-services",
      storage   = "500Mi",
      type      = "config"
    },
    radarr = {
      name      = "radarr",
      namespace = "public-services",
      storage   = "500Mi",
      type      = "config"
    },
    jackett = {
      name      = "jackett",
      namespace = "public-services",
      storage   = "200Mi",
      type      = "config"
    },
    rtorrent = {
      name      = "rtorrent",
      namespace = "public-services",
      storage   = "200Mi",
      type      = "config"
    },
    heimdall = {
      name      = "heimdall",
      namespace = "public-services",
      storage   = "200Mi",
      type      = "config"
    },
    home-assistant = {
      name      = "ha",
      namespace = "public-services",
      storage   = "1Gi",
      type      = "config"
    },
  }

  persistent_volume_claims = {    
    for key, value in local.storage_definitions :  key => value if contains(local.modules_to_run, key) 
  }

  service_keys = keys(local.storage_definitions)

  deploy_media = length([for service in local.modules_to_run : contains(local.service_keys, service)]) == 0 ? false : true

}
module "storage" {
  source = "./modules/storage"
  depends_on = [
    module.rancher
  ]
  persistent_volume_claims = local.persistent_volume_claims
  modules_to_run = local.modules_to_run
  media_storage_size = var.media_storage_size
  deploy_media = local.deploy_media

}
