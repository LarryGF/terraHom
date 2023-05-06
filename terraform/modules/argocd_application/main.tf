resource "argocd_application" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "gitops"
  }

  spec {
    project = "gitops"
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "monitoring"
    }

    source {
      repo_url        = "https://github.com/LarryGF/pi-k8s.git"
      path = "argocd/grafana"
      target_revision = "argocd"

      helm {
        
        value_files = ["common-values.yml"]
        values = yamldecode(templatefile("extra-values.yaml",{}))
      }
    }
  }
}