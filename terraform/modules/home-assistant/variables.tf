variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

variable "timezone" {
  type        = string
  description = "Timezone in this format: https://www.php.net/manual/en/timezones.php"
}

variable "master_hostname" {
  type        = string
  description = "Hostname for the master node"
  
}

