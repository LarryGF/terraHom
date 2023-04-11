resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "cattle-system" {
  metadata {
    annotations = {
      name = "Rancher System"
    }
    name = "cattle-system"
  }
}

resource "kubernetes_namespace" "internal-services" {
  metadata {
    annotations = {
      name = "Internal Services"
    }
    name = "internal-services"
  }
}

resource "kubernetes_namespace" "public-services" {
  metadata {
    annotations = {
      name = "Public Services"
    }
    name = "public-services"
  }
}

resource "kubernetes_namespace" "longhorn-system" {
  metadata {
    annotations = {
      name = "Longhorn System"
    }
    name = "longhorn-system"
  }
}