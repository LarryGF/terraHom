
resource "helm_release" "home-assistant" {
  name            = "home-assistant"
  chart           = "home-assistant"
  repository      = "https://geek-cookbook.github.io/charts"
  namespace       = "public-services"
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 300
  reuse_values    = true
  set {
    name  = "env.TZ"
    value = var.timezone
  }
  values = [
    templatefile(
      "${path.module}/helm/home-assistant-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        master_hostname = var.master_hostname
      }
    )
  ]
  depends_on = [
    kubernetes_config_map.homeassistant-config,
    # kubernetes_persistent_volume_claim.ha
  ]
}

# resource "kubernetes_persistent_volume_claim" "ha" {
#   metadata {
#     name      = "ha-config"
#     namespace = "public-services"

#   }
#   spec {
#     access_modes       = ["ReadWriteOnce"]
#     storage_class_name = module.global_config.global_locals.sc_name

#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#   }
# }
resource "kubernetes_config_map" "homeassistant-config" {
  metadata {
    name = "config-file"
    namespace  = "public-services"
  }
  data = {
    "configuration.yaml" = "${file("${path.module}/helm/configuration.yaml")}"
  }
}
