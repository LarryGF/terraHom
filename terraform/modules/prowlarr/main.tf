resource "helm_release" "prowlarr" {
  name       = "prowlarr"
  chart      = "prowlarr"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "public-services"
  reuse_values = true
  timeout          = 600

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/prowlarr-values.yaml",
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
