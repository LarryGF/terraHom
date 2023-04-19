
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
  ]
}

resource "kubernetes_config_map" "homeassistant-config" {
  metadata {
    name = "config-file"
    namespace  = "public-services"
  }
  data = {
    "configuration.yaml" = "${file("${path.module}/helm/configuration.yaml")}"
  }
}
