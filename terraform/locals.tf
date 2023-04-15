locals {
  k3s_config_file = "~/.kube/config"
  # sc_name         = "longhorn"
  sc_name        = "local-path"
  modules_to_run = var.modules_to_run
}
