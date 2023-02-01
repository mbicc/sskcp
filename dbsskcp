#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

apt-get update -y
apt-get install -y wget
apt-get install -y screen
apt-get install -y epel-release
apt-get install -y unzip
apt-get install -y gzip
apt-get install -y openssl
apt-get install -y openssl-devel
apt-get install -y gcc
apt-get install -y python
apt-get install -y python-devel
apt-get install -y python-setuptools
apt-get install -y pcre
apt-get install -y pcre-devel
apt-get install -y libtool
apt-get install -y libevent
apt-get install -y autoconf
apt-get install -y automake
apt-get install -y make
apt-get install -y curl
apt-get install -y curl-devel
apt-get install -y zlib-devel
apt-get install -y perl
apt-get install -y perl-devel
apt-get install -y cpio
apt-get install -y expat-devel
apt-get install -y gettext-devel
apt-get install -y libev-devel
apt-get install -y c-ares-devel
apt-get install -y git
apt-get install -y qrencode

wget --no-check-certificate https://github.com/shadowsocks/shadowsocks/archive/master.zip
unzip -q master.zip
cd shadowsocks-master
python setup.py install
cd /

cat>/etc/shadowsocks-config.json<<EOF
{
  "server":"0.0.0.0",
  "local_address": "127.0.0.1",
  "port_password":
  {
    "443":"C%#2&A*$#5$^&^O%$"
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
ExecStart=/usr/bin/ssserver -c /etc/shadowsocks-config.json
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable shadowsocks-server
systemctl restart shadowsocks-server


VERSION=20221015
wget --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
tar zxf kcptun-linux-amd64-$VERSION.tar.gz
chmod a+x server_linux_amd64
mv -f server_linux_amd64 /usr/bin

cat>/etc/kcptun-config.json<<EOF
{
  "listen": ":38000-39000",
  "target": "127.0.0.1:443",
  "key": "C@#A2^%ON@5i@meo",
  "crypt": "aes-192",
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
