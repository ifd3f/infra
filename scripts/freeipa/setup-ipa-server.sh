#!/bin/bash

# comma-separated ntp: 0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
# comma-separated dns: 192.168.1.254,8.8.8.8,8.8.4.4

ipa-server-install \
    --skip-mem-check \
    --hostname=ipa0.p.astrid.tech \
    --domain=p.astrid.tech \
    --realm=P.ASTRID.TECH \
    --mkhomedir \
    --setup-kra \
    --setup-dns \
    --zonemgr=astrid@astrid.tech \
    --forwarder=8.8.8.8 \
    --forwarder=8.8.4.4 \
    --ntp-server=0.pool.ntp.org \
    --ntp-server=1.pool.ntp.org \
    --ntp-server=2.pool.ntp.org \
    --ntp-server=3.pool.ntp.org \
    --ds-password=$DS_PASSWORD \
    --admin-password=$ADMIN_PASSWORD \
    --unattended
