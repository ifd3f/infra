# Machines

Disclaimer: This is not yet implemented, and subject to change.

Note that all NixOS machines reformat their / partitions on every boot.

Any partitions marked as (vmspace) contain LVM volume groups. Virtual machines receive LVs in this space to treat as primary boot disks. We do not perform snapshots on these volumes; if the VM breaks, we spawn a new one.

## Bongus

|       |                                    |
| ----- | ---------------------------------- |
| Model | HP Gen8 DL380P                     |
| OS    | NixOS 21.05                        |
| RAM   | 96GB DDR3 ECC                      |
| CPU   | 2x Xeon E5-???? (16 core, 32 virt) |

Disk layout

- 1x 120GB SSD
  - efi: 550MB vfat /boot/efi
  - root: 8GB ext4 /
  - nix: 16GB ext4 /nix
  - vmpv/vmvg: ~95GB LVM (vmspace)
- 2x RAID1 1TB HDD ZFS pool: dpool
  - safe/
    - persist, contains items in / to be persisted
  - share/
    - media

## Cracktop

|       |                            |
| ----- | -------------------------- |
| Model | HP Pavilion x360           |
| OS    | NixOS 21.05                |
| RAM   | 8GB DDR3                   |
| CPU   | i5-6200U? (2 core, 4 virt) |

Disk layout

- 1x 128GB SSD
  - efi: 550MB vfat /boot/efi
  - root: 8GB ext4 /
  - nix: 16GB ext4 /nix
  - vmpv/vmvg: ~95GB LVM (vmspace)

## Thonkpad

|       |                  |
| ----- | ---------------- |
| Model | Thinkpad T420    |
| OS    | NixOS 21.05      |
| RAM   | 8GB DDR3         |
| CPU   | i5-???? (4 core) |

Disk Layout

- 1x 1TB HDD
  - efi: 550MB vfat /boot/efi
  - root: 16GB ext4 /
  - nix: 24GB ext4 /nix
  - vmpv/vmvg: 200GB LVM (vmspace)
  - dpool: ~750GB ZFS

## Badtop

|       |                       |
| ----- | --------------------- |
| Model | Acer Aspire ???       |
| OS    | NixOS 21.05           |
| RAM   | 4GB DDR3              |
| CPU   | Pentium ???? (4 core) |

This machine has such low specs that it's not worth running VMs on it. Instead, I use it as a bare-metal Kubernetes node.

Disk layout

- 1x 320GB HDD
  - efi: 550MB vfat /boot/efi
  - root: 16GB ext4 /
  - nix: 24GB ext4 /nix
  - dpool: ~280GB ZFS
