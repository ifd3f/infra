nixos.iso:
	nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=./iso.nix &&\
	cp result/iso/*.iso nixos.iso

.PHONY: clean
clean: destroy-test
	rm -f nixos.iso result 

test/terraform.tfstate: nixos.iso
	cd test && terraform -chdir=test/ apply -var=nixos_iso=nixos.iso -auto-approve

.PHONY: test
test: test/terraform.tfstate 

.PHONY: destroy-test
destroy-test: 
	terraform -chdir=test/ destroy -var=nixos_iso=nixos.iso -auto-approve && rm test/terraform.tfstate