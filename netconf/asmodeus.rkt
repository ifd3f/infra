#lang racket

(require "util.rkt")
(require "dn42.rkt")

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
    (set firewall
         (global-options state-policy [(established action accept)
                                       (related action accept)
                                       (invalid action accept)])
         (group network-group
                (dn42-allowed-transit-v4 network
                                         ("10.0.0.0/8")
                                         ("172.20.0.0/14")
                                         ("172.31.0.0/16"))))))

(for ([s (commandtree->strings commands)])
  (displayln s))