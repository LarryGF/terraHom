resource "helm_release" "ddclient" {
  name         = "ddclient"
  chart        = "ddclient"
  repository   = "https://charts.alekc.dev"
  namespace    = "services"
  reuse_values = true

  values = [templatefile("${path.module}/helm/ddclient-values.yaml",
    {
      token           = var.token
      domain          = var.domain
      timezone        = var.timezone
      master_hostname = var.master_hostname

  })]

  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 180

  lifecycle {
    ignore_changes = [values, version]
  }
}

variable "domain" {
  type        = string
  description = "Domain to use"
}

variable "token" {
  type        = string
  description = "Token to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"

}
