#!/bin/sh
# Creates a SSH key for Github Actions.
ssh-keygen -f ./ssh_keys/github/gh_rsa -N "" -q -C "https://github.com/astralbijection/infra"

