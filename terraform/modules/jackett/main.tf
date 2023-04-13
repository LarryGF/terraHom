resource "helm_release" "jackett" {
  name       = "jackett"
  chart      = "jackett"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "public-services"
  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/jackett-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
      }
    )
  ]
  
}