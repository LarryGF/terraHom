locals {
  storage_definitions = {
    sonarr = {
      name        = "sonarr",
      namespace   = "public-services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    radarr = {
      name        = "radarr",
      namespace   = "public-services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    prowlarr = {
      name        = "prowlarr",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    filebrowser = {
      name        = "filebrowser",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    mylar = {
      name        = "mylar",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    readarr = {
      name        = "readarr",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    # gow = {
    #   name        = "gow",
    #   namespace   = "public-services",
    #   storage     = "1Gi",
    #   type        = "data",
    #   access_mode = ["ReadWriteOnce"]

    # },
    # ombi = {
    #   name        = "ombi",
    #   namespace   = "public-services",
    #   storage     = "200Mi",
    #   type        = "config",
    #   access_mode = ["ReadWriteOnce"]

    # },
    jellyseerr = {
      name        = "jellyseerr",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    jellyfin = {
      name        = "jellyfin",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    # plex = {
    #   name        = "plex",
    #   namespace   = "public-services",
    #   storage     = "200Mi",
    #   type        = "config",
    #   access_mode = ["ReadWriteOnce"]

    # },
    whisparr = {
      name        = "whisparr",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    rtorrent = {
      name        = "rtorrent",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    heimdall = {
      name        = "heimdall",
      namespace   = "public-services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    home-assistant = {
      name        = "ha",
      namespace   = "public-services",
      storage     = "1Gi",
      type        = "config",
      access_mode = ["ReadWriteMany"]
    },
    grafana = {
      name        = "grafana",
      namespace   = "internal-services",
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

}
