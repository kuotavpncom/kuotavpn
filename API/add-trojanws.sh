#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit
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
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit
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
exit
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
exit
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

# Ambil parameter dari input
user=$1
masaaktif=$2
limit_ip=$3

# Lakukan validasi sederhana (opsional)
if [[ -z "$user" || -z "$masaaktif" ]]; then
    echo "User and expiration period are required"
    exit
fi

argoxray=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
argopath="/argo-tr"
domain=$(cat /etc/xray/domain)
pathku=$(cat /etc/xray/path/trojan_ws_path)
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
cekvalidasi=$(cat /usr/local/etc/xray/config.json | grep -i "$user" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user $user already exist"
echo "please choose another name"
exit
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
KEY=$(cat /etc/william/profile/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/key 2>/dev/null)
if [[ -n $KEY || -n $CHATID ]]; then
if [[ -z "$limit_ip" || "$limit_ip" == "0" ]]; then
  limit_ip="0"
fi
echo "$limit_ip" > "/etc/william/limit-xray/trojanws/$user"
fi
exp=`date -d "+$masaaktif days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
sed -i '/#trojanws$/a\### '"$user $exp TrojanWS "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/config.json
if [[ -n $argoxray ]]; then
sed -i '/#trojanws$/a\### '"$user $exp TrojanWS "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /etc/cf-argo/config.json
fi
trojanlink="trojan://${uuid}@${domain}:${tls}?path=${pathku}&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"
argolinktls="trojan://${uuid}@${argoxray}:443?path=${argopath}&security=tls&host=${argoxray}&type=ws&sni=${argoxray}#${user}"
argolinkntls="trojan://${uuid}@${argoxray}:80?path=${argopath}&security=none&host=${argoxray}&type=ws#${user}"
clear
echo -e ""
{
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "[XRAY/TROJAN_WS]"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks : ${user}"
ceklimit_ip=$(cat /etc/william/limit-xray/trojanws/$user 2>/dev/null)
if [[ -z $ceklimit_ip ]]; then
echo -e "Limit IP : Not Active"
else
if [ "$ceklimit_ip" == "0" ]; then
echo -e "Limit IP : No Limit IP Login"
else
echo -e "Limit IP : $limit_ip"
fi
fi
echo -e "IP Address : ${MYIP}"
echo -e "Domain : ${domain}"
echo -e "Port TLS : ${tls}"
if [[ -n $argoxray ]]; then
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Argo WS Domain : $argoxray"
echo -e "Argo WS Path : $argopath"
echo -e "Argo NTLS PORT : 80, 8080, 8880, 2052, 2082, 2086, 2095"
echo -e "Argo TLS PORT : 443, 2053, 2083, 2087, 2096, 8443"
echo -e "━━━━━━━━━━━━━━━━━━━━"
fi
echo -e "Password : ${uuid}"
echo -e "Network : Websocket"   
echo -e "Websocket Path : ${pathku}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS TLS : ${trojanlink}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
if [[ -n $argoxray ]]; then
echo -e "LINK WS ARGO TLS : $argolinktls"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS ARGO NTLS : $argolinkntls"
echo -e "━━━━━━━━━━━━━━━━━━━━"
fi
echo -e "EXPIRED ON : $detail_exp"
} 2>&1 | tee -a /tmp/created-trws.log
sed -i 's/Password : \(.*\)/Password : <code>\1<\/code>/g' /tmp/created-trws.log
sed -i 's/LINK WS TLS : \(.*\)/LINK WS TLS : <code>\1<\/code>/g' /tmp/created-trws.log
KEY=$(cat /etc/william/profile/private/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/private/chatid 2>/dev/null)
message=$(cat /tmp/created-trws.log)
curl -s -X POST https://api.telegram.org/bot${KEY}/sendMessage -F chat_id="${CHATID}" -F text="
$message" -F parse_mode=html > /dev/null 2>&1
rm -rf /tmp/created-trws.log
xv $user $uuid trojan-ws
if [[ -n $argoxray ]]; then
systemctl restart argo-xray
fi