#!/bin/bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum update -y

yum install -y python-setuptools net-tools

easy_install pip

pip install --upgrade pip shadowsocks

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

systemctl daemon-reload
systemctl enable shadowsocks-server
systemctl restart shadowsocks-server

yum install -y wget
VERSION=20220628
wget https://github.com/xtaci/kcptun/releases/download/v$VERSION/kcptun-linux-amd64-$VERSION.tar.gz
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

cat>/etc/systemd/system/kcp-server.service<<EOF
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
systemctl enable kcp-server
systemctl restart kcp-server
