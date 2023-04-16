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
  sc_name         = contains(var.modules_to_run, "longhorn") ? "longhorn" : "local-path"

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

variable "modules_to_run" {
  type = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
}