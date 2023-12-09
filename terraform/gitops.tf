module "gitops" {
  source          = "./modules/gitops"
  argocd_password = module.base.argo-cd-password
  gh_token        = var.gh_token
  gh_username     = var.gh_username
  gh_base_repo   = var.gh_base_repo
  domain = var.domain
  depends_on = [ 
    module.base 
    ]
}

module "argocd_application" {
  for_each = local.applications
  source = "./modules/argocd_application"
  gh_base_repo   = var.gh_base_repo
  sc_name = local.sc_name
  override_values = each.value.override
  name = each.value.name
  namespace = each.value.namespace
  gpu = try(each.value.gpu,"none")
  storage_definitions = each.value.volumes
  priority = try(each.value.priority,"critical")
  deploy = each.value.deploy
  project = module.gitops.project
  server_side = try(each.value.server_side, "false")
  ignore_differences = try(each.value.ignore, [])
  mfa = try(each.value.mfa, true)
  depends_on = [
    module.gitops
  ]
}

# resource "argocd_application" "kargo" {
#   count = 1
#   depends_on = [ module.gitops ]

#   metadata {
#     name      = "kargo"
#     namespace = "gitops"
#   }

#   spec {
#     project = "gitops"
#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = "gitops"
#     }

#     source {
#       repo_url        = "ghcr.io/akuity/kargo-charts"
#       target_revision = "0.1.0"
#       chart= "kargo"
      

#       helm {
        
#         values = templatefile("./modules/argocd_application/applications/kargo/values.yaml",merge({
#           timezone:var.timezone,
#           domain: var.domain
#           master_hostname: var.master_hostname

#         },{"namespace":"gitops","priority":"critical"}))
#       }
#     }

#     sync_policy {
#       automated {
#         prune       = true
#         self_heal   = true
#         allow_empty = true
#       }
#       # Only available from ArgoCD 1.5.0 onwards
#       sync_options = ["Validate=false"]
#       retry {
#         limit = "5"
#         backoff {
#           duration     = "10s"
#           max_duration = "2m"
#           factor       = "2"
#         }
#       }
#     }
#   }

# }
