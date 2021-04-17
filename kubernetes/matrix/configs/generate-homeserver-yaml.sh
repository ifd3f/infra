#!/bin/sh

inputs=$1
outfile=$2

# Write in regular input files
cat $inputs/* > $outfile

# Add in the database secrets
cat >> $outfile <<-EOF
database:
  name: psycopg2
  args:
    user: $username
    password: $password
    database: $db_name
    host: $db_host
    cp_min: 5
    cp_max: 10
EOF