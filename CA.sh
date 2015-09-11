#!/bin/bash
#mkdir -p certs
ipsec pki --gen --outform pem > ca.pem
ipsec pki --self --in ca.pem --dn "C=CN, O=strongabc, CN=strongabc CA" --ca --outform pem > ca.cert.pem
ipsec pki --gen --outform pem > server.pem
ipsec pki --gen --outform pem > client.pem
ipsec pki --pub --in client.pem | ipsec pki --issue --cacert ca.cert.pem --cakey ca.pem --dn "C=CN, O=strongabc, CN=client" --outform pem > client.cert.pem
ipsec pki --pub --in server.pem | ipsec pki --issue --cacert ca.cert.pem --cakey ca.pem --dn "C=CN, O=strongabc, CN=$1" --san="$1" --flag serverAuth --flag ikeIntermediate --outform pem > server.cert.pem
openssl pkcs12 -export -inkey client.pem -in client.cert.pem -name "client" -certfile ca.cert.pem -caname "strongabc CA" -out client.cert.p12
