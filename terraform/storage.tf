resource "kubernetes_persistent_volume_claim" "sonarr-config" {
  metadata {
    name = "sonarr-config"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }

  depends_on = [helm_release.longhorn]
  
}