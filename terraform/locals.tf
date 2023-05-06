locals {
  k3s_config_file = "~/.kube/config"

  modules_to_run = var.modules_to_run

  sc_name = contains(var.modules_to_run, "longhorn") ? "longhorn" : "local-path"

  applications = yamldecode(templatefile("applications.yaml",
    {
      duckdns_domain   = var.duckdns_domain
      master_hostname  = var.master_hostname
      allowed_networks = var.allowed_networks
    }
  ))
}
