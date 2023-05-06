<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | ~> 5.2.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.9 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.7 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argocd_application"></a> [argocd\_application](#module\_argocd\_application) | ./modules/argocd_application | n/a |
| <a name="module_base"></a> [base](#module\_base) | ./modules/base | n/a |
| <a name="module_gitops"></a> [gitops](#module\_gitops) | ./modules/gitops | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_enabled"></a> [access\_log\_enabled](#input\_access\_log\_enabled) | Enable access logs for Traefik | `string` | `true` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | Allowed local networks with lonng netmask: 192.168.1.0/255.255.255.0 | `string` | n/a | yes |
| <a name="input_default_data_path"></a> [default\_data\_path](#input\_default\_data\_path) | Default Data Path | `string` | `"/storage01"` | no |
| <a name="input_duckdns_domain"></a> [duckdns\_domain](#input\_duckdns\_domain) | DuckDNS domain to use | `string` | n/a | yes |
| <a name="input_duckdns_token"></a> [duckdns\_token](#input\_duckdns\_token) | DuckDNS token to use | `string` | n/a | yes |
| <a name="input_gh_base_repo"></a> [gh\_base\_repo](#input\_gh\_base\_repo) | Standard repo to use for ArgoCD | `string` | `"https://github.com/LarryGF/pi-k8s.git"` | no |
| <a name="input_gh_token"></a> [gh\_token](#input\_gh\_token) | GH access token to access default repo | `string` | n/a | yes |
| <a name="input_gh_username"></a> [gh\_username](#input\_gh\_username) | GH username to access default repo | `string` | n/a | yes |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use for Let's Encrypt certificates | `string` | n/a | yes |
| <a name="input_letsencrypt_server"></a> [letsencrypt\_server](#input\_letsencrypt\_server) | Let's Encrypt server to use | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Traefik Log Level | `string` | `"DEBUG"` | no |
| <a name="input_master_hostname"></a> [master\_hostname](#input\_master\_hostname) | Hostname for the master node | `string` | n/a | yes |
| <a name="input_master_ip"></a> [master\_ip](#input\_master\_ip) | IP for the master node | `string` | n/a | yes |
| <a name="input_media_storage_size"></a> [media\_storage\_size](#input\_media\_storage\_size) | Size of the media PVC | `string` | n/a | yes |
| <a name="input_modules_to_run"></a> [modules\_to\_run](#input\_modules\_to\_run) | The modules that will get deployed in each run, each consecutive run should include all previous modules | `list(string)` | <pre>[<br>  "adguard",<br>  "bazarr",<br>  "cert-manager",<br>  "duckdns",<br>  "heimdall",<br>  "jackett",<br>  "radarr",<br>  "rancher",<br>  "sonarr",<br>  "storage",<br>  "traefik"<br>]</pre> | no |
| <a name="input_nfs_backupstore"></a> [nfs\_backupstore](#input\_nfs\_backupstore) | Default NFS for backups | `string` | n/a | yes |
| <a name="input_nfs_server"></a> [nfs\_server](#input\_nfs\_server) | IP address of NFS server | `string` | n/a | yes |
| <a name="input_source_range"></a> [source\_range](#input\_source\_range) | Source range to restrict traffic to internal services | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone in this format: https://www.php.net/manual/en/timezones.php | `string` | n/a | yes |
| <a name="input_vpn_config"></a> [vpn\_config](#input\_vpn\_config) | Wireguard base64 encoded config | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->