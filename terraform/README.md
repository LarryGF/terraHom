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
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.20.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adguardhome"></a> [adguardhome](#module\_adguardhome) | ./modules/adguard | n/a |
| <a name="module_bazarr"></a> [bazarr](#module\_bazarr) | ./modules/bazarr | n/a |
| <a name="module_cert-manager"></a> [cert-manager](#module\_cert-manager) | ./modules/cert-manager | n/a |
| <a name="module_duckdns"></a> [duckdns](#module\_duckdns) | ./modules/duckdns | n/a |
| <a name="module_duplicati"></a> [duplicati](#module\_duplicati) | ./modules/duplicati | n/a |
| <a name="module_filebrowser"></a> [filebrowser](#module\_filebrowser) | ./modules/filebrowser | n/a |
| <a name="module_flood"></a> [flood](#module\_flood) | ./modules/rtorrent | n/a |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | ./modules/grafana | n/a |
| <a name="module_home-assistant"></a> [home-assistant](#module\_home-assistant) | ./modules/home-assistant | n/a |
| <a name="module_homer"></a> [homer](#module\_homer) | ./modules/homer | n/a |
| <a name="module_jellyfin"></a> [jellyfin](#module\_jellyfin) | ./modules/jellyfin | n/a |
| <a name="module_jellyseerr"></a> [jellyseerr](#module\_jellyseerr) | ./modules/jellyseerr | n/a |
| <a name="module_loki"></a> [loki](#module\_loki) | ./modules/loki | n/a |
| <a name="module_longhorn"></a> [longhorn](#module\_longhorn) | ./modules/longhorn | n/a |
| <a name="module_mylar"></a> [mylar](#module\_mylar) | ./modules/mylar | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ./modules/prometheus | n/a |
| <a name="module_promtail"></a> [promtail](#module\_promtail) | ./modules/promtail | n/a |
| <a name="module_prowlarr"></a> [prowlarr](#module\_prowlarr) | ./modules/prowlarr | n/a |
| <a name="module_radarr"></a> [radarr](#module\_radarr) | ./modules/radarr | n/a |
| <a name="module_readarr"></a> [readarr](#module\_readarr) | ./modules/readarr | n/a |
| <a name="module_sabnzbd"></a> [sabnzbd](#module\_sabnzbd) | ./modules/sabnzbd | n/a |
| <a name="module_sonarr"></a> [sonarr](#module\_sonarr) | ./modules/sonarr | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |
| <a name="module_traefik"></a> [traefik](#module\_traefik) | ./modules/traefik | n/a |
| <a name="module_whisparr"></a> [whisparr](#module\_whisparr) | ./modules/whisparr | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.cert-manager](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.services](https://registry.terraform.io/providers/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.backup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_enabled"></a> [access\_log\_enabled](#input\_access\_log\_enabled) | Enable access logs for Traefik | `string` | `true` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | Allowed local networks with lonng netmask: 192.168.1.0/255.255.255.0 | `string` | n/a | yes |
| <a name="input_default_data_path"></a> [default\_data\_path](#input\_default\_data\_path) | Default Data Path | `string` | `"/storage01"` | no |
| <a name="input_duckdns_domain"></a> [duckdns\_domain](#input\_duckdns\_domain) | DuckDNS domain to use | `string` | n/a | yes |
| <a name="input_duckdns_token"></a> [duckdns\_token](#input\_duckdns\_token) | DuckDNS token to use | `string` | n/a | yes |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email to use for Let's Encrypt certificates | `string` | n/a | yes |
| <a name="input_letsencrypt_server"></a> [letsencrypt\_server](#input\_letsencrypt\_server) | Let's Encrypt server to use | `string` | `"https://acme-v02.api.letsencrypt.org/directory"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Traefik Log Level | `string` | `"DEBUG"` | no |
| <a name="input_master_hostname"></a> [master\_hostname](#input\_master\_hostname) | Hostname for the master node | `string` | n/a | yes |
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