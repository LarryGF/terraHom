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