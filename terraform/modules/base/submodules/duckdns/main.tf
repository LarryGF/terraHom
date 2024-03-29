resource "helm_release" "duckdns" {
  name         = "duckdns-go"
  chart        = "duckdns-go"
  repository   = "https://ebrianne.github.io/helm-charts"
  namespace    = "services"
  reuse_values = true

  values = [templatefile("${path.module}/helm/duckdns-values.yaml",
    {
      token           = var.duckdns_token
      domains         = var.domain
      timezone        = var.timezone
      master_hostname = var.master_hostname

  })]

  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 180
}

variable "domain" {
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