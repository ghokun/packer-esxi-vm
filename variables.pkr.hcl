variable "datastore" {
  type        = string
  default     = "VM"
  description = "The datastore to use for the VM"
}

variable "cache_datastore" {
  type        = string
  default     = "ISO"
  description = "The datastore to use for the ISO"
}

variable "remote_host" {
  type        = string
  default     = "esxi"
  description = "ESXi ip/hostname"
}

variable "remote_username" {
  type        = string
  default     = "root"
  description = "ESXi username"
}

variable "remote_password" {
  type        = string
  default     = "123456"
  description = "ESXi password"
}