resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = "cert-manager"
  reuse_values = true
  set {
    name  = "installCRDs"
    value = "false"
  }
}

resource "kubectl_manifest" "letsencrypt-issuer" {
  yaml_body = templatefile(
    "${path.module}/helm/letsencrypt-issuer.tpl.yaml",
    {
      "name"   = "letsencrypt"
      "email"  = var.letsencrypt_email
      "server" = var.letsencrypt_server
    }
  )

  depends_on = [helm_release.cert-manager]
}

