resource "kubernetes_namespace" "internal-services" {
  metadata {
    annotations = {
      name = "Internal Services"
    }
    name = var.namespace
  }
}


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
  
  depends_on = [kubernetes_namespace.internal-services]
}