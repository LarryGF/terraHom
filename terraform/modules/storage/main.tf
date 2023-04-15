resource "kubernetes_persistent_volume_claim" "pvcs" {
  for_each = var.persistent_volume_claims
  metadata {
    name      = "${each.value.name}-${each.value.type}"
    namespace = each.value.namespace

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = local.sc_name

    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
}

locals {
  # sc_name         = "longhorn"
  sc_name        = "local-path"

}

variable "persistent_volume_claims" {
  type = map(object({
    name      = string
    namespace = string
    storage   = string
    type=string
  }))
  description = "PVCs to be created"
}