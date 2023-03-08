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


VERSION=20230214
wget --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
tar zxf kcptun-linux-amd64-$VERSION.tar.gz
chmod a+x server_linux_amd64
mv -f server_linux_amd64 /usr/bin

cat>/etc/kcptun-config.json<<EOF
{
  "listen": ":38000-39000",
  "target": "127.0.0.1:443",
  "key": "jj3G83hkds",
  "crypt": "aes",
  "mode": "fast",
  "mtu": 1350,
  "sndwnd": 512,
  "rcvwnd": 512,
  "datashard": 10,
  "parityshard": 3,
  "dscp": 46,
  "nocomp": true,
  "acknodelay": true,
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
ExecStart=/usr/bin/server_linux_amd64 -c /etc/kcptun-config.json
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kcptun-server
systemctl restart kcptun-server

systemctl status shadowsocks-server
systemctl status kcptun-server
