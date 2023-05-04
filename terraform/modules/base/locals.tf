locals {
  sc_name = contains(var.modules_to_run, "longhorn") ? "longhorn" : "local-path"
  modules_to_run = var.modules_to_run
  
}