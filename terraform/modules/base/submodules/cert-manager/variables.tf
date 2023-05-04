variable "letsencrypt_email" {
  type        = string
  description = "Email to use for Let's Encrypt certificates"
}

variable "letsencrypt_server" {
  type        = string
  description = "Let's Encrypt server to use"
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

