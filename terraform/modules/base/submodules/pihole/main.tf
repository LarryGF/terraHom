
resource "helm_release" "pihole" {
  name       = "pihole"
  chart      = "pihole"
  repository = "https://mojo2600.github.io/pihole-kubernetes/"
  namespace  = "services"
  reuse_values = true

  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("${path.module}/helm/pihole-values.yaml", {
    domain = var.domain,
    master_hostname    = var.master_hostname
    master_ip = var.master_ip
    pihole_key = var.pihole_key

  })]

  recreate_pods = true
  version = "2.34.0"

}

resource "kubernetes_persistent_volume_claim" "pihole" {
  metadata {
    name      = "pihole-config"
    namespace = "services"

  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.sc_name

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}
variable "domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"
  
}

variable "master_ip" {
  type        = string
  description = "IP for the master node"

}

variable "sc_name" {
  type        = string
  description = "Storage class name"

}

variable "pihole_key" {
  type        = string
  default = ""
  description = "Pihole Api Key"

}