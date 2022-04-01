{ self }:
[
  self.homeConfigurations."astrid@Discovery"
  self.homeConfigurations."astrid@aliaconda"
  self.homeConfigurations."astrid@banana"
  self.homeConfigurations."astrid@shai-hulud"
  self.nixosConfigurations.banana
  self.nixosConfigurations.donkey
  self.nixosConfigurations.gfdesk
  self.nixosConfigurations.shai-hulud
  self.packages.installer-iso
]
