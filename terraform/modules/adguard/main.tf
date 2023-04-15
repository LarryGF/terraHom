
resource "helm_release" "adguard-home" {
  name       = "adguard"
  chart      = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "internal-services"
  reuse_values = true

  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("${path.module}/helm/adguard-values.yaml", {
    duckdns_domain = var.duckdns_domain,
    dns_rewrites   = file("${path.module}/helm/dns-rewrites.yaml")
  })]

  recreate_pods = true
  

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
