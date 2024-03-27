(net ULA-V6 fc00::/7
  (net CA7DC fca7:b01:f00d::/48
    (description "IPs for the primary datacenter")

    (net CA7DC-DEVVM fca7:b01:f00d:0de7::/64
      (description "Developer VMs")
      (attr trust-level TRUSTED)
      (attr vlan 300)
    )

    (net CA7DC-K8S fca7:b01:f00d:c00b::/64
      (description "Kubernetes cluster inter-node IP space")
      (attr trust-level TRUSTED)
      (attr vlan 100)
    )

    (net CA7DC-SERVICE fca7:b01:f00d:cafe::/64
      (description "Public service IP space")
      (attr trust-level TRUSTED)
      (attr vlan 100)
    )

    (net CA7DC-MGMT fca7:b01:f00d:6969::/64
      (alias-v4 192.168.69.0/24)
      (description "iLO, switch config interfaces")
      (attr trust-level FULLY-TRUSTED)
      (attr vlan 69)

      (host lucifer 192.168.69.1
        (description "Firewall"))
      (host inferno 192.168.69.10
        (description "Firewall hypervisor"))
      (host belphegor 192.168.69.11
        (description "Living room switch"))
      (host beelzebub 192.168.69.15
        (description "Datacenter switch"))
    )

    (net CA7DC-IOT fca7:b01:f00d:9900::/64
      (alias-v4 192.168.99.0/24)
      (description "IoT devices")
      (attr trust-level UNTRUSTED)
      (attr vlan 107)
    )
  )

  (net CA7DC-DN42 fd00:ca7:b015::/48
    (alias-v4 172.23.7.176/28)
    (description "nyahaus network, DN42")
    (attr trust-level UNTRUSTED)
    (attr vlan 107)
  )

  (net CA7NET-VPN fd:ca7:f8a3::/48
    (description "VPN subnet")

    (net CA7NET-VPN-USER fd:ca7:f8a3:100::/64
      (description "VPN for general user access. Allowed to be used for traffic rerouting.")
      (attr trust-level UNTRUSTED)
    )
    (net CA7NET-VPN-MON fd:ca7:f8a3:200::/64
      (description "VPN for monitoring services.")
      (attr trust-level TRUSTED)
    )
    (net CA7NET-VPN-PUSH fd:ca7:f8a3:300::/64
      (description "VPN for the continuous deployment agent. Has access over almost everything!")
      (attr trust-level FULLY-TRUSTED)
    )
    (net CA7NET-VPN-ADMIN fd:ca7:f8a3:400::/64
      (description "VPN for me to perform total system administration! Has access over literally everything! Very dangerous!")
      (attr trust-level FULLY-TRUSTED)

      (net CA7NET-VPN-ADMIN-CHUNGUS fd:ca7:f8a3:400::1/128
        (description "Firewall IP")
        (attr trust-level FULLY-TRUSTED)
      )
      (net CA7NET-VPN-ADMIN-BANANA fd:ca7:f8a3:400::2/128
        (description "BANANA IP")
        (attr trust-level FULLY-TRUSTED)
      )
      (net CA7NET-VPN-ADMIN-CHUNGUS fd:ca7:f8a3:400::3/128
        (description "Chungus IP")
        (attr trust-level FULLY-TRUSTED)
      )
    )
  )
)

(net SONIC-PROVIDED-V4 135.180.141.38/32
  (description "Sonic gave me this IP for my house")
)

(net SONIC-PROVIDED-V6 2001:5a8:4002:9300::/56
  (description "Sonic gave me this prefix for my house")
  (net PROD-PUBLIC 2001:5a8:4002:9301::/64
    (description "Address space for public services")
  )
  (net HOME-USERS-V6 2001:5a8:4002:930a::/64
    (description "IP space for ethernet connected users")
  )
  (net HOME-WUSERS-V6 2001:5a8:4002:930b::/58
    (description "IP space for wireless connected users")
  )
)
