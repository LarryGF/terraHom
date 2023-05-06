locals {
  values_files = fileset("../../../argocd/${var.name}","*.tpl.yaml")
  
}