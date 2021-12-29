<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.4 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert-manager](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.home-asssitant](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.letsencrypt-issuer](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.cattle-system](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to register SSL certificates | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone in this format: https://www.php.net/manual/en/timezones.php | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->