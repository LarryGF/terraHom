# https://artifacthub.io/packages/helm/grafana/loki
resource "helm_release" "loki" {
  name       = "loki"
  chart      = "loki"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "monitoring"
  values = [
    templatefile("${path.module}/helm/loki-values.yaml", {
      duckdns_domain  = var.duckdns_domain,
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
