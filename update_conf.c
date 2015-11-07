#include <stdio.h>

const char * ipsec_fmt = "\
config setup\n\
  uniqueids=never\n\
\n\
conn strongswan\n\
  keyexchange=ikev2\n\
  left=%%defaultroute\n\
  leftauth=pubkey\n\
  leftsubnet=0.0.0.0/0\n\
  leftfirewall=yes\n\
  leftcert=server.cert.pem\n\
  leftid=\"C=CN, O=strongxyz, CN=%s\"\n\
  right=%%any\n\
  rightid=\"C=CN, O=strongxyz, CN=client\"\n\
  rightsourceip=10.8.0.0/24\n\
  rightdns=8.8.8.8,8.8.4.4\n\
  compress=yes\n\
  rightcert=client.cert.pem\n\
  ike=aes256ccm128-sha256-modp2048,aes256gcm128-sha256-modp2048,aes256gcm96-sha384-modp2048,aes256ccm96-sha384-modp2048,aes256-sha256-modp2048,aes128-sha256-modp2048,aes128-sha1-modp2048!\n\
  esp=chacha20poly1305,aes128gcm128-aes256gcm128,aes256ccm128-sha256-modp2048,aes256gcm128-sha256-modp2048,aes256gcm96-sha384-modp2048,aes256ccm96-sha512-modp2048,aes256-sha256,aes128-sha1-modp2048!\n\
  auto=add\n\
  
conn local-net
  leftsubnet=192.168.108.0/24
  rightsubnet=192.168.108.0/24
  authby=never
  type=pass
  auto=route
";

int main(int argc, char *argv[]) {
  char fn[256] = {0};
  FILE *fp = NULL;
  char conf_buf[10240] = {0};
  int size;

  if(argc < 2) {
    printf("usage update_conf $(IP)\r\n");
    return -1;
  }

  snprintf(fn, 256, "%s.ipsec.conf", argv[1]);
  fp = fopen(fn, "w");
  size = snprintf(conf_buf, 10240, ipsec_fmt, argv[1]);
  fwrite(conf_buf, sizeof(char), size, fp);
  fclose(fp);

  return 0;
}
