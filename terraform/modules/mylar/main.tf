resource "helm_release" "mylar" {
  name       = "mylar"
  chart      = "mylar"
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
      "${path.module}/helm/mylar-values.yaml",
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
