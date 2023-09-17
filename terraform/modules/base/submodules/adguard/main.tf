
resource "helm_release" "adguard-home" {
  name       = "adguard"
  chart      = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "services"
  reuse_values = true

  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("${path.module}/helm/adguard-values.yaml", {
    domain = var.domain,
    dns_rewrites   = templatefile("${path.module}/helm/dns-rewrites.config.yaml",{
      master_ip = var.master_ip
      domain = var.domain
    })
    master_hostname    = var.master_hostname

  })]

  recreate_pods = true
  

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