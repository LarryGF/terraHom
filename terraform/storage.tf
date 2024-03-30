resource "kubernetes_storage_class" "nfs" {
  metadata {
    name = "nfs-sc"
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "nfs"
}

module "storage" {
  source             = "./modules/storage"
  for_each           = local.cluster_storage
  storage_class_name = kubernetes_storage_class.nfs.metadata[0].name
  pv_name            = each.key
  pv_capacity        = each.value.size
  pv_access_modes    = ["ReadWriteMany"]
  nfs_server_ip      = each.value.ip
  nfs_server_path    = "${each.value.path}/nfs/pvs/media"
}
