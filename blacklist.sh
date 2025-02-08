#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
IP=$(curl -sS ipinfo.io/ip > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
if [ -z "$MYIP" ]; then
IP=$(curl -sS http://ip-api.com/json | jq .query | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi
if [ -z "$MYIP" ]; then
IP=$(curl -sS ipinfo.io | jq .ip | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi

# cek wget & curl
if ! which wget > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo "Wget is already installed"
fi

if ! which curl > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo "curl is already installed"
fi

fileee=/usr/bin/wget
minimumsize=400000
actualsize=$(wc -c <"$fileee")
if [ $actualsize -ge $minimumsize ]; then
clear
echo -e "${green}Checking...${NC}"
else
clear
echo -e "${red}Permission Denied!${NC}";
echo "Reason : Modified Package To Bypass Sc"
exit 0
fi

fileeex=/usr/bin/curl
minimumsizex=15000
clear
actualsizex=$(wc -c <"$fileeex")
if [ $actualsizex -ge $minimumsizex ]; then
clear
echo -e "${green}Checking...${NC}"
else
clear
echo -e "${red}Permission Denied!${NC}";
echo "Reason : Modified Package To Bypass Sc"
exit 0
fi

# data server
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
cekcloudflare=$(curl -sS http://ip-api.com/json | jq .as | grep -o "Cloudflare")
if [[ "$cekcloudflare" = "Cloudflare" ]]; then
  cekdomen=$(cat /etc/xray/domain)
  MYIP=$(dig +short "$cekdomen" | head -n 1)
fi
repogithub='kuotavpncom/kuotavpn/main'
IP=$(curl -sS ipinfo.io/ip)
repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
  curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
  if [ $? -ne 0 ]; then
    repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
    curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
    if [ $? -ne 0 ]; then
      echo -e "${red}Database Script Gagal Di Akses !${NC}"
      exit 1
    fi
  fi
fi
curl -s -H 'Cache-Control: no-cache, no-store' $repopermission | grep -w "$MYIP" > /tmp/logs.txt
# cek masa aktif
data=( `cat /tmp/logs.txt | grep -E "^### " | awk '{print $2}'` )
for user in "${data[@]}"
do
  exp=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $3}' | sort | uniq` )
  d1=(`date -d "$exp" +%s`)
  d2=(`date -d "$biji" +%s`)
  exp2=$(( (d1 - d2) / 86400 ))
  if [[ "$exp2" -le "0" ]]; then
    echo -e "${red}Script Expired !${NC}"
    echo -e "Contact Admin : t.me/kuotavpn"
    rm -rf /tmp/logs.txt
    rm -rf /tmp/ipaddress.txt
    exit 1
  else
    echo -e "${green}Script Active !${NC}"
    clear
  fi
done
checkipaddres=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $4}' | sort | uniq` )
if [[ "$MYIP" = "$checkipaddres" ]]; then
  echo -e "${green}IP Address Accepted${NC}"
  clear
else
  echo -e "${red}IP Address Not Found In Our Database${NC}"
  echo -e "Contact Admin : t.me/kuotavpn"
  rm -rf /tmp/logs.txt
  rm -rf /tmp/ipaddress.txt
  exit 1
fi
clientname=$(cat /usr/local/etc/clientname)
checkclient=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $2}' | sort | uniq` )
if [[ "$clientname" = "$checkclient" ]]; then
  echo -e "${green}Client Name Accepted${NC}"
  clear
else
  echo -e "${red}Client Name Not Compatible !${NC}"
  echo -e "Contact Admin : t.me/kuotavpn"
  rm -rf /tmp/logs.txt
  rm -rf /tmp/ipaddress.txt
  exit 1
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear
export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'
if ! grep -q -w "ban-ssh" /etc/crontab; then
echo "*/3 * * * * root ban-ssh" >> /etc/crontab
/etc/init.d/cron restart
fi
domain=$(cat /etc/xray/domain)
KEY=$(cat /etc/william/profile/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/chatid 2>/dev/null)
if [[ -z $KEY || -z $CHATID ]]; then
echo "Please Fill API BOT & CHAT ID First !!"
exit
fi
source /etc/os-release
release=$ID
ubuntu_version=$(lsb_release -a 2>/dev/null | awk '/Description/ {print $2, $3}' | cut -d. -f1 | awk {'print $2'} | cut -d. -f1)
debian_version=$(lsb_release -a 2>/dev/null | grep -w "Release" | awk {'print $2'})
if [[ ("$release" == "ubuntu" && "$ubuntu_version" -le 23) || ("$release" == "debian" && "$debian_version" -le 11) ]]; then
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
#DROPBEAR
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done > /tmp/login_dropbear.txt
MYUSER=$(cat /tmp/login_dropbear.txt | awk {'print $3'} | tr -d "'" | sort -u)
for user in $MYUSER; do
ip_limit_ssh=$(cat /etc/william/limit-ssh/$user 2>/dev/null)
cek_mulog_dropbear=$(cat /tmp/login_dropbear.txt | grep -w "$user" | wc -l)
echo -e "======================="
echo -e "AUTOBAN MULTI LOGIN SSH"
echo -e "======================="
echo -e "user : $user"
echo -e "limit login : $ip_limit_ssh"
echo -e "ip login : $cek_mulog_dropbear"
echo -e "======================="
echo ""
if [[ $cek_mulog_dropbear -gt $ip_limit_ssh && $ip_limit_ssh -ne 0 ]]; then
ngecek_banned=$(cat /etc/william/udp/listbanned-ssh.conf | grep -w "$user" | wc -l)
if [[ "$ngecek_banned" = "1" ]]; then
echo -e "user ${user} already banned"
else
MYPIDUSER=$(cat /tmp/login_dropbear.txt | grep -w "$user" | awk {'print $1'} | sort -u)
echo -e "$user" >> "/etc/william/udp/listbanned-ssh.conf"
passwd -l $user 2>/dev/null
kill $MYPIDUSER
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<b>━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN SSH</b>
<b>━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$user</code>
<b>Domain: </b><code>$domain</code>
<b>Limit Login: </b><code>$ip_limit_ssh</code>
<b>Multi Login: </b><code>$cek_mulog_dropbear</code>
<b>Action: </b><code>BANNED</code>
<b>━━━━━━━━━━━━━━━━</b>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
fi
done
#OPENSSH
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done > /tmp/login_openssh.txt
MYUSER=$(cat /tmp/login_openssh.txt | awk {'print $3'} | tr -d "'" | sort -u)
for user in $MYUSER; do
ip_limit_ssh=$(cat /etc/william/limit-ssh/$user 2>/dev/null)
cek_mulog_openssh=$(cat /tmp/login_openssh.txt | grep -w "$user" | wc -l)
echo -e "======================="
echo -e "AUTOBAN MULTI LOGIN SSH"
echo -e "======================="
echo -e "user : $user"
echo -e "limit login : $ip_limit_ssh"
echo -e "ip login : $cek_mulog_openssh"
echo -e "======================="
echo ""
if [[ $cek_mulog_openssh -gt $ip_limit_ssh && $ip_limit_ssh -ne 0 ]]; then
ngecek_banned=$(cat /etc/william/udp/listbanned-ssh.conf | grep -w "$user" | wc -l)
if [[ "$ngecek_banned" = "1" ]]; then
echo -e "user ${user} already banned"
else
MYPIDUSER=$(cat /tmp/login_openssh.txt | grep -w "$user" | awk {'print $1'} | sort -u)
echo -e "$user" >> "/etc/william/udp/listbanned-ssh.conf"
passwd -l $user 2>/dev/null
kill $MYPIDUSER
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<b>━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN SSH</b>
<b>━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$user</code>
<b>Domain: </b><code>$domain</code>
<b>Limit Login: </b><code>$ip_limit_ssh</code>
<b>Multi Login: </b><code>$cek_mulog_openssh</code>
<b>Action: </b><code>BANNED</code>
<b>━━━━━━━━━━━━━━━━</b>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
fi
done
fi

if [[ ("$release" == "ubuntu" && "$ubuntu_version" -ge 24) || ("$release" == "debian" && "$debian_version" -ge 12) ]]; then
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
if [ -e "/var/log/syslog" ]; then
        LOG="/var/log/syslog";
fi
#DROPBEAR
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $12}' | tr -d "'"`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $14}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done > /tmp/login_dropbear.txt
MYUSER=$(cat /tmp/login_dropbear.txt | awk {'print $3'} | tr -d "'" | sort -u)
for user in $MYUSER; do
ip_limit_ssh=$(cat /etc/william/limit-ssh/$user 2>/dev/null)
cek_mulog_dropbear=$(cat /tmp/login_dropbear.txt | grep -w "$user" | wc -l)
echo -e "======================="
echo -e "AUTOBAN MULTI LOGIN SSH"
echo -e "======================="
echo -e "user : $user"
echo -e "limit login : $ip_limit_ssh"
echo -e "ip login : $cek_mulog_dropbear"
echo -e "======================="
echo ""
if [[ $cek_mulog_dropbear -gt $ip_limit_ssh && $ip_limit_ssh -ne 0 ]]; then
ngecek_banned=$(cat /etc/william/udp/listbanned-ssh.conf | grep -w "$user" | wc -l)
if [[ "$ngecek_banned" = "1" ]]; then
echo -e "user ${user} already banned"
else
MYPIDUSER=$(cat /tmp/login_dropbear.txt | grep -w "$user" | awk {'print $1'} | sort -u)
echo -e "$user" >> "/etc/william/udp/listbanned-ssh.conf"
passwd -l $user 2>/dev/null
kill $MYPIDUSER
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<b>━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN SSH</b>
<b>━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$user</code>
<b>Domain: </b><code>$domain</code>
<b>Limit Login: </b><code>$ip_limit_ssh</code>
<b>Multi Login: </b><code>$cek_mulog_dropbear</code>
<b>Action: </b><code>BANNED</code>
<b>━━━━━━━━━━━━━━━━</b>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
fi
done
#OPENSSH
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $7}'`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done > /tmp/login_openssh.txt
MYUSER=$(cat /tmp/login_openssh.txt | awk {'print $3'} | tr -d "'" | sort -u)
for user in $MYUSER; do
ip_limit_ssh=$(cat /etc/william/limit-ssh/$user 2>/dev/null)
cek_mulog_openssh=$(cat /tmp/login_openssh.txt | grep -w "$user" | wc -l)
echo -e "======================="
echo -e "AUTOBAN MULTI LOGIN SSH"
echo -e "======================="
echo -e "user : $user"
echo -e "limit login : $ip_limit_ssh"
echo -e "ip login : $cek_mulog_openssh"
echo -e "======================="
echo ""
if [[ $cek_mulog_openssh -gt $ip_limit_ssh && $ip_limit_ssh -ne 0 ]]; then
ngecek_banned=$(cat /etc/william/udp/listbanned-ssh.conf | grep -w "$user" | wc -l)
if [[ "$ngecek_banned" = "1" ]]; then
echo -e "user ${user} already banned"
else
MYPIDUSER=$(cat /tmp/login_openssh.txt | grep -w "$user" | awk {'print $1'} | sort -u)
echo -e "$user" >> "/etc/william/udp/listbanned-ssh.conf"
passwd -l $user 2>/dev/null
kill $MYPIDUSER
TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<b>━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN SSH</b>
<b>━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$user</code>
<b>Domain: </b><code>$domain</code>
<b>Limit Login: </b><code>$ip_limit_ssh</code>
<b>Multi Login: </b><code>$cek_mulog_openssh</code>
<b>Action: </b><code>BANNED</code>
<b>━━━━━━━━━━━━━━━━</b>
"
curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
fi
fi
done
fi