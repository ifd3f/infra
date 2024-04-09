#lang racket

(require "util.rkt")

(commandtree->string
 '(set firewall
       (global-options state-policy [(established action accept)
                                     (related action accept)
                                     (invalid action accept)])
       (group network-group
              (dn42-allowed-transit-v4 network
                                       ("10.0.0.0/8")
                                       ("172.20.0.0/14")
                                       ("172.31.0.0/16")))))