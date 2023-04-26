# https://games-on-whales.github.io/gow/overview.html
resource "helm_release" "gow" {
  name       = "games-on-whales"
  chart      = "games-on-whales"
  repository = "https://geek-cookbook.github.io/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 300

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/gow-values.yaml",
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
