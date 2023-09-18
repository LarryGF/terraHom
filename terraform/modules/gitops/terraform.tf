terraform {
  required_providers {
    kubernetes = {
      source  = "kubernetes"
      version = "~> 2.7"

    }
    
    argocd = {
      source = "oboukili/argocd"
      version = ">= 5.2.0"
    }

  }
}

provider "argocd" {
    server_addr = "argo.${var.domain}:443"
    username = "admin"
    password = var.argocd_password
}