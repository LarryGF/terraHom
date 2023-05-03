module "argo-cd" {

  source = "./modules/argo-cd"

  duckdns_domain = var.duckdns_domain  
  timezone       = var.timezone
  gh_token = var.gh_token
  gh_username = var.gh_username
  depends_on = [
    kubernetes_namespace.gitops
  ]
}
