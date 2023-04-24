# https://github.com/Fallenbagel/jellyseerr
resource "helm_release" "jellyseerr" {
  name       = "jellyseerr"
  chart      = "jellyseerr"
  repository = "https://loeken.github.io/helm-charts"
  namespace  = "public-services"
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
  
  
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}
