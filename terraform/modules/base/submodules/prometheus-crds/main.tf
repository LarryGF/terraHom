resource "helm_release" "prometheus-operator-crds" {
  name         = "prometheus-operator-crds"
  chart        = "prometheus-operator-crds"
  repository   = "https://prometheus-community.github.io/helm-charts"
  namespace    = "monitoring"
  reuse_values = true
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 180
  version= "6.0.0"
}
