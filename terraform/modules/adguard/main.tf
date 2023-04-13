resource "helm_release" "adguard-home" {
  name       = "adguard"
  chart      = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "internal-services"

  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("${path.module}/helm/adguard-values.yaml", {
    duckdns_domain = var.duckdns_domain,
    dns_rewrites   = file("${path.module}/helm/dns-rewrites.yaml")
  })]

  recreate_pods = true

}