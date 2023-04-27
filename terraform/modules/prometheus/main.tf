# Prometheus (https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace = "monitoring"
  
  values = [
    templatefile("${path.module}/helm/helm-values.yaml",{
    duckdns_domain = var.duckdns_domain,
    master_hostname    = var.master_hostname
  }
    ),
    file("${path.module}/helm/recording_rules.yml"),
    file("${path.module}/helm/alerting_rules.yml")
  ]

  depends_on = []
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