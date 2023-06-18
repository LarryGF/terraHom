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

