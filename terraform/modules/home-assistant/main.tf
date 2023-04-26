
resource "helm_release" "home-assistant" {
  name            = "home-assistant"
  chart           = "home-assistant"
  repository      = "https://geek-cookbook.github.io/charts"
  namespace       = "services"
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
    namespace  = "services"
  }
  data = {
    "configuration.yaml" = "${file("${path.module}/helm/configuration.yaml")}"
  }
}

resource "kubernetes_job" "install-ha-plugins" {
  metadata {
    name = "install-ha-plugins"
    namespace  = "services"

  }
  spec {
    template {
      metadata {}
      spec {
        volume {
          name = "ha-config"
          persistent_volume_claim {
            claim_name = "ha-config"
          }
        }

        container {
          name    = "install-ha-plugins"
          image   = "bash"
          command = ["bash", "-c", "cd /config && wget -O - https://get.hacs.xyz | bash -"]
          volume_mount {
            name       = "ha-config"
            mount_path = "/config"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 1
  }
  wait_for_completion = false

  depends_on = [
    helm_release.home-assistant,
  ]
}