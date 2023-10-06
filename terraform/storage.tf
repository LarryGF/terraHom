resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "nfs-sc"
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "nfs"
}

## Media
resource "kubernetes_persistent_volume" "media-pv" {
  metadata {
    name = "media"
  }
  spec {
    capacity = {
      storage = "9600Gi"
    }
    access_modes       = ["ReadWriteMany"]
    storage_class_name = kubernetes_storage_class.nfs.metadata[0].name
    persistent_volume_source {
      nfs {
        server = var.nfs_server
        path   = "/mnt/external-disk-2/nfs/pvs/media/"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "media" {
  metadata {
    name = "media"
    namespace = "services"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "9600Gi"
      }
    }
    volume_name        = kubernetes_persistent_volume.media-pv.metadata[0].name
    storage_class_name = kubernetes_storage_class.nfs.metadata[0].name
  }
}
