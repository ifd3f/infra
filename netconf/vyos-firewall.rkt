#lang racket

(require rebellion/type/record)
(require racket/match)
(require "util.rkt")

(provide
 dn42-allowed-transit-addrs
 ifd3f-dn42-addrs
 dn42-tunnels-in
 router-rules
 vyos-firewall-ds
 firewall/network-group)

(define dn42-allowed-transit-addrs
  (dual-stack '("10.0.0.0/8"
                "172.20.0.0/14"
                "172.31.0.0/16")
              '("fd00::/8")))

(define ifd3f-dn42-addrs
  (dual-stack '("172.23.7.176/28")
              '("fd00:ca7:b015::/48")))

(define vyos-firewall-ds
  (dual-stack 'ipv4 'ipv6))

(define vyos-firewall-group-ds
  (dual-stack 'network-group 'ipv6-network-group))

(define (firewall/network-group name dsaddrs)
  (afall
   `[(delete firewall group ,vyos-firewall-group-ds ,(dual-stacked-suffix name))
     (set firewall group ,vyos-firewall-group-ds ,(dual-stacked-suffix name))
     (set firewall group ,vyos-firewall-group-ds ,(dual-stacked-suffix name)
          network ,(dsmap (lambda (nets) (map list nets)) dsaddrs))]))

(define (dn42-tunnels-in)
  `[(delete firewall ,vyos-firewall-ds name ,(dual-stacked-suffix "dn42-tunnels-in"))
    (set firewall ,vyos-firewall-ds name ,(dual-stacked-suffix "dn42-tunnels-in")
         [(rule 10 [(description "Block traffic to operator-assigned IP space")
                    (source group network-group ,(dual-stacked-suffix "dn42-allowed-transit"))
                    (destination group network-group ,(dual-stacked-suffix "ifd3f-dn42"))
                    (action drop)])
          (rule 20 [(description "Allow peer transit")
                    (source group network-group  ,(dual-stacked-suffix "dn42-allowed-transit"))
                    (destination group network-group ,(dual-stacked-suffix "dn42-allowed-transit"))
                    (action accept)])])])

(define (router-rules)
  '(set firewall
        (global-options state-policy [(established action accept)
                                      (related action accept)
                                      (invalid action accept)])))
