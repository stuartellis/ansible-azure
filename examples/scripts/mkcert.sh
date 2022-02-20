#!/usr/bin/env bash

USERNAME="testadmin"
CERT_NAME="ansible-0050"

cat > openssl.conf << EOL
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$USERNAME@localhost
EOL

export OPENSSL_CONF=openssl.conf

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out $CERT_NAME.pem -outform PEM -keyout $CERT_NAME-key.pem -subj "/CN=$USERNAME" -extensions v3_req_client

openssl pkcs12 -export -out $CERT_NAME.pfx -inkey $CERT_NAME-key.pem -in $CERT_NAME.pem

rm openssl.conf
