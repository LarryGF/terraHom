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

resource "kubernetes_namespace" "internal-services" {
  metadata {
    annotations = {
      name = "Internal Services"
    }
    name = "internal-services"
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

resource "helm_release" "traefik" {
  name            = "traefik"
  chart           = "traefik"
  repository      = "https://traefik.github.io/charts"
  namespace       = "kube-system"
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 1200
  values = [
    templatefile(
      "../helm/traefik/traefik-values.yaml",
      {
        "log_level"          = var.traefik["log_level"]
        "access_log_enabled" = var.traefik["access_log_enabled"]
      }
    )
  ]
}

resource "helm_release" "error-pages" {
  name       = "error-pages"
  chart      = "error-pages"
  repository = "https://k8s-at-home.com/charts"
  namespace  = "internal-services"
  values = [
    templatefile(
      "../helm/error-pages/error-pages-values.yaml",
      {
        timezone = var.timezone
      }
    )
  ]
  
  depends_on = [helm_release.traefik]
}

resource "kubectl_manifest" "middlewares" {
  for_each = local.middleware_files

  yaml_body = templatefile(
    "../helm/traefik/middleware/${each.value}",
    {
      "source_range" = split(",", var.rancher["source_range"])
    }
  )

  depends_on = [helm_release.traefik]
}

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
  values = [
    templatefile(
      "../helm/rancher/rancher-values.yaml",
      {
        "email"        = var.rancher["letsencrypt_email"]
        "source_range" = var.rancher["source_range"]
        "domain"       = var.duckdns_domain
      }
    )
  ]
  depends_on = [helm_release.cert-manager]
}

resource "kubectl_manifest" "letsencrypt-issuer" {
  yaml_body = templatefile(
    "../helm/cert-manager/letsencrypt-issuer.tpl.yaml",
    {
      "name"   = "letsencrypt"
      "email"  = var.rancher["letsencrypt_email"]
      "server" = "https://acme-v02.api.letsencrypt.org/directory"
    }
  )

  depends_on = [helm_release.cert-manager]
}
