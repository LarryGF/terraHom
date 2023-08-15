resource "kubectl_manifest" "middlewares" {
  for_each = local.middleware_files

  yaml_body = templatefile(
    "${path.module}/middlewares/${each.value}",
    {
      "source_range" = split(",", var.source_range)
      "source_range_ext" = split(",", join(",",[var.source_range,var.source_range_ext]))
      "namespace"    = var.namespace
      "domain" = var.duckdns_domain
    }
  )

  # depends_on = [helm_release.error-pages]
}

resource "helm_release" "error-pages" {
  name         = "error-pages"
  chart        = "error-pages"
  repository   = "https://k8s-at-home.com/charts"
  namespace    = var.namespace
  set {
    name  = "image.tag"
    value = "latest"
  }
  set {
    name  = "env.TEMPLATE_NAME"
    value = "ghost"
  }
  # values = [
  #   templatefile(
  #     "${path.module}/helm/error-pages-values.yaml",
  #     {
  #       timezone = var.timezone
  #     }
  #   )
  # ]

}


resource "helm_release" "traefik" {
  name       = "traefik"
  chart      = "traefik"
  repository = "https://traefik.github.io/charts"
  namespace  = "kube-system"
  version = "23.0.1"
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 180

  values = [
    templatefile(
      "${path.module}/helm/traefik-values.yaml",
      {
        log_level          = var.log_level
        access_log_enabled = var.access_log_enabled
        master_hostname    = var.master_hostname
        duckdns_domain    = var.duckdns_domain

      }
    )
  ]
}
