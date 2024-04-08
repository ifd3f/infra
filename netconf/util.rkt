#lang at-exp racket
(require scribble/srcdoc
         (for-doc scribble/base scribble/manual))

(require net/ip)
(require rebellion/type/record)
(require racket/symbol)


(provide
 command->string
 
 (proc-doc/names
  expand-command-tree
  (-> list list)
  (t)

  @{Given an expression like this:
@racketblock[
 '(set policy route-map dn42-roa rule
       (10 (action permit)
           (match rpki valid))
       (20 (action permit)
           (match rpki notfound))
       (30 (action deny)
           (match rpki invalid)))]
@racket[expand-command-tree] will convert into this:
@racketblock[
 '((set policy route-map dn42-roa rule 10 action permit)
   (set policy route-map dn42-roa rule 10 match rpki valid)
   (set policy route-map dn42-roa rule 20 action permit)
   (set policy route-map dn42-roa rule 20 match rpki notfound)
   (set policy route-map dn42-roa rule 30 action deny)
   (set policy route-map dn42-roa rule 30 match rpki invalid))]}))

(define (command->string c)
  (string-join (map (match-lambda
                      [(? number? n) (number->string n)]
                      [(? symbol? s) (symbol->string s)]
                      [(? string? s) (string-append "'" s "'")]) c) " "))

(define (expand-command-tree t)
  (match-define (cons before lists) (split-at-first-list t))
  (case lists
    ['() (list t)]
    [else (apply append
                 (map (lambda (subtree)
                        (map (lambda (command) (append before command))
                             (expand-command-tree subtree)))
                      lists))]))

(define/match (split-at-first-list l)
  [((cons (? list? l) rest)) (cons '() (cons l rest))]
  [((cons obj rest)) (match-define (cons before after) (split-at-first-list rest))
   (cons (cons obj before) after)]
  [('()) (cons '() '())])

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

