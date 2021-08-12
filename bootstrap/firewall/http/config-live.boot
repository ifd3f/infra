system {
    host-name edgefw
    login {
        user vyos {
            authentication {
                encrypted-password '$6$QxPS.uk6mfo$9QBSo8u1FkH16gMyAVhus6fU3LOzvLR9Z9.82m3tiHFAxTtIkhaZSWssSgzt4v4dGAL8rhVQxTg0oAG9/q11h/'
                plaintext-password ''
            }
            level admin
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    ntp {
        server '0.vyos.pool.ntp.org'
        server '1.vyos.pool.ntp.org'
        server '2.vyos.pool.ntp.org'
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    config-management {
        commit-revisions 100
    }
}

service {
    /*
    dhcp-server {
        shared-network-name lan {
            authoritative
            subnet 10.0.1.0/24 {
                range 0 {
                    start 10.3.1.100
                    stop 10.3.1.255
                }
            }
        }
    }
    */

    ssh {
        #disable-password-authentication
        disable-host-validation
    }
}

interfaces {
    loopback lo {
    }
    /*
    ethernet wan {
        description "WAN"
        address dhcp 
        hw-id 52:54:00:12:08:00
    }
    ethernet lan {
        description "LAN"
        address 10.3.1.0/24
        hw-id 52:54:00:12:08:01
    }
    */
}
