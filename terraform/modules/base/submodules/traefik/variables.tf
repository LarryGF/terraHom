variable "source_range" {
  type        = string
  description = "Source range to restrict traffic to internal services"
}

variable "source_range_ext" {
  type        = string
  description = "Source range to restrict traffic to internal services from the internet"
}

variable "namespace" {
  type        = string
  description = "Namespace in which to deploy the resources"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "log_level" {
  type        = string
  description = "Traefik Log Level"
  default = "DEBUG"
}

variable "access_log_enabled" {
  type        = string
  description = "Enable access logs for Traefik"
  default = true
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"
  
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}