resource "null_resource" "homer-config" {
  triggers = {
    filename   = "${path.module}/homer-config.json"
    always_run = "${timestamp()}"

  }

  provisioner "local-exec" {
    environment = {
      MODULES_TO_RUN = jsonencode(var.modules_to_run)
      COMMON_CONFIG  = jsonencode(local.common)
      MESSAGE        = jsonencode(local.message)
      DOMAIN         = var.duckdns_domain
    }
    working_dir = path.module
    command     = "python generate_config.py > output.log"
  }

}

data "local_file" "config" {
  filename = null_resource.homer-config.triggers.filename
}

variable "modules_to_run" {
  type        = list(string)
  description = "The modules that will get deployed in each run, each consecutive run should include all previous modules"
}

variable "duckdns_domain" {
  type        = string
  description = "DuckDNS domain to use"
}

output "config_path" {
  value = "${path.module}/homer-config.json"
}

output "config_cotent" {
  value = yamlencode(jsondecode(data.local_file.config.content))
}
