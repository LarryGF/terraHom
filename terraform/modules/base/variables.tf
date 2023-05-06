## Cert Manager

variable "letsencrypt_server" {
  type        = string
  description = "Let's Encrypt server to use"
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

## Traefik

variable "source_range" {
  type        = string
  description = "Source range to restrict traffic to internal services"
}

variable "log_level" {
  type        = string
  description = "Traefik Log Level"
  default     = "DEBUG"
}

variable "access_log_enabled" {
  type        = string
  description = "Enable access logs for Traefik"
  default     = true
}

## DuckDNS

variable "duckdns_token" {
  type        = string
  description = "DuckDNS token to use"
}

## Longhorn

variable "default_data_path" {
  type        = string
  description = "Default Data Path"
  default     = "/storage01"
}

variable "media_storage_size" {
  type        = string
  description = "Size of the media PVC"
}

variable "nfs_backupstore" {
  type        = string
  description = "Default NFS for backups"
}



## ArgoCD
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

## Global

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email to use for Let's Encrypt certificates"
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"

}
variable "master_ip" {
  type        = string
  description = "IP for the master node"

}

variable "vpn_config" {
  type        = string
  description = "Wireguard base64 encoded config"

}

variable "nfs_server" {
  type        = string
  description = "IP address of NFS server"
}

## Operational
variable "modules_to_run" {
  type        = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
  default = [
    "longhorn"
  ]
}