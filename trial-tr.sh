#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
IP=$(curl -s ipinfo.io/ip > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
if [ -z "$MYIP" ]; then
IP=$(curl -s http://ip-api.com/json | jq .query | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi
if [ -z "$MYIP" ]; then
IP=$(curl -s ipinfo.io | jq .ip | tr -d '"' > /tmp/ipaddress.txt)
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
cekcloudflare=$(curl -s http://ip-api.com/json | jq .as | grep -o "Cloudflare")
if [[ "$cekcloudflare" = "Cloudflare" ]]; then
  cekdomen=$(cat /etc/xray/domain)
  MYIP=$(dig +short "$cekdomen" | head -n 1)
fi
repogithub='kuotavpncom/kuotavpn/main'
repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.berkahost.com/permission.txt'
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
    echo -e "Contact Admin : t.me/emdevika"
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
  echo -e "Contact Admin : t.me/emdevika"
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
  echo -e "Contact Admin : t.me/emdevika"
  rm -rf /tmp/logs.txt
  rm -rf /tmp/ipaddress.txt
  exit 1
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

LinkClash=$(curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/willstore69/config/main/clash.yaml > /tmp/clash.yaml)
LinkJson=$(curl -s -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/willstore69/config/main/config.json > /tmp/config.json)
domain=$(cat /etc/xray/domain)
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
echo ""
user=trial69`</dev/urandom tr -dc X-Z0-9 | head -c5`
echo "random user : $user"
read -p "Expired (1-5 hours): " expuser
case $expuser in
    1)
        exp=$(date -d "+60 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    2)
        exp=$(date -d "+120 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    3)
        exp=$(date -d "+180 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    4)
        exp=$(date -d "+240 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    5)
        exp=$(date -d "+300 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 4."
        exit
        ;;
esac
cekvalidasi=$(cat /usr/local/etc/xray/will69.json | grep -i "$user" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user $user already exist"
echo "please choose another name"
exit 1
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojantcp$/a\### '"$user $expired_date Trojan "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/will69.json
trojanlink="trojan://$uuid@$domain:$tls?security=tls&alpn=http/1.1&headerType=none&type=tcp&sni=isi_bug_disini#$user"
systemctl restart will69
random=$(echo $RANDOM | md5sum | head -c 4; echo;)
mkdir -p /home/vps/public_html/config/
# untuk clash
sed -i "s/nama_kamu/$user/g" /tmp/clash.yaml
sed -i "s/domain_kamu/$domain/g" /tmp/clash.yaml
sed -i "s/port_kamu/$tls/g" /tmp/clash.yaml
sed -i "s/password_kamu/$uuid/g" /tmp/clash.yaml
mv /tmp/clash.yaml /home/vps/public_html/config/$random-$user-clash.yaml
# untuk json
sed -i "s/domain_kamu/$domain/g" /tmp/config.json
sed -i "s/password_kamu/$uuid/g" /tmp/config.json
sed -i "s/port_kamu/$tls/g" /tmp/config.json
mv /tmp/config.json /home/vps/public_html/config/$random-$user-config.json
clear
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━━[XRAY/TROJAN]━━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks : ${user}"
echo -e "IP Address : ${MYIP}"
echo -e "Domain : ${domain}"
echo -e "Port TLS : ${tls}"
echo -e "Password : ${uuid}"
echo -e "Network : TCP"
echo -e "Alpn : http/1.1"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK TLS : ${trojanlink}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK CLASH : http://$domain:8081/config/$random-$user-clash.yaml"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK JSON : http://$domain:8081/config/$random-$user-config.json"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Expired : $expuser hour"
rm -rf /tmp/config.json
rm -rf /tmp/clash.yaml