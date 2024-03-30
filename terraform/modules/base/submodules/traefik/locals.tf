locals {

  middleware_files = fileset("${path.module}/middlewares", "*.tpl.yaml")
  my_ip            = jsondecode(data.http.my_public_ip.response_body)["origin"]
  # Get updated cloudflare Ips from https://www.cloudflare.com/ips-v4
}
