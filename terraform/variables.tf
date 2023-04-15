## Cert Manager

variable "letsencrypt_server" {
  type        = string
  description = "Let's Encrypt server to use"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

## Traefik

variable "source_range" {
  type        = string
  description = "Source range to restrict traffic to internal services"
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

## DuckDNS

variable "duckdns_token" {
  type        = string
  description = "DuckDNS token to use"
}

## Longhorn

variable "default_data_path" {
  type        = string
  description = "Default Data Path"
  default = "/storage01"
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