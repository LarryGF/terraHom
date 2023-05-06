resource "helm_release" "jellyfin" {
  name       = "jellyfin"
  chart      = "jellyfin"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 180

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/jellyfin-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        master_hostname = var.master_hostname

      }
    )
  ]
  depends_on = [ kubernetes_persistent_volume_claim.jellyfin ]
  
}
resource "kubernetes_persistent_volume_claim" "jellyfin" {
  metadata {
    name      = "jellyfin-config"
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

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"
  
}

output "pvc" {
  value = kubernetes_persistent_volume_claim.jellyfin
  
}