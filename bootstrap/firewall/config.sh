#!/bin/vbash
source /opt/vyatta/etc/functions/script-template
configure

set system host-name 'edgefw.s.astrid.tech'

set system name-server 8.8.8.8
set system name-server 8.8.4.4

set system ntp server 1.pool.ntp.org
set system ntp server 2.pool.ntp.org

set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description 'OUTSIDE'
set interfaces ethernet eth1 address '10.0.1.1/24'
set interfaces ethernet eth1 description 'INSIDE'

commit
save
exit