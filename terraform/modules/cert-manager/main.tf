resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [kubernetes_namespace.cert-manager]
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

