# Nix expects a flake.nix in the root directory, but I want to put 
# all my nix configs in a subdirectory. Thus, this file simply imports
# my subdirectory's flake.nix.

import ./nixos/flake.nix