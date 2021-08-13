#!/bin/vbash

source /opt/vyatta/etc/functions/script-template
configure

set system host-name 'edgefw.s.astrid.tech'

set system ntp server 1.pool.ntp.org
set system ntp server 2.pool.ntp.org

set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description 'WAN'
delete interfaces ethernet eth0 hw-id

set system ntp server '0.vyos.pool.ntp.org'
set system ntp server '1.vyos.pool.ntp.org'
set system ntp server '2.vyos.pool.ntp.org'

set service ssh 

commit
save
exit