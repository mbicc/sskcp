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

cat>/etc/shadowsocks-config.json<<EOF
{
  "server":"0.0.0.0",
  "local_address": "127.0.0.1",
  "port_password":
  {
    "443":"caocaocao"
  },
  "local_port":1080,
  "timeout":300,
  "method":"aes-256-gcm",
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


VERSION=20230214
wget --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
wget --no-check-certificate https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-arm64-$VERSION.tar.gz
tar zxf kcptun-linux-amd64-$VERSION.tar.gz
chmod a+x server_linux_amd64
mv -f server_linux_amd64 /usr/bin
tar zxf kcptun-linux-arm64-$VERSION.tar.gz
chmod a+x server_linux_arm64
mv -f server_linux_arm64 /usr/bin

cat>/etc/kcptun-config.json<<EOF
{
  "listen": ":38000-39000",
  "target": "127.0.0.1:443",
  "key": "jj3G83hkds",
  "crypt": "aes",
  "conn": 60,
  "mode": "manual",
  "nodelay": 1,
  "interval": 20,
  "resend": 2,
  "nc": 1,
  "mtu": 1450,
  "sndwnd": 4096,
  "rcvwnd": 2048,
  "datashard": 10,
  "parityshard": 3,
  "dscp": 46,
  "nocomp": true,
  "sockbuf": 10485760,
  "smuxver": 2,
  "smuxbuf": 10485760,
  "streambuf": 10485760,
  "keepalive": 10,
  "quiet": true,

  "autoexpire": 30,
  "scavengettl": 120,
  "acknodelay": true,
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

cat>/etc/kcptun-android.json<<EOF
{
  "listen": ":51000-52000",
  "target": "127.0.0.1:443",
  "key": "jj3G83hkds",
  "crypt": "aes",
  "conn": 60,
  "mode": "manual",
  "nodelay": 1,
  "interval": 20,
  "resend": 2,
  "nc": 1,
  "mtu": 1450,
  "sndwnd": 4096,
  "rcvwnd": 2048,
  "datashard": 10,
  "parityshard": 3,
  "dscp": 46,
  "nocomp": true,
  "sockbuf": 10485760,
  "smuxver": 1,
  "smuxbuf": 10485760,
  "streambuf": 10485760,
  "keepalive": 10,
  "quiet": true,

  "autoexpire": 30,
  "scavengettl": 120,
  "acknodelay": true,
  "pprof": false
}
EOF

cat>/etc/systemd/system/kcptun-android.service<<EOF
[Unit]
Description=Kcptun Android
After=network.target
[Service]
ExecStart=/usr/bin/server_linux_amd64 -c /etc/kcptun-android.json
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kcptun-server
systemctl restart kcptun-server
systemctl enable kcptun-android
systemctl restart kcptun-android

systemctl status shadowsocks-server
systemctl status kcptun-server
systemctl status kcptun-android
