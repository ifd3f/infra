(net ULA fc00::/7
  (net CA7DC fd:ca7:ca7::/48
    (description "IPs for the primary datacenter")

    (net CA7DC-PROD fd:ca7:ca7::/49
      (description "service running space")
      (attr trust-level TRUSTED)
      (attr vlan 50)

      (net CA7DC-K8S fd:ca7:ca7:1000::/56
        (description "k8s host space")
      )
    )

    (net CA7DC-MGMT fd:ca7:ca7:9000::/56
      (description "iLO, hypervisors, switch config interfaces")
      (attr trust-level FULLY-TRUSTED)
      (attr vlan 69)
    )
    (net CA7DC-IOT fd:ca7:ca7:9100::/56
      (description "IoT devices")
      (attr trust-level UNTRUSTED)
      (attr vlan 107)
    )
    (net CA7DC-DEVVM fd:ca7:ca7:de00::/56
      (description "Developer VMs")
      (attr trust-level TRUSTED)
      (attr vlan 300)
    )
  )

  (net CA7NET-VPN fd:ca7:f8a3::/48
    (description "VPN subnet")

    (net CA7NET-VPN-USER fd:ca7:f8a3:100::/56
      (description "VPN for general user access. Allowed to be used for traffic rerouting.")
      (attr trust-level UNTRUSTED)
    )
    (net CA7NET-VPN-MON fd:ca7:f8a3:200::/56
      (description "VPN for monitoring services.")
      (attr trust-level TRUSTED)
    )
    (net CA7NET-VPN-PUSH fd:ca7:f8a3:300::/56
      (description "VPN for the continuous deployment agent. Has access over almost everything!")
      (attr trust-level FULLY-TRUSTED)
    )
    (net CA7NET-VPN-ADMIN fd:ca7:f8a3:400::/56
      (description "VPN for me to perform total system administration! Has access over literally everything! Very dangerous!")
      (attr trust-level FULLY-TRUSTED)
    )
  )
)

(net SONIC-PROVIDED-V4 135.180.141.38/32
  (description "Sonic gave me this IP for my house")
)

(net SONIC-PROVIDED-V6 2001:5a8:657::/56
  (description "Sonic gave me this prefix for my house")
  (net HOME-USERS-V6 2001:5a8:657:a::/58
    (description "IP space for ethernet connected users")
  )
  (net HOME-WUSERS-V6 2001:5a8:657:b::/58
    (description "IP space for wireless connected users")
  )
)
