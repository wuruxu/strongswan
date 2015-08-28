user@user-Macmini:~/dev/strongswan/tools$ cat CA.init.sh 
#!/bin/bash
mkdir -p ../certs
ipsec pki --gen --outform pem > ../certs/ca.pem
ipsec pki --self --in ../certs/ca.pem --dn "C=CN, O=strongabc, CN=strongabc CA" --ca --outform pem > ../certs/ca.cert.pem
ipsec pki --gen --outform pem > ../certs/server.pem
ipsec pki --gen --outform pem > ../certs/client.pem
ipsec pki --pub --in ../certs/client.pem | ipsec pki --issue --cacert ../certs/ca.cert.pem --cakey ../certs/ca.pem --dn "C=CN, O=strongabc, CN=client" --outform pem > ../certs/client.cert.pem
user@user-Macmini:~/dev/strongswan/tools$ cat SERVER.CA.sh 
#!/bin/bash
ipsec pki --pub --in ../certs/server.pem | ipsec pki --issue --cacert ../certs/ca.cert.pem --cakey ../certs/ca.pem --dn "C=CN, O=strongabc, CN=$1" --san="$1" --flag serverAuth --flag ikeIntermediate --outform pem > ../certs/server.cert.pem
user@user-Macmini:~/dev/strongswan/tools$ cat CLIENT.CA.sh 
#!/bin/bash
openssl pkcs12 -export -inkey ../certs/client.pem -in ../certs/client.cert.pem -name "client" -certfile ../certs/ca.cert.pem -caname "strongabc CA" -out client.cert.p12
