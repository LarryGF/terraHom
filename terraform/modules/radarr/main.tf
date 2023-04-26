resource "helm_release" "radarr" {
  name       = "radarr"
  chart      = "radarr"
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
      "${path.module}/helm/radarr-values.yaml",
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
