#!/usr/bin/env sh
# Creates a SSH key for Github Actions.
ssh-keygen -f ./gh_rsa -N -q -C "https://github.com/astralbijection/infrastructure"