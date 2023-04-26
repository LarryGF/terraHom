locals {
  storage_definitions = {
    sonarr = {
      name        = "sonarr",
      namespace   = "services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    radarr = {
      name        = "radarr",
      namespace   = "services",
      storage     = "500Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    prowlarr = {
      name        = "prowlarr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    filebrowser = {
      name        = "filebrowser",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    mylar = {
      name        = "mylar",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    readarr = {
      name        = "readarr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    # gow = {
    #   name        = "gow",
    #   namespace   = "services",
    #   storage     = "1Gi",
    #   type        = "data",
    #   access_mode = ["ReadWriteOnce"]

    # },
    # ombi = {
    #   name        = "ombi",
    #   namespace   = "services",
    #   storage     = "200Mi",
    #   type        = "config",
    #   access_mode = ["ReadWriteOnce"]

    # },
    jellyseerr = {
      name        = "jellyseerr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    jellyfin = {
      name        = "jellyfin",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    # plex = {
    #   name        = "plex",
    #   namespace   = "services",
    #   storage     = "200Mi",
    #   type        = "config",
    #   access_mode = ["ReadWriteOnce"]

    # },
    whisparr = {
      name        = "whisparr",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    flood = {
      name        = "rtorrent",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    heimdall = {
      name        = "heimdall",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    duplicati = {
      name        = "duplicati",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

    },
    homer = {
      name        = "homer",
      namespace   = "services",
      storage     = "200Mi",
      type        = "config",
      access_mode = ["ReadWriteOnce"]

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
      namespace   = "services",
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
