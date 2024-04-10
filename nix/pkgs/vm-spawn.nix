{ writeShellApplication, fetchurl, virt-manager,

vyos-iso ? fetchurl {
  url =
    "https://github.com/vyos/vyos-rolling-nightly-builds/releases/download/1.5-rolling-202404090019/vyos-1.5-rolling-202404090019-amd64.iso";
  hash = "sha256-pqjCay7m3bQSLhUBAfCEhuQ0Cef6rcbNLf3PqKUIl3c=";
}, talos-iso ? fetchurl {
  url =
    "https://github.com/siderolabs/talos/releases/download/v1.6.7/metal-amd64.iso";
  hash = "sha256-Dqw05mI9lpIn36jKkFuAmxnom5qIXSjEqQiQ6F7HC34=";
} }:
{
  charon = writeShellApplication {
    name = "vm-spawn.charon";
    runtimeInputs = [ virt-manager ];
    text = ''
      set -euxo pipefail

      ln -sf ${vyos-iso} /var/lib/libvirt/images/vyos-install.iso

      virt-install \
        -n "charon" \
        --description "Router charon" \
        --os-variant=linux2022 \
        --ram=4096 \
        --vcpus=4 \
        --disk path="/var/lib/libvirt/images/router-charon.img",bus=virtio,size=4 \
        --graphics none \
        --cdrom /var/lib/libvirt/images/vyos-install.iso \
        --network bridge:prodbr \
        --network bridge:k8sbr $@
    '';
  };

  talos = writeShellApplication {
    name = "vm-spawn.talos";
    runtimeInputs = [ virt-manager ];
    text = ''
      set -euxo pipefail

      if [ $# -ne 1 ]; then
        echo "usage: $0 <VM_NUMBER>"
        exit 1
      fi

      ln -sf ${talos-iso} /var/lib/libvirt/images/talos-install.iso

      virt-install \
        -n "k8s-node$1" \
        --description "Talos Node $1" \
        --os-variant=linux2022 \
        --ram=16384 \
        --vcpus=8 \
        --disk path="/var/lib/libvirt/images/talos-node-$1.img",bus=virtio,size=32 \
        --graphics none \
        --cdrom /var/lib/libvirt/images/talos-install.iso \
        --network bridge:k8sbr
    '';
  };
}
