source "vmware-iso" "ubuntu2004" {
  # OS Settings
  iso_url             = "https://releases.ubuntu.com/20.04/ubuntu-20.04.3-live-server-amd64.iso"
  iso_checksum        = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  guest_os_type       = "ubuntu-64"
  tools_upload_flavor = "linux"

  # ESXi Host Settings
  remote_type            = "esx5"
  remote_datastore       = "${var.datastore}"
  remote_cache_datastore = "${var.cache_datastore}"
  remote_host            = "${var.remote_host}"
  remote_port            = 22
  remote_username        = "${var.remote_username}"
  remote_password        = "${var.remote_password}"
  vnc_disable_password   = true
  headless               = false

  # VM settings
  vm_name                = "ubuntu2004"
  cpus                   = 4
  memory                 = 8192
  disk_type_id           = "thin"
  disk_size              = 48000
  ssh_username           = "ubuntu"
  ssh_password           = "ubuntu"
  ssh_timeout            = "30m"
  ssh_handshake_attempts = 100
  shutdown_command       = "echo 'ubuntu' | sudo -S shutdown -P now"
  keep_registered        = true
  skip_export            = true
  skip_compaction        = true
  vmx_data = {
    "ethernet0.networkName" = "VM Network"
  }
  vmx_data_post = {
    "bios.bootOrder" = "hdd"
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
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }
  # Uncomment to power on VM. You need to copy your ssh public key to /etc/ssh/keys-${var.remote_username}/authorized_keys
  # post-processor "shell-local" {
  #   inline = [
  #     "vmId=$(ssh ${var.remote_username}@${var.remote_host} vim-cmd vmsvc/getallvms | grep ubuntu2004 | awk '{print $1}') && ssh ${var.remote_username}@${var.remote_host} vim-cmd vmsvc/power.on $vmId >> /dev/null"
  #   ]
  # }
}
