#lang racket

(define bgp-afs '(ipv4-unicast ipv6-unicast))
(define dn42-roa-route-map "dn42-roa")

(define (dn42-bgp-group)
  `[(delete protocols bgp peer-group dn42)
    (set protocols bgp peer-group dn42
         [(capability extended-nexthop)
          ,(for/list ([af bgp-afs])
             `(,af [(route-map export ,dn42-roa-route-map)
                    (route-map import ,dn42-roa-route-map)
                    (soft-reconfiguration inbound)]))])])

(define (dn42-route-collector)
  (define addr "fd42:4242:2601:ac12::1")
  (define routemap 'deny-all)
  
  `[(delete policy route-map ,routemap)
    (set policy route-map ,routemap rule 1 action deny)
    
    (delete protocols bgp neighbor ,addr)
    (set protocols bgp neighbor ,addr
         [(capability extended-nexthop)
          ,(for/list ([af bgp-afs]) `(address-family ,af route-map import ,routemap))
          (description "https://lg.collector.dn42")
          (ebgp-multihop 10)
          (remote-as 4242422602)])])
