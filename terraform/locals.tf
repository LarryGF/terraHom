locals {
  k3s_config_file = "~/.kube/config"
  sc_name         = "longhorn"
  middleware_files = fileset("../helm/traefik/middleware","*.tpl.yaml")

}
