resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "cattle-system" {
  metadata {
    annotations = {
      name = "Rancher System"
    }
    name = "cattle-system"
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
  depends_on = []
}

resource "helm_release" "rancher" {
  name       = "rancher-latest"
  chart      = "rancher"
  repository = "https://releases.rancher.com/server-charts/latest"
  namespace  = "cattle-system"
  cleanup_on_fail = true
  wait = true
  wait_for_jobs = true
  timeout = 1200
  create_namespace = true
  values = [
      templatefile(
    "../helm/rancher/rancher-values.yaml",
    {
      "email"                     = var.letsencrypt_email
    }
  )
    ]
  depends_on = [helm_release.cert-manager]
}

resource "kubernetes_manifest" "letsencrypt-issuer" {
  manifest = yamldecode(templatefile(
    "../helm/cert-manager/letsencrypt-issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt"
      "email"                     = var.letsencrypt_email
      "server"                    = "https://acme-v02.api.letsencrypt.org/directory"
    }
  ))

  depends_on = [helm_release.cert-manager]
}
    // "${file("../helm/rancher/rancher-values.yaml")}"