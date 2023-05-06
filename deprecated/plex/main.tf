resource "helm_release" "plex" {
  name       = "plex"
  chart      = "plex"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 300

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  set {
    name = "env.PLEX_PREFERENCE_1"
    value = "FriendlyName=PlexHome"
  }


  values = [
    templatefile(
      "${path.module}/helm/plex-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        allowed_networks = var.allowed_networks
      }
    )
  ]
  depends_on = [ 
    kubernetes_persistent_volume_claim.plex
   ]
}

resource "kubernetes_persistent_volume_claim" "plex" {
  metadata {
    name      = "plex-config"
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

variable "allowed_networks" {
  type        = string
  description = "Allowed local networks with lonng netmask: 192.168.1.0/255.255.255.0"
}


output "pvc" {
  value = kubernetes_persistent_volume_claim.plex
  
}
