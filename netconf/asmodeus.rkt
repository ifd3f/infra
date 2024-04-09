#lang racket

(require "util.rkt")
(require "dn42.rkt")
(require "vyos-firewall.rkt")

(define wg-privkey "testkey") ; TODO: get from env

(define commands
  `(,(dn42/rpki)
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
    ,(router-rules)
    ,(afall (dn42-tunnels-in))))

(for ([s (commandtree->strings commands)])
  (displayln s))