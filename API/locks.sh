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
repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.kuotavpn.com/ZGFmdGFySVA'
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

# cek ip address
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

# cek client name
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

user=$1

if [ -z "$user" ]; then
    echo "Please Input user !"
    exit 1
fi
ngecek_banned=$(cat /etc/william/udp/listbanned-ssh.conf | grep -w "$user" | wc -l)
if [[ "$ngecek_banned" = "1" ]]; then
echo -e "user ${user} already locked"
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
killpid_dropbear=$(cat $LOG | grep -i dropbear | grep -E "Password auth succeeded.*$user" | grep -oP '\[\d+\]' | tr -d '[]' | tail -n 1 | sort -u)
if [[ -n $killpid_dropbear ]]; then
kill $killpid_dropbear
fi
#OPENSSH
killpid_openssh=$(cat $LOG | grep -i sshd | grep -E "Accepted password for.*$user" | grep -oP '\[\d+\]' | tr -d '[]' | tail -n 1 | sort -u)
if [[ -n $killpid_openssh ]]; then
kill $killpid_openssh
fi
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
killpid_dropbear=$(cat $LOG | grep -i dropbear | grep -E "Password auth succeeded.*$user" | grep -oP '\[\d+\]' | tr -d '[]' | tail -n 1 | sort -u)
if [[ -n $killpid_dropbear ]]; then
kill $killpid_dropbear
fi
#OPENSSH
killpid_openssh=$(cat $LOG | grep -i sshd | grep -E "Accepted password for.*$user" | grep -oP '\[\d+\]' | tr -d '[]' | tail -n 1 | sort -u)
if [[ -n $killpid_openssh ]]; then
kill $killpid_openssh
fi
fi
echo -e "$user" >> "/etc/william/udp/listbanned-ssh.conf"
passwd -l $user 2>/dev/null
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LOCK ACCOUNT SUCCESS !"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "user : $user"
echo -e "━━━━━━━━━━━━━━━━━━━━"