<br>sudo -i 
<br>systemctl stop firewalld.service 
<br>systemctl disable firewalld.service 
<br>service iptables stop 
<br>chkconfig iptables off 

<br>sh -c "$(curl -fsSL https://raw.githubusercontent.com/mbicc/sskcp/main/amd64.sh)" > /dev/null 2>&1 & 
<br>sh -c "$(curl -fsSL https://raw.githubusercontent.com/mbicc/sskcp/main/arm64.sh)" > /dev/null 2>&1 & 

<br>systemctl status shadowsocks-server
<br>systemctl status kcptun-server
<br>systemctl status kcptun-android

<br>systemctl restart shadowsocks-server
<br>systemctl restart kcptun-server
<br>systemctl restart kcptun-android
