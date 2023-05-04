module "base" {
  source             = "./modules/base"
  letsencrypt_server = var.letsencrypt_server
  source_range       = var.source_range
  log_level          = var.log_level
  access_log_enabled = var.access_log_enabled
  duckdns_token      = var.duckdns_token
  default_data_path  = var.default_data_path
  media_storage_size = var.media_storage_size
  nfs_backupstore    = var.nfs_backupstore
  gh_username        = var.gh_username
  gh_token           = var.gh_token
  gh_base_repo       = var.gh_base_repo

  timezone          = var.timezone
  letsencrypt_email = var.letsencrypt_email
  duckdns_domain    = var.duckdns_domain
  master_hostname   = var.master_hostname
  vpn_config        = var.vpn_config
  nfs_server        = var.nfs_server
  modules_to_run    = var.modules_to_run
}
