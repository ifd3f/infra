#lang racket

(require "util.rkt")
(require "dn42.rkt")
(require "vyos-firewall.rkt")

(define upstream-ll-addr6 "fe80::5054:ff:fed6:96c")
(define upstream-ll-addr4 "169.254.0.1")
(define wan "eth0")
(define k8sbr "eth1")

(define commands
  `[(set system host-name "charon")
    ,(basic-vyos-conf)

    (delete interfaces)
    (set interfaces [(loopback lo)
                     (ethernet ,wan [(hw-id "52:54:00:0c:b0:df")
                                     (description "Link to upstream firewall")
                                     (address "169.254.0.2/24")])
                     (ethernet ,k8sbr [(hw-id "52:54:00:06:8c:9a")
                                       (description "k8sbr")
                                       (address "fca7:b01:f00d:c00b::1/64")
                                       (address "2001:5a8:4002:9308::1/64")])])

    (set protocols static [(route "0.0.0.0/0" [(next-hop ,upstream-ll-addr4)
                                               (interface ,wan)])
                           (route6 "::/0" [(next-hop ,upstream-ll-addr6)
                                           (interface ,wan)])])

    (set service router-advert interface ,k8sbr [(prefix "fca7:b01:f00d:c00b::/64")
                                                 (prefix "2001:5a8:4002:9308::/64")
                                                 (name-server "fca7:b01:f00d:c00b::1")
                                                 (default-preference high)])])


(for ([s (commandtree->strings commands)])
  (displayln s))
