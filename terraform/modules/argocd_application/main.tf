resource "argocd_application" "application" {
  count = var.deploy ? 1 : 0
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
      repo_url        = "https://github.com/LarryGF/terraHom.git"
      path            = "argocd/${var.name}"
      target_revision = "main"

      helm {

        value_files = local.values_files
        values = templatefile("${path.module}/applications/${var.name}/values.yaml", merge(
          var.override_values,
          {
            "namespace" : var.namespace,
            "priority" : var.priority,
            "storage" : var.storage_definitions,
            "gpu" : var.gpu,
            "mfa" : var.mfa
        }))
      }
    }

    dynamic "ignore_difference" {
      for_each = var.ignore_differences
      content {
        group               = try(ignore_difference.value.group, null)
        kind                = try(ignore_difference.value.kind, null)
        jq_path_expressions = try(ignore_difference.value.jq_path_expressions, null)
      }
    }
    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false", "ServerSideApply=${var.server_side}"]
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
    labels = {
      #   "recurring-job-group.longhorn.io/source" = "enabled"
      #   "recurring-job-group.longhorn.io/backup" = try(each.value.backup,"disabled")
      "recurring-job.longhorn.io/backup" = try(each.value.backup, "disabled")
    }
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
