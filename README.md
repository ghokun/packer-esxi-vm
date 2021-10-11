# Creating VMs on ESXi using Packer

## What is this?
This repository is a POC for creating VMs on ESXi using Packer. Things work like this:
- Packer downloads ISO and uploads to ESXi
- Packer creates VM on ESXi using SSH
- Packer hosts a web server on the jumpstart machine
- Packer modifies boot command using VNC (Presses buttons interactively)
- Boot command contains link to the jumpstart machine's web server
- Cloud init is triggered with `user-data` and `meta-data` files.
## Prerequisites

- A jumpstart machine (You will run commands using this machine)
- A VMware ESXi machine with SSH enabled (You will run commands against this machine)
- [Optional] DHCP Server if you want to use DHCP to assign IPs to VMs

## Before You Start
#### On jumpstart
- Install [packer](https://www.packer.io/) on jumpstart machine.
- [Optional] If you want to power on VM after creation:
```bash
# Copy public key to ESXi host
ssh-copy-id root@esxi

# Login
ssh root@esxi

# Move authorized keys file, assuming you are using root user.
# Change keys-root to keys-<user> if you are logged in as a different user.
mv /.ssh/authorized_keys /etc/ssh/keys-root/authorized_keys

# Uncomment following lines in ubuntu2004.pkr.hcl
# post-processor "shell-local" {
#   inline = [
#     "vmId=$(ssh ${var.remote_username}@${var.remote_host} vim-cmd vmsvc/getallvms | grep ubuntu2004 | awk '{print $1}') && ssh ${var.remote_username}@${var.remote_host} vim-cmd vmsvc/power.on $vmId >> /dev/null"
#   ]
# }
```
#### On ESXi
- Before using a remote vSphere Hypervisor, you need to enable GuestIPHack and VNC ports from ESXi firewall. We will use `local.sh` script for this purpose:

```bash
# Copy init script to ESXi host via SSH
scp local.sh root@esxi:/etc/rc.local.d/local.sh

# Login
ssh root@esxi

# Make init script executable on ESXi host
chmod +x /etc/rc.local.d/local.sh

# Execute init script on ESXi host once
/etc/rc.local.d/local.sh
```

- Thanks to [chrisipa](https://github.com/chrisipa/packer-esxi/blob/master/local.sh) for this script.


## Run Packer
```bash
# Uncomment for detailed log
# export PACKER_LOG=1
# export PACKER_LOG_PATH="packer.log"

# Edit following files according to your needs
# ubuntu2004.pkr.hcl : VM settings
# variables.pkr.hcl  : General connection variables
# http/user-data     : Cloud init user-data (check references)
# http/meta-data     : Cloud init meta-data (check references)
packer build .

# or add variables to your command
packer build \
  -var 'datastore=VM' \
  -var 'cache_datastore=CACHE' \
  -var 'remote_host=esxi' \
  -var 'remote_username=root' \
  -var 'remote_password=password' .
```

## References
- https://github.com/chrisipa/packer-esxi
- https://www.packer.io/docs/builders/vmware/iso
- https://ubuntu.com/server/docs/install/autoinstall-reference