#!/bin/bash

set -o xtrace  # logging commands as they are run

# since we're running in a LXC, no NTP
ipa-server-install \
    --no-ntp  \
    --hostname=ipa0.id.astrid.tech \
    --domain=id.astrid.tech \
    --realm=ID.ASTRID.TECH \
    --mkhomedir \
    --setup-kra \
    --setup-dns \
    --zonemgr=astrid@astrid.tech \
    --forwarder=$dns0 \
    --forwarder=$dns1 \
    --ds-password=$DS_PASSWORD \
    --admin-password=$ADMIN_PASSWORD \
    --unattended