# https://github.com/Fallenbagel/jellyseerr
resource "helm_release" "jellyseerr" {
  name       = "jellyseerr"
  chart      = "jellyseerr"
  repository = "https://loeken.github.io/helm-charts"
  namespace  = "services"
  reuse_values = true
  timeout          = 200

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/jellyseerr-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain

      }
    )
  ]
  
  depends_on = [ kubernetes_persistent_volume_claim.jellyseerr ]
}
resource "kubernetes_persistent_volume_claim" "jellyseerr" {
  metadata {
    name      = "jellyseerr-config"
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

variable "sc_name" {
  type        = string
  description = "Storage class name"

}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

output "pvc" {
  value = kubernetes_persistent_volume_claim.jellyseerr
  
}
