resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    annotations = {
      name = "Longhorn System"
    }
    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  name            = "longhorn"
  chart           = "longhorn"
  repository      = "https://charts.longhorn.io"
  namespace       = "longhorn-system"
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 1200
  values = [
    templatefile(
      "${path.module}/helm/longhorn-values.yaml",
      {
        "domain"       = var.duckdns_domain

      }
    )
  ]
  depends_on = [
    kubernetes_namespace.longhorn-system
  ]
}