#!/bin/vbash
export SSH_KEY_LOC=/tmp/id_rsa.pub

export key_type=$(cat $SSH_KEY_LOC | sed 's/\(.*\) .* .*/\1/g')
export key_contents=$(cat $SSH_KEY_LOC | sed 's/.* \(.*\) .*/\1/g')
export key_user=$(cat $SSH_KEY_LOC | sed 's/.* .* \(.*\)/\1/g')

source /opt/vyatta/etc/functions/script-template
configure

set system host-name 'edgefw.s.astrid.tech'

set system ntp server '0.vyos.pool.ntp.org'
set system ntp server '1.vyos.pool.ntp.org'
set system ntp server '2.vyos.pool.ntp.org'

set system login user vyos authentication public-keys $key_user type $key_type
set system login user vyos authentication public-keys $key_user key $key_contents
set service ssh 

set interfaces ethernet eth0 address dhcp
set interfaces ethernet eth0 description 'WAN'
delete interfaces ethernet eth0 hw-id

commit
save
exit
