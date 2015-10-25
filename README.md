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
* ipsec service start
```
ipsec start
```

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
iptables -A INPUT -p esp -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 ! -p esp -j SNAT --to-source <vps_eth0_IP>
```

##Android setup
* download [strongswan](https://play.google.com/store/apps/details?id=org.strongswan.android)
* import $(CID).client.cert.p12
* New profile for VPN
```
Gateway:  VPS_IP
Type: IKEv2 Certificate
User certificate: 选择刚才导入的证书
CA certificate: 取消自动选择，选择刚才导入的证书
```
