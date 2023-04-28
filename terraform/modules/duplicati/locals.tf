locals {

  mounts = {
    for key, value in var.pvcs : key => {
      "enabled" : true,
      "mountPath" : "/config/${key}",
      "existingClaim" : "${value["name"]}-${value["type"]}"
    } if key != "duplicati" && value["namespace"] == "services"

  }

  final_mounts = merge({
    "config" : {
      "enabled" : true,
      "mountPath" : "/config",
      "existingClaim" : "duplicati-config"
    }
  }, local.mounts)

  persistence = yamlencode({
    "persistence" : local.final_mounts
  })

  vscode_mounts = [
    for key, value in local.final_mounts : { "name" : key, "mountPath" : value["mountPath"] }
  ]

  vscode_volume_mounts = yamlencode(local.vscode_mounts)
}
