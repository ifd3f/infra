#!/bin/bash

echo "::::: Adding whitelist items :::::"
pihole --white-wild lan
pihole --white-wild p.astrid.tech
