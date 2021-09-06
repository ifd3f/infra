echo "Populating NixOS configs..."
mkdir -p /mnt/etc/nixos 
cd /mnt/etc/nixos 
git clone https://github.com/astralbijection/infrastructure.git infra
echo "import ./infra/nixos/bootstrap-bongus.nix" > configuration.nix
nixos-install

nixos-enter /mnt
nixos-rebuild boot --flake https://github.com/astralbijection/infrastructure.git#bongusHV