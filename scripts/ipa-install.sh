#!/bin/bash

# since we're running in a LXC, we can't have ntp
ipa-server-install \
    --no-ntp \ 
    --hostname=ipa0.id.astrid.tech \
    --domain=id.astrid.tech \
    --realm=ID.ASTRID.TECH \
    --mkhomedir \
    --setup-kra \
    --setup-dns \
    --zonemgr=astrid@astrid.tech \
    --forwarder=8.8.8.8 \
    --forwarder=8.8.4.4 \
    --ds-password=$DS_PASSWORD \
    --admin-password=$ADMIN_PASSWORD \
    --unattended

