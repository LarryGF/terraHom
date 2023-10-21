resource "kubernetes_namespace" "services" {
  metadata {
    annotations = {
      name = "Services"
    }
    name = "services"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "Monitoring"
    }
    name = "monitoring"
  }
  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "kubernetes_namespace" "gitops" {
  metadata {
    annotations = {
      name = "GitOps"
    }
    name = "gitops"
  }
  lifecycle {
    ignore_changes = [
      metadata
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

resource "kubernetes_namespace" "crowdsec" {
  metadata {
    annotations = {
      name = "Crowdsec"
    }
    name = "crowdsec"
  }
  lifecycle {
    ignore_changes = [
      metadata
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
      metadata
    ]
  }
}
