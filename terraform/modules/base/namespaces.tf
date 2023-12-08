resource "kubernetes_namespace" "services" {
  metadata {
    annotations = {
      name = "Services"
    }
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
    }
    name = "services"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "Monitoring"
    }
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
    }
    name = "monitoring"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_namespace" "gitops" {
  metadata {
    annotations = {
      name = "GitOps"
    }
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
    }
    name = "gitops"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "authelia" {
  metadata {
    annotations = {
      name = "Authelia"
    }
    name = "authelia"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "authentik" {
  metadata {
    annotations = {
      name = "Authentik"
    }
    name = "authentik"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "crowdsec" {
  metadata {
    annotations = {
      name = "Crowdsec"
    }
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
    }
    name = "crowdsec"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_namespace" "rancher" {
  metadata {
    annotations = {
      name = "Rancher"
    }
    name = "cattle-system"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "operators" {
  metadata {
    annotations = {
      name = "Operators"
    }
    name = "operators"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}

resource "kubernetes_namespace" "node-feature-discovery" {
  metadata {
    annotations = {
      name = "node-feature-discovery"
    }
    name = "node-feature-discovery"
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations
    ]
  }
}
