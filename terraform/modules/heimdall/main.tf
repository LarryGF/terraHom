resource "helm_release" "heimdall" {
  name       = "heimdall"
  chart      = "heimdall"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "public-services"
  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/heimdall-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
      }
    )
  ]
  
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
