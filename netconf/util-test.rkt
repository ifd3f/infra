#lang racket

(require rackunit "util.rkt")
(require net/ip)

(check-equal? (expand-command-tree '()) '(()))
(check-equal? (expand-command-tree '(a b)) '((a b)))
(check-equal? (expand-command-tree '(a b (c))) '((a b c)))

(check-equal?
 (expand-command-tree
  '((address dhcp)
    (hw-id "ab:cd:ef:gh:ij:kl")))
 '((address dhcp)
   (hw-id "ab:cd:ef:gh:ij:kl")))

(check-equal?
 (expand-command-tree
  '(set interfaces ethernet eth0
        (address dhcp)
        (hw-id "ab:cd:ef:gh:ij:kl")))
 '((set interfaces ethernet eth0 address dhcp)
   (set interfaces ethernet eth0 hw-id "ab:cd:ef:gh:ij:kl")))

(check-equal?
 (expand-command-tree
  '(set policy route-map dn42-roa rule
        (10 (action permit)
            (match rpki valid))
        (20 (action permit)
            (match rpki notfound))
        (30 (action deny)
            (match rpki invalid))))
 '((set policy route-map dn42-roa rule 10 action permit)
   (set policy route-map dn42-roa rule 10 match rpki valid)
   (set policy route-map dn42-roa rule 20 action permit)
   (set policy route-map dn42-roa rule 20 match rpki notfound)
   (set policy route-map dn42-roa rule 30 action deny)
   (set policy route-map dn42-roa rule 30 match rpki invalid)))

(check-equal? (command->string '(set policy route-map dn42-roa rule 10 action permit))
              "set policy route-map dn42-roa rule 10 action permit")
(check-equal? (command->string '(set interfaces ethernet eth0 hw-id "ab:cd:ef:gh:ij:kl"))
              "set interfaces ethernet eth0 hw-id 'ab:cd:ef:gh:ij:kl'")

(check-equal?
 (wireguard/tunnel:render-vyos
  (wireguard/tunnel
   #:ifname 'wg42
   #:description "peering with some guy"
   #:our-address "192.168.1.1/24"
   #:our-private-key "test key"
   #:peers (list (wireguard/peer
                  #:name 'thepeer
                  #:public-key "foobar"
                  #:endpoint (cons "10.0.0.1" 1000)))
   #:our-endpoint-port 10))
 '((delete interfaces wireguard wg42)
   (set interfaces wireguard wg42
        [(address "192.168.1.1/24")
         (description "peering with some guy")
         (peer thepeer [(public-key (wireguard/peer-public-key r))
                        (allowed-ips "::/0")
                        (allowed-ips "0.0.0.0/0")
                        (address "10.0.0.1")
                        (port 1000)])])))