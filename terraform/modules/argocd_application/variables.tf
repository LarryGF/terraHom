variable "gh_base_repo" {
  type        = string
  description = "Standard repo to use for ArgoCD"
  default = "https://github.com/LarryGF/terraHom.git"
}

variable "override_values" {
  type = map(string)
  description = "Values to pass to templatefile to override helm values.yaml"
  default = {}
}

variable "sc_name" {
  type        = string
  description = "Storage class name"

}

variable "name" {
  type        = string
  description = "Application name"

}

variable "namespace" {
  type        = string
  description = "Application namespace"

}

variable "project" {
  type        = string
  description = "Project in which to deploy the application"

}

variable "storage_definitions" {
  type        = map(any)
  description = "Object that contains the definition for the PVCs to create"

}

variable "deploy" {
  type        = bool
  description = "Determines if the app is going to be deployed or not"

}

variable "server_side" {
  type        = string
  default = "false"
  description = "Determines if the app is going to be deployed using server side apply"

}

variable "priority" {
  type        = string
  description = "Determines in which node to run the helm chart"

}

variable "mfa" {
  type        = bool
  description = "If true, the service should be protected by MFA"

}
variable "gpu" {
  type        = string
  description = "Determines which GPU your application will use"
   validation {
    condition     = var.gpu == "none" || var.gpu == "intel" || var.gpu == "amd"
    error_message = "The value must be none, intel or amd\n"
  }

}

variable "ignore_differences" {
  type        = list(any)
  description = "Object that contains the ignore differences for the argocd application"

}