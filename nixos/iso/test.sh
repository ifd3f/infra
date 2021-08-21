#!/bin/bash

rm -rf ./result
./mkiso.sh
iso_path=$(readlink -f result/iso/*.iso)

cd test
export TF_VAR_nixos_iso=$iso_path
terraform destroy -auto-approve && terraform apply -auto-approve