#!/bin/sh

cat <<-EOF
database:
  name: psycopg2
  args:
    user: $username
    password: $password
    database: postgresql
    host: synapse-db
    cp_min: 5
    cp_max: 10
EOF