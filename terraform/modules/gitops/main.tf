resource "argocd_repository_credentials" "default-creds" {
  url      = var.gh_base_repo
  username = var.gh_username
  password = var.gh_token
}

resource "argocd_repository" "default-repo" {
  repo = var.gh_base_repo
  name = "terraHom"
  type = "git"
}

resource "argocd_repository" "kargo-repo" {
  repo = "ghcr.io/akuity/kargo-charts"
  name = "kargo"
  type = "helm"
  enable_oci = true
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
      namespace = "gitops"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "monitoring"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-system"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "authelia"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "authentik"
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "crowdsec"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "cattle-system"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "node-feature-discovery"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }

    # cluster_resource_blacklist {
    #   group = "*"
    #   kind  = "*"
    # }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
    # cluster_resource_whitelist {
    #   group = "rbac.authorization.k8s.io"
    #   kind  = "ClusterRole"
    # }

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

output "project" {
  value = argocd_project.gitops.id
}