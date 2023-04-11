# resource "helm_release" "sonarr" {
#   name       = "sonarr"
#   chart      = "sonarr"
#   repository = "https://charts.truecharts.org"
#   namespace  = "public-services"
#   values = [
#     templatefile(
#       "../helm/media/sonarr/sonarr-values.yaml",
#       {
#         duckdns_domain  = var.duckdns_domain
#       }
#     )
#   ]
#   depends_on = [helm_release.longhorn]
  
# }