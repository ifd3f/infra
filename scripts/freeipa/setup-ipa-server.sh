#!/bin/bash

# comma-separated ntp: 0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
# comma-separated dns: 192.168.1.254,8.8.8.8,8.8.4.4

ipa-server-install \
    --skip-mem-check \
    --allow-zone-overlap \
    --hostname=ipa0.cloud.astrid.tech \
    --domain=cloud.astrid.tech \
    --realm=CLOUD.ASTRID.TECH \
    --mkhomedir \
    --no-dnssec-validation \
    --pki-config-override /root/pki-conf \
    --setup-kra \
    --setup-dns \
    --zonemgr=astrid@astrid.tech \
    --forwarder=192.168.1.254 \
    --forwarder=8.8.8.8 \
    --forwarder=8.8.4.4 \
    --ds-password=$DS_PASSWORD \
    --admin-password=$ADMIN_PASSWORD \
    --unattended 
