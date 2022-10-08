#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum update -y
yum install -y wget
yum install -y screen
yum install -y epel-release
yum install -y unzip
yum install -y gzip
yum install -y openssl
yum install -y openssl-devel
yum install -y gcc
yum install -y python
yum install -y python-devel
yum install -y python-setuptools
yum install -y pcre
yum install -y pcre-devel
yum install -y libtool
yum install -y libevent
yum install -y autoconf
yum install -y automake
yum install -y make
yum install -y curl
yum install -y curl-devel
yum install -y zlib-devel
yum install -y perl
yum install -y perl-devel
yum install -y cpio
yum install -y expat-devel
yum install -y gettext-devel
yum install -y libev-devel
yum install -y c-ares-devel
yum install -y git
yum install -y qrencode

wget --no-check-certificate https://github.com/shadowsocks/shadowsocks/archive/master.zip
unzip -q master.zip
cd shadowsocks-master
python setup.py install
cd /

cat>/etc/ss-config.json<<EOF
{
  "server":"0.0.0.0",
  "local_address": "127.0.0.1",
  "port_password":
  {
    "443":"caocaocao"
  },
  "local_port":1080,
  "timeout":300,
  "method":"aes-256-cfb",
  "fast_open": false
}
EOF

cat>/etc/systemd/system/shadowsocks-server.service<<EOF
[Unit]
Description=Shadowsocks Server
After=network.target
[Service]
ExecStart=/usr/bin/ssserver -c /etc/ss-config.json
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable shadowsocks-server
systemctl restart shadowsocks-server


VERSION=20220628
wget --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
tar zxf kcptun-linux-amd64-$VERSION.tar.gz
rm -f client_linux_amd64 kcptun-linux-amd64-$VERSION.tar.gz
chmod a+x server_linux_amd64
mv -f server_linux_amd64 /usr/bin

cat>/etc/kcp-config.json<<EOF
{
  "listen": ":51888",
  "target": "127.0.0.1:443",
  "key": "veryfast",
  "crypt": "aes",
  "mode": "fast",
  "mtu": 1350,
  "sndwnd": 512,
  "rcvwnd": 512,
  "datashard": 10,
  "parityshard": 3,
  "dscp": 0,
  "nocomp": true,
  "quiet": false,
  "tcp": false,
  "pprof": false
}
EOF

cat>/etc/systemd/system/kcptun-server.service<<EOF
[Unit]
Description=Kcptun server
After=network.target
[Service]
ExecStart=/usr/bin/server_linux_amd64 -c /etc/kcp-config.json
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kcptun-server
systemctl restart kcptun-server

systemctl status shadowsocks-server
systemctl status kcptun-server
