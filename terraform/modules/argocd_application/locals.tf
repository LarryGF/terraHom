locals {
  values_files = fileset("../argocd/${var.name}","*.common.yaml")
}