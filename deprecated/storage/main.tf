# resource "kubernetes_persistent_volume_claim" "pvcs" {
#   for_each = var.persistent_volume_claims
#   metadata {
#     name      = "${each.value.name}-${each.value.type}"
#     namespace = each.value.namespace

#   }
#   spec {
#     access_modes       = lookup(each.value, "access_mode", ["ReadWriteOnce"])
#     storage_class_name = var.sc_name

#     resources {
#       requests = {
#         storage = each.value.storage
#       }
#     }
#   }
# }



variable "persistent_volume_claims" {
  type = map(object(
    {
    name        = string
    namespace   = string
    storage     = string
    type        = string
    access_mode = list(string)
  }))
  description = "PVCs to be created"
}

variable "modules_to_run" {
  type        = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
}

variable "media_storage_size" {
  type        = string
  description = "Size of the media PVC"
}

variable "deploy_media" {
  type        = bool
  description = "Determines if the media PVC should be created"
}

variable "sc_name" {
  type        = string
  description = "Storage class name"

}

output "pvcs" {
  value = var.persistent_volume_claims
}

# output "media" {
#   value = kubernetes_persistent_volume_claim.media
# }

# output "pvclaims" {
#   value = kubernetes_persistent_volume_claim.pvcs
# }