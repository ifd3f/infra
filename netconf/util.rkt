#lang at-exp racket
(require scribble/srcdoc
         (for-doc scribble/base scribble/manual))

(require rebellion/type/record)
(require racket/symbol)
(require (for-syntax racket/syntax))

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
 '[(set policy route-map dn42-roa rule 10 action permit)
   (set policy route-map dn42-roa rule 10 match rpki valid)
   (set policy route-map dn42-roa rule 20 action permit)
   (set policy route-map dn42-roa rule 20 match rpki notfound)
   (set policy route-map dn42-roa rule 30 action deny)
   (set policy route-map dn42-roa rule 30 match rpki invalid)]]})
 dual-stack
 afmap
 afall
 extract-v4
 extract-v6
 extract-all
 dual-stacked-suffix
 wireguard/tunnel:render-vyos
 wireguard/tunnel
 wireguard/peer
 commandtree->string
 commandtree->strings
 bgp/link-local
 bgp/link-local:render-vyos)

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

(define (commandtree->strings t)
  (map command->string (expand-command-tree t)))

(define (commandtree->string t)
  (string-join (commandtree->strings t) "\n"))

(define/match (split-at-first-list l)
  [((cons (? list? l) rest)) (cons '() (cons l rest))]
  [((cons obj rest)) (match-define (cons before after) (split-at-first-list rest))
   (cons (cons obj before) after)]
  [('()) (cons '() '())])

(struct dual-stack (v4 v6)
  #:transparent)

(define extract-v4 dual-stack-v4)
(define extract-v6 dual-stack-v6)
(define (extract-all ds)
  (append (extract-v4 ds) (extract-v6 ds)))
(define (dual-stacked-suffix name)
  (dual-stack (format "~a-v4" name)
              (format "~a-v6" name)))

(define (afmap f t)
  (match t
    ['() '()]
    [(? list? l) (map (lambda (x) (afmap f x)) l)]
    [(? dual-stack? ds) (f ds)]
    [other other]))
(define (afall t)
  `(,(afmap extract-v4 t) ,(afmap extract-v6 t)))

(define-record-type wireguard/tunnel
  (ifname
   our-address
   our-private-key
   description
   peers
   our-endpoint-port))
(define-record-setter wireguard/tunnel)

(define (wireguard/tunnel:render-vyos r)
  `((delete interfaces wireguard ,(wireguard/tunnel-ifname r))
    (set interfaces wireguard ,(wireguard/tunnel-ifname r)
         [(address ,(wireguard/tunnel-our-address r))
          (description ,(wireguard/tunnel-description r))
          ,@(map wireguard/peer:render-vyos (wireguard/tunnel-peers r))])))

(define-record-type wireguard/peer
  (name
   public-key
   endpoint))
(define-record-setter wireguard/peer)

(define (wireguard/peer:render-vyos r)
  `(peer ,(wireguard/peer-name r)
         [(public-key (wireguard/peer-public-key r))
          (allowed-ips "::/0")
          (allowed-ips "0.0.0.0/0")
          ,@(match (wireguard/peer-endpoint r)
              [(cons address port) `((address ,address) (port ,port))]
              ['() `()]
              [_ (error "expected endpoint to be either nil or (cons address port)")])]))

(define-record-type bgp/link-local
  (ifname
   description
   peer-address
   peer-asn
   peer-group))
(define-record-setter bgp/link-local)

(define (bgp/link-local:render-vyos r)
  `[(delete protocols bgp neighbor (bgp/link-local-peer-address r))
    (set protocols bgp neighbor ,(bgp/link-local-peer-address r)
         [(description ,(bgp/link-local-description r))
          (interface source-interface ,(bgp/link-local-ifname r))
          (interface v6only)
          (peer-group ,(bgp/link-local-ifname r))
          (remote-as ,(bgp/link-local-peer-asn r))
          (update-source ,(bgp/link-local-ifname r))])])

(define-record-type firewall/rule
  (description
   cmds
   src
   dst))
(define-record-setter firewall/rule)