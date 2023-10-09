variable "pv_name" {
  description = "The name for the persistent volume."
  type        = string
  default     = "media"
}

variable "pv_capacity" {
  description = "The capacity of the persistent volume."
  type        = string
  default     = "9300"
}

variable "pv_access_modes" {
  description = "The access modes for the persistent volume."
  type        = list(string)
  default     = ["ReadWriteMany"]
}

variable "nfs_server_ip" {
  description = "The IP of the NFS server."
  type        = string
  default     = "" // You should provide this value, no default set.
}

variable "nfs_server_path" {
  description = "The path on the NFS server for the volume."
  type        = string
  default     = "/mnt/external-disk-2/nfs/pvs/media/"
}

variable "storage_class_name" {
  description = "The storage class name."
  type        = string
  default     = "" // Assuming it should be provided and not given a default.
}
