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
if ! which rsync > /dev/null; then
apt install rsync -y
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

DOMAIN=$(cat /etc/xray/domain);
IP=$(curl -sS ipinfo.io/ip)
if [ -z "$IP" ]; then
IP=$(curl -sS http://ip-api.com/json | jq .query | tr -d '"')
fi
if [ -z "$IP" ]; then
IP=$(curl -sS ipinfo.io | jq .ip | tr -d '"')
fi
date=$(date +"%Y-%m-%d")
tanggal=$(date +"%d-%m-%Y");
clear
echo " Enter Your Email To Receive Message"
read -rp " Email: " -e email
sleep 1
echo Membuat Directory
mkdir /root/backup
sleep 1
echo Start Backup
clear
cp /root/log-install.txt backup/
cp /etc/passwd backup/
cp /etc/group backup/
cp /etc/shadow backup/
cp /etc/gshadow backup/
cp /etc/ppp/chap-secrets backup/chap-secrets
cp /etc/ipsec.secrets backup/ipsec.secrets
cp /etc/ipsec.d/passwd backup/passwd1
cp /usr/local/etc/xray/ssh.json backup/
cp /usr/local/etc/xray/config.json backup/
cp /usr/local/etc/xray/none.json backup/
cp /usr/local/etc/xray/will666.json backup/
cp /usr/local/etc/xray/will69.json backup/
argoxray=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
if [[ -n $argoxray ]]; then
cp /etc/cf-argo/config.json backup/
fi
cp /etc/systemd/system/cdn.service backup/
cp /etc/issue.net backup/
cp -r /etc/william/ backup/william
cp -r /etc/william/slowdns backup/slowdns
cp -r /etc/ssl/private/ backup/private
cp -r /var/lib/premium-script/ backup/premium-script
cp -r /home/vps/public_html backup/public_html
cp -r /etc/nginx/conf.d backup/conf.d
rsync -av --exclude='/vmess/' /etc/xray/ /root/backup/xray/
cp -r /etc/v2ray/ backup/v2ray/
cd /root
zip -r -P "sc by @kuotavpn" $IP-$tanggal.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip william:backup/
url=$(rclone link william:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
https://drive.google.com/uc?export=download&id=$id
echo -e "The following is a link to your vps data backup file.

Your VPS IP » $IP
Your Domain » $DOMAIN
Tanggal Backup » $tanggal

$link

If you want to restore data, please enter the link above.

Thank You For Using Our Services" | mail -s "Backup Data" $email
rm -rf /root/backup
rm -r /root/$IP-$date.zip
echo "Done"
echo "Please Check Your Email"

