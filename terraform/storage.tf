module "storage" {
  source = "./modules/storage"
  depends_on = [
    module.rancher
  ]
  persistent_volume_claims = {

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
    heimdall = {
      name      = "heimdall",
      namespace = "public-services",
      storage   = "200Mi",
      type      = "config"
    },
  }
}
