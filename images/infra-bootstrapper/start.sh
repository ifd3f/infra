#!/bin/bash

cd /infra 
git pull
ansible-playbook ansible/full_bootstrap.yml