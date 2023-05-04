resource "argocd_repository_credentials" "default-creds" {
  url      = var.gh_base_repo
  username = var.gh_username
  password = var.gh_token
}

resource "argocd_repository" "default-repo" {
  repo = var.gh_base_repo
  name = "pi-k8s"
  type = "git"
}