source "vmware-iso" "ubuntu2004" {
  # ISO file to use
  iso_url             = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum        = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  guest_os_type       = "ubuntu-64"
  tools_upload_flavor = "linux"

  # ESXi Host settings
  remote_type            = "esx5"
  remote_datastore       = ""
  remote_cache_datastore = ""
  remote_host            = "esxi"
  remote_port            = 22
  remote_username        = ""
  remote_password        = ""
  vnc_disable_password   = true
  headless               = false

  # VM settings
  vm_name          = "ubuntu2004"
  cpus             = 4
  memory           = 8192
  disk_type_id     = "thin"
  disk_size        = 48000
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  ssh_timeout      = "30m"
  shutdown_command = "shutdown -P now"
  vmx_data = {
    "ethernet0.networkName" = "VM Network"
  }

  # Boot
  http_directory = "http"
  boot_wait      = "5s"
  boot_command = [
    "<esc><wait><esc><wait><f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ",
    "--- <enter>"
  ]
}

build {
  sources = ["sources.vmware-iso.ubuntu2004"]
}
