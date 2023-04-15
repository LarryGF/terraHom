resource "helm_release" "duckdns" {
  name       = "duckdns-go"
  chart      = "duckdns-go"
  repository = "https://ebrianne.github.io/helm-charts"
  namespace  = "internal-services"
  reuse_values = true

  values = [templatefile("${path.module}/helm/duckdns-values.yaml",
    {
      token    = var.duckdns_token
      domains  = var.duckdns_domain
      timezone = var.timezone
  })]

  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 600
}