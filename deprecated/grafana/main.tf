# Grafana (https://github.com/grafana/helm-charts/tree/main/charts/grafana)

resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "monitoring"
  values = [
    templatefile("${path.module}/helm/grafana-values.yaml", {
      duckdns_domain  = var.duckdns_domain,
      master_hostname = var.master_hostname
  })]
  depends_on = [ kubernetes_persistent_volume_claim.grafana ]
}

resource "kubernetes_persistent_volume_claim" "grafana" {
  metadata {
    name      = "grafana-config"
    namespace = "monitoring"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.sc_name

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

variable "sc_name" {
  type        = string
  description = "Storage class name"

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
