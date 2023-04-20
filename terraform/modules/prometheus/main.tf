# Prometheus (https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus)

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace = "internal-services"
  
  values = [
    file("${path.module}/helm/helm-values.yaml"),
    file("${path.module}/helm/recording_rules.yml"),
    file("${path.module}/helm/alerting_rules.yml")
  ]

  depends_on = []
}