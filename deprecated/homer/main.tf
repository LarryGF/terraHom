module "generator_submodule" {
  source = "./generator_submodule"
  duckdns_domain  = var.duckdns_domain
  modules_to_run = var.modules_to_run
}

resource "helm_release" "homer" {
  name       = "homer"
  chart      = "homer"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true
  timeout          = 180
  set {
    name = "env.TZ"
    value = var.timezone 
  }
  values = [
    templatefile(
      "${path.module}/helm/homer-values.yaml",
      {
        duckdns_domain  = var.duckdns_domain
        config = indent(8,module.generator_submodule.config_cotent)
      }
    )
  ]
  depends_on = [ kubernetes_persistent_volume_claim.homer ]
}

resource "kubernetes_config_map" "homer_setup" {
  metadata {
    name = "homer-setup"
    namespace  = "services"
  }
  data = {
    "setup.sh" = "${file("${path.module}/helm/setup.sh")}"
  }
}

resource "kubernetes_persistent_volume_claim" "homer" {
  metadata {
    name      = "homer-config"
    namespace = "services"

  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.sc_name

    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}

variable "sc_name" {
  type        = string
  description = "Storage class name"

}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "modules_to_run" {
  type        = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
}
