resource "helm_release" "duplicati" {
  name         = "duplicati"
  chart        = "duplicati"
  repository   = "https://k8s-at-home.com/charts/"
  namespace    = "services"
  reuse_values = true
  timeout      = 500

  set {
    name  = "env.TZ"
    value = var.timezone
  }
  values = [
    templatefile(
      "${path.module}/helm/duplicati-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        master_hostname = var.master_hostname
        volume_mounts   = indent(6, local.vscode_volume_mounts)


      }
    ),
    local.persistence,
  ]

}

resource "kubernetes_persistent_volume_claim" "duplicati" {
  metadata {
    name      = "duplicati-config"
    namespace = "services"

  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.sc_name

    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"

}

variable "pvcs" {
  type        = map(any)
  description = "Map of PVCs to mount"

}

variable "sc_name" {
  type        = string
  description = "Storage class name"

}