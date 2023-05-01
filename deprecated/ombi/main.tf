resource "helm_release" "ombi" {
  name       = "ombi"
  chart      = "ombi"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 300

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/ombi-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
      }
    )
  ]
  depends_on = [ kubernetes_persistent_volume_claim.ombi ]
}

resource "kubernetes_persistent_volume_claim" "ombi" {
  metadata {
    name      = "ombi-config"
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
