variable "gh_base_repo" {
  type        = string
  description = "Standard repo to use for ArgoCD"
  default = "https://github.com/LarryGF/pi-k8s.git"
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
