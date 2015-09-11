IP=139.162.8.202
CID=win7

client:
	ipsec pki --pub --in certs/client.pem | ipsec pki --issue --cacert certs/ca.cert.pem --cakey certs/ca.pem --dn "C=CN, O=strongxyz, CN=$(CID)" --outform pem > $(CID).client.cert.pem
	openssl pkcs12 -export -inkey certs/client.pem -in $(CID).client.cert.pem -name "$(CID)" -certfile certs/ca.cert.pem -caname "strongxyz CA" -out $(CID).client.cert.p12
cert:
	ipsec pki --pub --in certs/server.pem | ipsec pki --issue --cacert certs/ca.cert.pem --cakey certs/ca.pem --dn "C=CN, O=strongxyz, CN=$(IP)" --san="$(IP)" --flag serverAuth --flag ikeIntermediate --outform pem > $(IP).server.cert.pem

conf:
	gcc -o update_conf update_conf.c
	./update_conf $(IP)

install:
	scp certs/ca.cert.pem  root@$(IP):/etc/ipsec.d/cacerts/
	scp certs/server.pem root@$(IP):/etc/ipsec.d/private/
	scp certs/client.cert.pem root@$(IP):/etc/ipsec.d/certs/
	scp certs/client.pem root@$(IP):/etc/ipsec.d/private/
	scp $(IP).ipsec.conf root@$(IP):/etc/ipsec.conf
	scp certs/$(IP).server.cert.pem root@$(IP):/etc/ipsec.d/certs/server.cert.pem
	scp ipsec.secrets root@$(IP):/etc/

clean:
	rm $(IP).ipsec.conf
	rm $(IP).server.cert.pem
	rm update_conf
