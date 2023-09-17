variable "argocd_password" {
    type        = string
    description = "ArgoCD password"

}

variable "gh_username" {
  type        = string
  description = "GH username to access default repo"
}

variable "gh_token" {
  type        = string
  description = "GH access token to access default repo"
}


variable "gh_base_repo" {
  type        = string
  description = "Standard repo to use for ArgoCD"
  default = "https://github.com/LarryGF/pi-k8s.git"
}

variable "domain" {
  type        = string
  description = "Domain to use"
}