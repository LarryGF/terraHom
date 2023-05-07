locals {
  values_files = fileset("../argocd/${var.name}","*.common.yaml")
  storage_definitions = { for key, value in var.storage_definitions : key => value if value.enabled }
}