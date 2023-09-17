resource "helm_release" "longhorn" {
  lifecycle {
    prevent_destroy = true
  }
  name            = "longhorn"
  chart           = "longhorn"
  repository      = "https://charts.longhorn.io"
  namespace       = "longhorn-system"
  create_namespace = "true"

  version = "1.5.1"
  values = [
    templatefile(
      "${path.module}/helm/longhorn-values.yaml",
      {
        "domain"       = var.domain
        "default_data_path" = var.default_data_path
      }
    )
  ]

  set {
    name = "defaultSettings.backupTarget"
    value = var.nfs_backupstore
  }
  
}

resource "kubectl_manifest" "backup" {
  yaml_body = templatefile(
    "${path.module}/helm/backup-recurringjob.tpl.yaml",
    {
      "name"   = "backup"
      "retain"  = 3
      "concurrency" = 2
      "cron" = "0 3 * * *"
    }
  )

  depends_on = [helm_release.longhorn]
}

variable "domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "default_data_path" {
  type        = string
  description = "Default Data Path"
}


variable "nfs_backupstore" {
  type        = string
  description = "Default NFS for backups"
}
