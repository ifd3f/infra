#lang racket

(require net/ip)
(require rebellion/type/record)
(require racket/symbol)

(define-record-type WireguardTunnel
  (ifname
   our-address
   our-private-key
   description
   peers
   our-endpoint-port))

(define-record-type WireguardPeer
  (name
   public-key
   endpoint))

(define-record-type LinkLocalBgpPeer
  (link-ifname
   description
   peer-address
   peer-asn
   peer-group))

(define-record-type FirewallRule
  (description
   cmds
   src
   dst))
  


#;(define/match (command exp)
  [((? symbol? s)) (symbol->immutable-string s)]
  [((? string? s)) s])
