locals {
  k3s_config_file = "~/.kube/config"
  # sc_name         = "longhorn"
  sc_name        = "local-path"
  # middleware_files = fileset("../helm/infrastructure/traefik/middleware","*.tpl.yaml")

}
