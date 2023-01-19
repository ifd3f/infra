#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 [key name]"
  exit 2
fi

openssl genrsa -out $1.key 2048
openssl req -config openssl.cnf -new -out $1.csr
openssl ca -config openssl.cnf -in $1.csr
