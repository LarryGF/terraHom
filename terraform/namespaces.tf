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

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    annotations = {
      name = "CertManager"
    }
    name = "cert-manager"
  }
}
