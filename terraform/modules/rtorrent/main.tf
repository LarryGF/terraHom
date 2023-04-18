resource "helm_release" "rtorrent" {
  name       = "rtorrent"
  chart      = "rtorrent-flood"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = var.namespace
  reuse_values = true
  timeout          = 300
  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/rtorrent-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
      }
    )
  ]
  depends_on = [
    kubernetes_secret.vpnconfig,
    # kubernetes_persistent_volume_claim.rtorrent
  ]
}

# resource "kubernetes_persistent_volume_claim" "rtorrent" {
#   metadata {
#     name      = "rtorrent-config"
#     namespace = "public-services"

#   }
#   spec {
#     access_modes       = ["ReadWriteOnce"]
#     storage_class_name = module.global_config.global_locals.sc_name

#     resources {
#       requests = {
#         storage = "200Mi"
#       }
#     }
#   }
# }

# VPN configuration
resource "kubernetes_secret" "vpnconfig" {

  metadata {
    name = "vpnconfig"
    namespace  = var.namespace

  }

  binary_data = {
    vpnConfigfile = var.vpn_config
  }
}

terraform {
  required_providers {
    
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
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

variable "vpn_config" {
  type = string
  description = "VPN Configuration (base 64)"
  sensitive = true
}

variable "namespace" {
  type        = string
  description = "Namespace in which to deploy the resources"
}
