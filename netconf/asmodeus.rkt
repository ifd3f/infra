#lang racket

(require "util.rkt")
(require "dn42.rkt")
(require "vyos-firewall.rkt")

(define wg-privkey (getenv "WG_PRIVKEY")) ; TODO: get from env

(define commands
  `((delete protocols bgp)
    (delete firewall)

    ; bunch of default crap
    (set interfaces ethernet eth0 address "dhcp")
    (set interfaces ethernet eth0 hw-id "52:54:00:40:30:53")
    (set interfaces loopback lo)
    (set protocols static route 0.0.0.0/0 next-hop 192.168.122.1)
    (set service ntp allow-client address "0.0.0.0/0")
    (set service ntp allow-client address "::/0")
    (set service ntp server time1.vyos.net)
    (set service ntp server time2.vyos.net)
    (set service ntp server time3.vyos.net)
    (set service ssh port "22")
    (set system config-management commit-revisions "10000")
    (set system conntrack modules ftp)
    (set system conntrack modules h323)
    (set system conntrack modules nfs)
    (set system conntrack modules pptp)
    (set system conntrack modules sip)
    (set system conntrack modules sqlnet)
    (set system conntrack modules tftp)
    (set system console device ttyS0 speed "115200")
    (set system host-name "asmodeus")
    (set system login user vyos authentication public-keys chungus key "AAAAC3NzaC1lZDI1NTE5AAAAIEl4yuE1X4IqjBqt/enMyZFZKJQLxeq34BTCNqey59aZ")
    (set system login user vyos authentication public-keys chungus type "ssh-ed25519")
    (set system name-server "8.8.4.4")
    (set system name-server "8.8.8.8")
    (set system syslog global facility all level "info")
    (set system syslog global facility local7 level "debug")

    ,(dn42/rpki)
    ,(dn42/bgp-setup)
    ,(dn42/bgp-group)
    ,(dn42/route-collector)
    ,(dn42/wireguard-ll-peer #:name "whojk"
                             #:our-ll-address "fe80::1846/64"
                             #:our-private-key wg-privkey
                             #:our-endpoint-port '()
                             #:peer-ll-address "fe80::2717"
                             #:peer-endpoint (cons "141.148.191.208" 24210)
                             #:peer-asn 4242422717
                             #:peer-public-key "SpnH/BlVNDx5QiMxHhuF4i8hKr5qWMxnPYky6Mp4fEA=")
    ,(firewall/network-group "dn42-allowed-transit" dn42-allowed-transit-addrs)
    ,(firewall/network-group "ifd3f-dn42" ifd3f-dn42-addrs)
    ,(router-rules)
    ,(afall (dn42-tunnels-in))

    ; address for testing
    (set interfaces wireguard wg4242422717 address "fd00:ca7:b015:7e57::7e57/64")))

(for ([s (commandtree->strings commands)])
  (displayln s))