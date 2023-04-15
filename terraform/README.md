<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.9 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.19.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adguard"></a> [adguard](#module\_adguard) | ./modules/adguard | n/a |
| <a name="module_bazarr"></a> [bazarr](#module\_bazarr) | ./modules/bazarr | n/a |
| <a name="module_cert-manager"></a> [cert-manager](#module\_cert-manager) | ./modules/cert-manager | n/a |
| <a name="module_duckdns"></a> [duckdns](#module\_duckdns) | ./modules/duckdns | n/a |
| <a name="module_heimdall"></a> [heimdall](#module\_heimdall) | ./modules/heimdall | n/a |
| <a name="module_jackett"></a> [jackett](#module\_jackett) | ./modules/jackett | n/a |
| <a name="module_radarr"></a> [radarr](#module\_radarr) | ./modules/radarr | n/a |
| <a name="module_rancher"></a> [rancher](#module\_rancher) | ./modules/rancher | n/a |
| <a name="module_sonarr"></a> [sonarr](#module\_sonarr) | ./modules/sonarr | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |
| <a name="module_traefik"></a> [traefik](#module\_traefik) | ./modules/traefik | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.internal-services](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.public-services](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.backup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_enabled"></a> [access\_log\_enabled](#input\_access\_log\_enabled) | Enable access logs for Traefik | `string` | `true` | no |
| <a name="input_default_data_path"></a> [default\_data\_path](#input\_default\_data\_path) | Default Data Path | `string` | `"/storage01"` | no |
| <a name="input_duckdns_domain"></a> [duckdns\_domain](#input\_duckdns\_domain) | DuckDNS domain to use | `string` | n/a | yes |
| <a name="input_duckdns_token"></a> [duckdns\_token](#input\_duckdns\_token) | DuckDNS token to use | `string` | n/a | yes |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use for Let's Encrypt certificates | `string` | n/a | yes |
| <a name="input_letsencrypt_server"></a> [letsencrypt\_server](#input\_letsencrypt\_server) | Let's Encrypt server to use | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Traefik Log Level | `string` | `"DEBUG"` | no |
| <a name="input_source_range"></a> [source\_range](#input\_source\_range) | Source range to restrict traffic to internal services | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone in this format: https://www.php.net/manual/en/timezones.php | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert-manager-status"></a> [cert-manager-status](#output\_cert-manager-status) | n/a |
<!-- END_TF_DOCS -->