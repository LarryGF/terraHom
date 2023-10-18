resource "kubernetes_namespace" "services" {
  metadata {
    annotations = {
      name = "Services"
    }
    name = "services"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "Monitoring"
    }
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "gitops" {
  metadata {
    annotations = {
      name = "GitOps"
    }
    name = "gitops"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "authelia" {
  metadata {
    annotations = {
      name = "Authelia"
    }
    name = "authelia"
  }
}

resource "kubernetes_namespace" "crowdsec" {
  metadata {
    annotations = {
      name = "Crowdsec"
    }
    name = "crowdsec"
  }
}

resource "kubernetes_namespace" "rancher" {
  metadata {
    annotations = {
      name = "Rancher"
    }
    name = "cattle-system"
  }
}
