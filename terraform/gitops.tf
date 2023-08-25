module "gitops" {
  source          = "./modules/gitops"
  argocd_password = module.base.argo-cd-password
  gh_token        = var.gh_token
  gh_username     = var.gh_username
  gh_base_repo   = var.gh_base_repo
}

module "argocd_application" {
  for_each = local.applications
  source = "./modules/argocd_application"
  gh_base_repo   = var.gh_base_repo
  sc_name = local.sc_name
  override_values = each.value.override
  name = each.value.name
  namespace = each.value.namespace
  storage_definitions = each.value.volumes
  priority = try(each.value.priority,"critical")
  deploy = each.value.deploy
  project = module.gitops.project
  server_side = try(each.value.server_side, "false")
  depends_on = [
    module.gitops
  ]
}

