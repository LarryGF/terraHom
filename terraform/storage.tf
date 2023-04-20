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
      type      = "config",
      access_mode = ["ReadWriteMany"]
    },
  }


}

module "storage" {
  source = "./modules/storage"
  persistent_volume_claims = local.persistent_volume_claims
  modules_to_run = local.modules_to_run
  media_storage_size = var.media_storage_size
  deploy_media = local.deploy_media
  sc_name = local.sc_name

}

output "deploy_media" {
  value = local.deploy_media
}

output "pvcs" {
  value = local.persistent_volume_claims

  
}

output "modules" {
  value = local.modules_to_run
}

