resource "argocd_repository_credentials" "default-creds" {
  url      = var.gh_base_repo
  username = var.gh_username
  password = var.gh_token
}

resource "argocd_repository" "default-repo" {
  repo = var.gh_base_repo
  name = "pi-k8s"
  type = "git"
}
resource "argocd_project" "gitops" {
  metadata {
    name      = "gitops"
    namespace = "gitops"
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "Project to deploy all internal infrastructure"

    source_namespaces = ["gitops"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "services"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "monitoring"
    }

    cluster_resource_blacklist {
      group = "*"
      kind  = "*"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRoleBinding"
    }
    cluster_resource_whitelist {
      group = "rbac.authorization.k8s.io"
      kind  = "ClusterRole"
    }
    
    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

 role {
      name = "gitopsAdmin"
      policies = [
        "p, proj:gitops:gitopsAdmin, applications, override, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, applications, sync, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, clusters, get, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, repositories, create, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, repositories, delete, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, repositories, update, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, logs, get, gitops/*, allow",
        "p, proj:gitops:gitopsAdmin, exec, create, gitops/*, allow",
      ]
    }
  }
}
