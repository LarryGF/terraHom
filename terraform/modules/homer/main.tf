resource "helm_release" "homer" {
  name       = "homer"
  chart      = "homer"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "public-services"
  reuse_values = true
  timeout          = 300
  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/homer-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        config = indent(8,file("${path.module}/helm/homer-config.yaml"))
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

variable "modules_to_run" {
  type        = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
}

