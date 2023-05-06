resource "helm_release" "longhorn" {
  lifecycle {
    prevent_destroy = true
  }
  name            = "longhorn"
  chart           = "longhorn"
  repository      = "https://charts.longhorn.io"
  namespace       = "longhorn-system"
  create_namespace = "true"
  reuse_values = true

  version = "1.4.1"
  values = [
    templatefile(
      "${path.module}/helm/longhorn-values.yaml",
      {
        "domain"       = var.duckdns_domain
        "default_data_path" = var.default_data_path
      }
    )
  ]

  set {
    name = "defaultSettings.backupTarget"
    value = var.nfs_backupstore
  }
  
}

variable "duckdns_domain" {
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