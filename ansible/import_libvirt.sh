#!/bin/bash

# Read from the outer network's dhcp
bongus_ip=`cat /var/lib/libvirt/dnsmasq/virbr-outer.status | jq '.[0]["ip-address"]' -r`
cat << EOF | tee inventory/bongus.gen.yaml
ephemeral:
  hosts:
    bongus_fresh:
      # Change as necessary
      ansible_host: $bongus_ip
      ansible_user: fedora
      ansible_ssh_pass: devpassword
      ansible_become_pass: devpassword
      ansible_python_interpreter: /usr/bin/python3
      fqdn: bongus.hv.astrid.tech
      short_hostname: bongus
      interface: ens3
      ip: 192.168.5.2
      cidr: 24
      gateway: 192.168.5.1
EOF