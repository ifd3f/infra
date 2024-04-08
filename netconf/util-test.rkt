#lang racket

(require rackunit "util.rkt")

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