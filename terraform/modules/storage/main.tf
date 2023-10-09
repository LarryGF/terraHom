## Media
resource "kubernetes_persistent_volume" "media-pv" {
  metadata {
    name = var.pv_name
  }
  spec {
    capacity = {
      storage = "${var.pv_capacity}Gi"
    }
    access_modes       = var.pv_access_modes
    storage_class_name = var.storage_class_name
    persistent_volume_source {
      nfs {
        server = var.nfs_server_ip
        path   = var.nfs_server_path
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "media" {
  metadata {
    name = var.pv_name
    namespace = "services"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "${var.pv_capacity}Gi"
      }
    }
    volume_name        = kubernetes_persistent_volume.media-pv.metadata[0].name
    storage_class_name = var.storage_class_name
  }
}

