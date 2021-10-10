# Creating VMs on ESXi using Packer

## Prerequisites

- A jumpstart machine (You will run commands using this machine)
- A VMware ESXi machine with SSH enabled (You will run commands against this machine)

## Before You Start

- Install [packer](https://www.packer.io/) on jumpstart machine.


- Before using a remote vSphere Hypervisor, you need to enable GuestIPHack by running the following command:
```bash
esxcli system settings advanced set -o /Net/GuestIPHack -i 1
```
