# Grafana (https://github.com/grafana/helm-charts/tree/main/charts/grafana)

resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "internal-services"

    values = [templatefile("${path.module}/helm/grafana-values.yaml",
    {
      domains         = var.duckdns_domain
      timezone        = var.timezone
      master_hostname = var.master_hostname

  })]
}


variable "duckdns_domain" {
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
