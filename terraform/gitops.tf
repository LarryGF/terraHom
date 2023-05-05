module "gitops" {
  source          = "./modules/gitops"
  argocd_password = module.base.argo-cd-password
  gh_token        = var.gh_token
  gh_username     = var.gh_username
  gh_base_repo   = var.gh_base_repo
}
