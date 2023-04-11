# resource "kubectl_manifest" "letsencrypt-issuer" {
#   yaml_body = templatefile(
#     "../helm/infrastructure/cert-manager/letsencrypt-issuer.tpl.yaml",
#     {
#       "name"   = "letsencrypt"
#       "email"  = var.rancher["letsencrypt_email"]
#       "server" = "https://acme-v02.api.letsencrypt.org/directory"
#     }
#   )

#   depends_on = [helm_release.cert-manager]
# }


# resource "helm_release" "cert-manager" {
#   name       = "cert-manager"
#   chart      = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   namespace  = "cert-manager"

#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
#   depends_on = [kubernetes_namespace.cert-manager]
# }

# resource "helm_release" "traefik" {
#   name            = "traefik"
#   chart           = "traefik"
#   repository      = "https://traefik.github.io/charts"
#   namespace       = "kube-system"
#   cleanup_on_fail = true
#   wait            = true
#   wait_for_jobs   = true
#   timeout         = 1200
#   values = [
#     templatefile(
#       "../helm/infrastructure/traefik/traefik-values.yaml",
#       {
#         "log_level"          = var.traefik["log_level"]
#         "access_log_enabled" = var.traefik["access_log_enabled"]
#       }
#     )
#   ]
#   depends_on = []
# }



resource "helm_release" "longhorn" {
  name            = "longhorn"
  chart           = "longhorn"
  repository      = "https://charts.longhorn.io"
  namespace       = "longhorn-system"
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 1200
  values = [
    templatefile(
      "../helm/infrastructure/longhorn/longhorn-values.yaml",
      {
        "domain"       = var.duckdns_domain

      }
    )
  ]
}

# resource "helm_release" "rancher" {
#   name             = "rancher-latest"
#   chart            = "rancher"
#   repository       = "https://releases.rancher.com/server-charts/latest"
#   namespace        = "cattle-system"
#   cleanup_on_fail  = true
#   wait             = true
#   wait_for_jobs    = true
#   timeout          = 1200
#   create_namespace = true
#   values = [
#     templatefile(
#       "../helm/infrastructure/rancher/rancher-values.yaml",
#       {
#         "email"        = var.rancher["letsencrypt_email"]
#         "source_range" = var.rancher["source_range"]
#         "domain"       = var.duckdns_domain
#       }
#     )
#   ]
#   depends_on = [kubectl_manifest.letsencrypt-issuer,helm_release.cert-manager]
# }