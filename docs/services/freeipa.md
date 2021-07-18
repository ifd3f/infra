# FreeIPA

FreeIPA is hard to treat as cattle, so it is begrudgingly treated as a pet. It is deployed in a Fedora VM. Currently, there is one and only one master node, `ipa0.p.astrid.tech`.

## DNS

See [this page](../network#dns) for more information on the DNS zones.

FreeIPA manages the `s.` and `p.` zones. `s.` is automatically updated by Kubernetes using RFC 2136, following the guide I wrote [here](https://astrid.tech/2021/04/18/k8s-freeipa-dns/).
