sudo -i
systemctl stop firewalld.service
systemctl disable firewalld.service

sh -c "$(curl -fsSL https://raw.githubusercontent.com/mbicc/sskcp/main/sskcp.sh)"

systemctl status shadowsocks-server
systemctl restart shadowsocks-server
systemctl status kcp-server
systemctl restart kcp-server
