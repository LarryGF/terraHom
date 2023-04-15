resource "helm_release" "sonarr" {
  name       = "sonarr"
  chart      = "sonarr"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "public-services"
  reuse_values = true
  timeout          = 600

  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/sonarr-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
      }
    )
  ]
  
}