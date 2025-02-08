#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo -e "Im Watching You..."
  echo -e "- @user_legend"
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
echo -e "Wget is already installed"
fi

if ! which curl > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo -e "curl is already installed"
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
echo -e "Reason : Modified Package To Bypass Sc"
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
echo -e "Reason : Modified Package To Bypass Sc"
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
IP=$(curl -sS ipinfo.io/ip) 
repogithub='kuotavpncom/kuotavpn/main'
repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
  curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/permission.txt
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

cekingg=$(cat /etc/client_sc/auth_key > /dev/null 2>&1);
if [ -z "$cekingg" ]; then
status="${red}OFF$NC"
else
status="${green}ON$NC"
fi
mkdir -p /etc/client_sc/
echo -e "======================"
echo -e "protect mitigation http-ddos"
echo -e "- version 6.9"
echo -e "- by t.me/kuotavpn"
echo -e "======================"
if [ -n "$cekingg" ]; then
echo -e "status: $status"
echo -e "no need to do anything !"
echo -e "======================"
exit 1
else
echo -e "status: $status"
read -p "Please Input Your Email CF : " email
echo -e "$email" > /etc/client_sc/email
echo -e "ok"
sleep 2
read -p "Please Input Your Global API KEY CF : " auth_key
echo -e "$auth_key" > /etc/client_sc/auth_key
echo -e "ok"
sleep 2
read -p "Please Input Your sub.domain : " mysubdomain
pisahsub=$(echo -e "$mysubdomain" | cut -d'.' -f2-999)
echo -e "$auth_key" > /etc/client_sc/auth_key
echo -e "ok"
sleep 2
clear
okay.... please wait !
wget --no-check-certificate -q -O /etc/ssl/private/fullchain.pem "https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/crot.crt"
wget --no-check-certificate -q -O /etc/ssl/private/privkey.pem "https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/crot.key"
sleep 1
# CEK ZONE
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${pisahsub}&status=active" \
     -H "X-Auth-Email: ${email}" \
     -H "X-Auth-Key: ${auth_key}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

sleep 1
# POINTING A
curl -s --request POST \
  --url https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records \
  --header 'Content-Type: application/json' \
  --header "X-Auth-Email: $email" \
  --header "X-Auth-Key: $auth_key" \
  --data '{
  "name": "'${mysubdomain}'",
  "proxied": false,
  "settings": {},
  "tags": [],
  "ttl": 60,
  "content": "'${ipaddress}'",
  "type": "A"
}' > /dev/null
#
clear
echo -e "$mysubdomain" > /etc/xray/domain
echo -e "$mysubdomain" > /etc/v2ray/domain
echo -e "DONE !"
systemctl restart xray
systemctl restart xray@none
systemctl restart will666
systemctl restart will69
fi

#NOTE BUAT YANG DEC
#LU GA BAKALAN NEMU APA APA DISINI
#DAN LU BAKALAN BINGUNG DIMANA LETAK PROTECT NYA
#KARENA BUKAN FILE INI JAWABANNYA
#YAUDAHSI
#STOPDEC
#- WILL