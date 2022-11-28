<br>sudo -i 
<br>systemctl stop firewalld.service 
<br>systemctl disable firewalld.service 

<br>sh -c "$(curl -fsSL https://raw.githubusercontent.com/mbicc/sskcp/main/sskcp.sh)" 

<br>systemctl status shadowsocks-server 
<br>systemctl restart shadowsocks-server 
<br>systemctl status kcptun-server 
<br>systemctl restart kcptun-server 
