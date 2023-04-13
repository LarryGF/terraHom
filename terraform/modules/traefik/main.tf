resource "kubectl_manifest" "middlewares" {
  for_each = local.middleware_files

  yaml_body = templatefile(
    "${path.module}/middlewares/${each.value}",
    {
      "source_range" = split(",", var.source_range)
      "namespace"    = var.namespace
    }
  )

  depends_on = [helm_release.error-pages]
}

resource "helm_release" "error-pages" {
  name       = "error-pages"
  chart      = "error-pages"
  repository = "https://k8s-at-home.com/charts"
  namespace  = var.namespace
  values = [
    templatefile(
      "${path.module}/helm/error-pages-values.yaml",
      {
        timezone = var.timezone
      }
    )
  ]
  
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
      "${path.module}/helm/traefik-values.yaml",
      {
        "log_level"          = var.log_level
        "access_log_enabled" = var.access_log_enabled
      }
    )
  ]
}