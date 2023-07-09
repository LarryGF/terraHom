locals {
  kubeconfig_template = <<EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(data.kubernetes_secret_v1.sandbox.data["ca.crt"])}
    server: https://${var.master_ip}:6443
  name: default
contexts:
- context:
    cluster: default
    namespace: sandbox
    user: sandbox-user
  name: sandbox-context
current-context: sandbox-context
kind: Config
preferences: {}
users:
- name: sandbox-user
  user:
    token:  ${data.kubernetes_secret_v1.sandbox.data["token"]}
EOF

}

data "kubernetes_secret_v1" "sandbox" {
  metadata {
    name      = kubernetes_secret_v1.sandbox.metadata.0.name
    namespace = "sandbox"
  }

  depends_on = [ kubernetes_secret_v1.sandbox ]
}

resource "kubernetes_namespace" "sandbox" {
  metadata {
    annotations = {
      name = "Sandbox"
    }
    name = "sandbox"
  }
}

resource "kubernetes_service_account_v1" "sandbox" {
  metadata {
    name = "sandbox-sa"
    namespace = "sandbox"
  }
  secret {
    name = "${kubernetes_secret_v1.sandbox.metadata.0.name}"
  }

}

resource "kubernetes_secret_v1" "sandbox" {
  metadata {
    name = "sandbox-secret"
    namespace = "sandbox"
    annotations = {
      "kubernetes.io/service-account.name" = "sandbox-sa"
    }

  }
  type = "kubernetes.io/service-account-token"

  depends_on = [ kubernetes_namespace.sandbox ]

}

resource "kubernetes_token_request_v1" "sandbox" {
  metadata {
    name = kubernetes_service_account_v1.sandbox.metadata.0.name
    namespace = "sandbox"
  }
  spec {
    audiences = [
      "api",
      "vault",
      "factors"
    ]
  }
}


resource "kubernetes_role" "sandbox" {
  metadata {
    name = "sandbox-role"
    namespace = "sandbox"
  }

  rule {
    api_groups     = ["", "extensions", "apps","batch","autoscaling"]
    resources      = ["*"]
    verbs          = ["*"]
  }

  depends_on = [ kubernetes_namespace.sandbox ]

}

resource "kubernetes_role_binding" "sandbox" {
  metadata {
    name      = "sandbox-rb"
    namespace = "sandbox"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "sandbox-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.sandbox.metadata.0.name
    api_group = ""
    namespace = "sandbox"
  }

  depends_on = [ kubernetes_namespace.sandbox, kubernetes_role.sandbox, kubernetes_service_account_v1.sandbox ]

}

resource "local_file" "kubeconfig" {
  content  = local.kubeconfig_template
  filename = "../kubeconfig.yaml"
}