
resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "gitops"
  reuse_values = true
  version = "5.31.1"
  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("${path.module}/helm/argo-cd-values.yaml", {
    duckdns_domain = var.duckdns_domain,
   
  })]

}

data "kubernetes_secret" "argo-cd-password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "gitops"
  }
  depends_on = [helm_release.argo-cd]
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}



output "password" {
  value = data.kubernetes_secret.argo-cd-password
}