module "base" {
  source             = "./modules/base"
  letsencrypt_server = var.letsencrypt_server
  source_range       = var.source_range
  source_range_ext   = var.source_range_ext
  log_level          = var.log_level
  access_log_enabled = var.access_log_enabled
  token              = var.token
  default_data_path  = "${var.nfs_servers["root"]["path"]}/storage"
  nfs_backupstore    = "nfs://${var.nfs_servers["root"]["ip"]}:${var.nfs_servers["root"]["path"]}/nfs/backups"
  gh_username        = var.gh_username
  gh_token           = var.gh_token
  gh_base_repo       = var.gh_base_repo
  sc_name            = local.sc_name
  timezone           = var.timezone
  letsencrypt_email  = var.letsencrypt_email
  domain             = var.domain
  master_hostname    = var.master_hostname
  master_ip          = var.master_ip
  vpn_config         = var.vpn_config
  # nfs_server        = var.nfs_server
  api_keys     = var.api_keys
  use_longhorn = var.use_longhorn
}

module "sandbox" {
  count     = var.use_sandbox ? 1 : 0
  source    = "./modules/sandbox"
  master_ip = var.master_ip

}
