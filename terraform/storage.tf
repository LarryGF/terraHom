resource "kubernetes_persistent_volume_claim" "sonarr-config" {

  metadata {
    name      = "sonarr-config"
    namespace = "public-services"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "radarr-config" {

  metadata {
    name      = "radarr-config"
    namespace = "public-services"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "jackett-config" {

  metadata {
    name      = "jackett-config"
    namespace = "public-services"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "heimdall-config" {

  metadata {
    name      = "heimdall-config"
    namespace = "public-services"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}
