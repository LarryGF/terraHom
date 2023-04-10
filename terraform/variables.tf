

## DuckDNS
variable "duckdns_token" {
  type        = string
  description = "Token for your DuckDNS account"
}
variable "duckdns_domain" {
  type        = string
  description = "Domain for your DuckDNS account"
}
variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

## Rancher
variable "rancher" {
  type = object({
    source_range      = string
    letsencrypt_email = string
  })
  }

# variable "source_range" {
#   type        = string
#   description = "Ingress allowed source range"
# }
# variable "letsencrypt_email" {
#   type        = string
#   description = "Email to register SSL certificates"
# }


## Adguard
variable "key_path" {
  type        = string
  description = "Path for the Priate Key in home assistant"
}

## Traefik
variable "traefik" {
  type = object({
    log_level          = string
    access_log_enabled = bool
  })
}
