resource "helm_release" "jellyfin" {
  name       = "jellyfin"
  chart      = "jellyfin"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 600

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
