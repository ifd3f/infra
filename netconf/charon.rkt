#lang racket

(require "util.rkt")
(require "dn42.rkt")
(require "vyos-firewall.rkt")

(define upstream-addr4 "169.254.0.1")
(define upstream-addr6 "fd67:0113:7c37:3339::1")
(define wan "eth0")
(define k8sbr "eth1")

(define commands
  `[(set system host-name "charon")
    ,(basic-vyos-conf)

    (delete interfaces)
    (set interfaces [(loopback lo)
                     (ethernet ,wan [(hw-id "52:54:00:0c:b0:df")
                                     (description "Inter-router network")
                                     (address "169.254.0.2/24")
                                     (address "fd67:0113:7c37:3339::2/64")])
                     (ethernet ,k8sbr [(hw-id "52:54:00:06:8c:9a")
                                       (description "k8sbr")
                                       (address "fca7:b01:f00d:c00b::1/64")
                                       (address "2001:5a8:4002:9388::1/64")])])

    (delete protocols static)
    (set protocols static [(route "0.0.0.0/0" [(next-hop ,upstream-addr4)
                                               (interface ,wan)])
                           (route6 "::/0" [(next-hop ,upstream-addr6)
                                           (interface ,wan)])])

    (delete service router-advert)
    (set service router-advert interface ,k8sbr [(prefix "fca7:b01:f00d:c00b::/64")
                                                 (prefix "2001:5a8:4002:9388::/64")
                                                 (name-server "fca7:b01:f00d:c00b::1")
                                                 (default-preference high)])])


(for ([s (commandtree->strings commands)])
  (displayln s))
