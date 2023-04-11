# Home Assistant (https://www.home-assistant.io/)
# resource "helm_release" "home-asssitant" {
#   name       = "home-assistant"
#   chart      = "home-assistant"
#   repository = "https://k8s-at-home.com/charts/"

#   values = [file("../helm/home-assistant/home-assistant-values.yaml")]

#   set {
#     name = "env.TZ"
#     value = var.timezone 
#   }

#   set {
#     name = "addons.codeserver.git.deployKeyBase64"
#     value = base64encode(file(var.key_path))
#   }

#   depends_on = []
#   cleanup_on_fail = true
#   wait = true
#   wait_for_jobs = true
#   timeout = 600
# }

resource "kubectl_manifest" "middlewares" {
  for_each = local.middleware_files

  yaml_body = templatefile(
    "../helm/infrastructure/traefik/middleware/${each.value}",
    {
      "source_range" = split(",", var.rancher["source_range"])
      "namespace"    = "internal-services"
    }
  )

  depends_on = [helm_release.traefik]
}

resource "helm_release" "duckdns" {
  name       = "duckdns-go"
  chart      = "duckdns-go"
  repository = "https://ebrianne.github.io/helm-charts"
  namespace  = "internal-services"

  values = [templatefile("../helm/services/duckdns/duckdns-values.yaml",
    {
      token    = var.duckdns_token
      domains  = var.duckdns_domain
      timezone = var.timezone
  })]

  depends_on      = []
  cleanup_on_fail = true
  wait            = true
  wait_for_jobs   = true
  timeout         = 600
}

# Adguard Home (https://adguard.com/adguard-home.html)
resource "helm_release" "adguard-home" {
  name       = "adguard"
  chart      = "adguard-home"
  repository = "https://k8s-at-home.com/charts/"
  namespace  = "internal-services"

  set {
    name  = "env.TZ"
    value = var.timezone
  }

  values = [templatefile("../helm/services/adguard/adguard-values.yaml", {
    duckdns_domain = var.duckdns_domain,
    dns_rewrites   = file("../helm/services/adguard/dns-rewrites.yaml")
  })]

  recreate_pods = true

  depends_on = []
}

resource "helm_release" "error-pages" {
  name       = "error-pages"
  chart      = "error-pages"
  repository = "https://k8s-at-home.com/charts"
  namespace  = "internal-services"
  values = [
    templatefile(
      "../helm/services/error-pages/error-pages-values.yaml",
      {
        timezone = var.timezone
      }
    )
  ]
  
  depends_on = [helm_release.traefik]
}

# resource "helm_release" "kube_prometheus" {
#   name       = "kube-prometheus-stack"
#   chart      = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   namespace  = "internal-services"

#   values = [templatefile("../helm/kube-prometheus/kube-prometheus-values.yaml",
#     {
#       token    = var.duckdns_token
#       domains  = var.duckdns_domain
#       timezone = var.timezone
#   })]

#   depends_on      = []
#   cleanup_on_fail = true
#   wait            = true
#   wait_for_jobs   = true
#   timeout         = 600
# }
