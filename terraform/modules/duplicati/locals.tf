locals {

  mounts = {
    for key, value in var.pvcs : key => {
      "enabled" : true,
      "mountPath" : "/config/${key}",
      "existingClaim" : "${value["name"]}-${value["type"]}"
    } if key != "duplicati"

  }

  final_mounts = merge({
    "config" : {
      "enabled" : true,
      "mountPath" : "/config",
      "existingClaim" : "duplicati-config"
    }
  },local.mounts)
  persistence = yamlencode({
    "persistence" : local.final_mounts
  })
}

output "mounts" {
  value = local.persistence
}
