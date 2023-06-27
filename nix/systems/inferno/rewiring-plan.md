# Rewiring plan

| Name      | Port            | Role before     | Role after          |
| --------- | --------------- | --------------- | ------------------- |
| enp0s31f6 | Motherboard     | LAN             | Debugging interface |
| enp3s0    | 2.5G PCIe Left  | Trunk to switch | Trunk to switch     |
| enp4s0    | 2.5G PCIe Right | N/A             | WAN                 |
