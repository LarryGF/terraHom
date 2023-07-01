resource "argocd_application" "application" {
  count = var.deploy ? 1:0
  metadata {
    name      = var.name
    namespace = "gitops"
  }

  spec {
    project = var.project
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.namespace
    }

    source {
      repo_url        = "https://github.com/LarryGF/pi-k8s.git"
      path = "argocd/${var.name}"
      target_revision = "main"

      helm {
        
        value_files = local.values_files
        values = templatefile("${path.module}/applications/${var.name}/values.yaml",var.override_values)
      }
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false","ServerSideApply=true"]
      retry {
        limit = "5"
        backoff {
          duration     = "10s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
  depends_on = [ 
    kubernetes_persistent_volume_claim.application_storage
   ]
}

resource "kubernetes_persistent_volume_claim" "application_storage" {
  for_each = local.storage_definitions
  metadata {
    name      = each.value.name
    namespace = var.namespace

  }
  spec {
    access_modes       = each.value.access_modes
    storage_class_name = var.sc_name

    resources {
      requests = {
        storage = each.value.size
      }
    }
  }
}