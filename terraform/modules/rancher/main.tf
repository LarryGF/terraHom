resource "helm_release" "rancher" {
  name             = "rancher-latest"
  chart            = "rancher"
  repository       = "https://releases.rancher.com/server-charts/latest"
  namespace        = "cattle-system"
  cleanup_on_fail  = true
  wait             = true
  wait_for_jobs    = true
  timeout          = 1200
  create_namespace = true
  reuse_values = true

  values = [
    templatefile(
      "${path.module}/helm/rancher-values.yaml",
      {
        "email"        = var.letsencrypt_email
        "domain"       = var.duckdns_domain
      }
    )
  ]
}