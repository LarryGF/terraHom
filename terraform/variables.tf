variable "letsencrypt_email" {
  type = string
  description = "Email to register SSL certificates"
}

variable "timezone" {
  type = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "duckdns_token" {
  type = string
  description = "Token for your DuckDNS account"
}

variable "duckdns_domains" {
  type = string
  description = "Domains for your DuckDNS account"
}