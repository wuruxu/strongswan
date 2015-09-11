# strongswan
tools and script for deploy strongswan iKev2/IPsec
##install 
* download [strongswan](https://strongswan.org) on VPS server
* apt-get install build-essential libssl-dev libgmp-dev
* build strongswan source, make, make install
```
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var CFLAGS=-O2 --enable-dnscert --enable-ccm --enable-chapoly --enable-ctr --enable-gcm --enable-rdrand --enable-aesni
```

##iKev2 & IPsec config
* update IP variable in Makefile
* make cert
* make conf
* make install

## VPS config
* update /etc/sysctl.conf, then 'sysctl -p'
```
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
```
* update iptables rules
```
iptables -A INPUT -p udp --dport 500 --j ACCEPT
iptables -A INPUT -p udp --dport 4500 --j ACCEPT
iptables -A INPUT -p udp --dport 4500 --j ACCEPT
iptables -A INPUT -p udp --dport 4500 --j ACCEPT -j SNAT --to-source <vps_eth0_IP>
```
