variable "argocd_password" {
    type        = string
    description = "ArgoCD password"

}


variable "gh_base_repo" {
  type        = string
  description = "Standard repo to use for ArgoCD"
  default = "https://github.com/LarryGF/pi-k8s.git"
}