resource "helm_release" "homepage" {
  name       = "homepage"
  chart      = "homepage"
  repository = "https://jameswynn.github.io/helm-charts"
  namespace  = "services"
  reuse_values = true
  timeout          = 180

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/homepage-values.yaml",
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
