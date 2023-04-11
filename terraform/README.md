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
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.9.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.adguard-home](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.cert-manager](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.duckdns](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.error-pages](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.traefik](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.letsencrypt-issuer](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.middlewares](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.cattle-system](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.internal-services](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_duckdns_domain"></a> [duckdns\_domain](#input\_duckdns\_domain) | Domain for your DuckDNS account | `string` | n/a | yes |
| <a name="input_duckdns_token"></a> [duckdns\_token](#input\_duckdns\_token) | Token for your DuckDNS account | `string` | n/a | yes |
| <a name="input_key_path"></a> [key\_path](#input\_key\_path) | Path for the Priate Key in home assistant | `string` | n/a | yes |
| <a name="input_rancher"></a> [rancher](#input\_rancher) | # Rancher | <pre>object({<br>    source_range      = string<br>    letsencrypt_email = string<br>  })</pre> | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone in this format: https://www.php.net/manual/en/timezones.php | `string` | n/a | yes |
| <a name="input_traefik"></a> [traefik](#input\_traefik) | # Traefik | <pre>object({<br>    log_level          = string<br>    access_log_enabled = bool<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->