locals {
  storage_definitions = {
    sonarr = {
      name        = "sonarr",
      namespace   = "services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    radarr = {
      name        = "radarr",
      namespace   = "services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    prowlarr = {
      name        = "prowlarr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    sabnzbd = {
      name        = "sabnzbd",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    filebrowser = {
      name        = "filebrowser",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    mylar = {
      name        = "mylar",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    readarr = {
      name        = "readarr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    gow = {
      name        = "gow",
      namespace   = "services",
      storage     = "1Gi",
      type        = "data",
      access_mode = ["ReadWriteOnce"]

    },
    ombi = {
      name        = "ombi",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    jellyseerr = {
      name        = "jellyseerr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    jellyfin = {
      name        = "jellyfin",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    plex = {
      name        = "plex",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    whisparr = {
      name        = "whisparr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    flood = {
      name        = "rtorrent",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    heimdall = {
      name        = "heimdall",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    duplicati = {
      name        = "duplicati",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    homer = {
      name        = "homer",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteMany"]

    },
    home-assistant = {
      name        = "ha",
      namespace   = "services",
      storage     = "1Gi",
      type        = "config",
      access_mode = ["ReadWriteMany"]
    },
    grafana = {
      name        = "grafana",
      namespace   = "monitoring",
      storage     = "1Gi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]
    },
  }


}

module "storage" {
  source                   = "./modules/storage"
  persistent_volume_claims = local.persistent_volume_claims
  modules_to_run           = local.modules_to_run
  media_storage_size       = var.media_storage_size
  deploy_media             = local.deploy_media
  sc_name                  = local.sc_name
  # depends_on               = [local.storage_depends_on]
}

# resource "kubernetes_persistent_volume_claim" "media" {
#   count = local.deploy_media ? 1 : 0
#   metadata {
#     name      = "media"
#     namespace = "services"

#   }
#   spec {
#     access_modes       = ["ReadWriteMany"]
#     storage_class_name = local.sc_name

#     resources {
#       requests = {
#         storage = var.media_storage_size
#       }
#     }
#   }
# }