
terraform {
  required_providers {
    kubernetes = {
      source = "kubernetes"
      version = "~> 2.7"

    }
    helm = {
      source = "helm"
      version = "~> 2.4"
    }
 
  }
}
# Providers

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  
  config_path = local.k3s_config_file
}

provider "helm" {
  kubernetes {
    config_path = local.k3s_config_file
  }
}
