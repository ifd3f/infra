#lang racket

(require "util.rkt")

(provide dn42/bgp-group
         dn42/bgp-setup
         dn42/route-collector
         dn42/wireguard-ll-peer
         dn42/rpki)

(define bgp-afs '(ipv4-unicast ipv6-unicast))
(define dn42-roa-route-map "dn42-roa")

(define (dn42/bgp-setup)
  '(set protocols bgp [(parameters router-id "172.23.7.177")
                       (system-as 4242421846)
                       (address-family ipv4-unicast network "172.23.7.176/28")
                       (address-family ipv6-unicast network "fd00:ca7:b015::/48")]))

(define (dn42/bgp-group)
  `[(delete protocols bgp peer-group dn42)
    (set protocols bgp peer-group dn42
         [(capability extended-nexthop)
          ,(for/list ([af bgp-afs])
             `(,af [(route-map export ,dn42-roa-route-map)
                    (route-map import ,dn42-roa-route-map)
                    (soft-reconfiguration inbound)]))])])

(define (dn42/route-collector)
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

(define (dn42/wireguard-ll-peer #:name name
                                #:our-ll-address our-ll-address
                                #:our-private-key our-private-key
                                #:our-endpoint-port our-endpoint-port
                                #:peer-ll-address peer-ll-address
                                #:peer-asn peer-asn
                                #:peer-public-key peer-public-key
                                #:peer-endpoint peer-endpoint)
  (define ifname (format "wg~a" peer-asn))
  (define tunnel
    (wireguard/tunnel #:ifname ifname
                      #:description (format "dn42 peering tunnel for ~a (AS~a)" name peer-asn)
                      #:our-address our-ll-address
                      #:our-private-key our-private-key
                      #:our-endpoint-port our-endpoint-port
                      #:peers (list (wireguard/peer
                                     #:name name
                                     #:public-key peer-public-key
                                     #:endpoint peer-endpoint))))
  (define bgp
    (bgp/link-local #:ifname ifname
                    #:description (format "dn42 peer ~a (AS~a)" name peer-asn)
                    #:peer-address peer-ll-address
                    #:peer-asn peer-asn
                    #:peer-group 'dn42))

  `(,(wireguard/tunnel:render-vyos tunnel)
    ,(bgp/link-local:render-vyos bgp)))

(define (dn42/rpki [nat-rulenum 10])
  (define container-addr "172.16.2.10")
  (define subnet "172.16.2.0/24")
  (define port 8082)

  (define gortr
    `[(delete container [(name gortr)
                         (network rpki)])
      (set container name gortr
           [(image "cloudflare/gortr")
            (restart "on-failure")
            (command ,(format "-cache https://dn42.burble.com/roa/dn42_roa_46.json -verify=false -checktime=false -bind :~a" port))
            (network rpki address ,container-addr)])
      (set container network rpki prefix ,subnet)])

  (define nat
    `[(delete nat source rule ,nat-rulenum)
      (set nat source rule ,nat-rulenum [(outbound-interface name "eth0")
                                         (translation address "masquerade")
                                         (source address ,subnet)])])

  (define point-rpki
    `(set protocols rpki cache ,container-addr [(port ,port)
                                                (preference 1)]))

  (define route-map
    `(set policy route-map ,dn42-roa-route-map rule
          [(10 (action permit)
               (match rpki valid))
           (20 (action permit)
               (match rpki notfound))
           (30 (action deny)
               (match rpki invalid))]))

  `[,gortr ,nat ,point-rpki ,route-map])
