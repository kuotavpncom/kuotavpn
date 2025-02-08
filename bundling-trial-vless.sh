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
cp /tmp/permission.txt /tmp/logs.txt
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

domain=$(cat /etc/xray/domain)
pathws=$(cat /etc/xray/path/vless_ws_path)
pathgrpc=$(cat /etc/xray/path/vless_grpc_path)
pathhttpupgrade=$(cat /etc/xray/path/vless_upgrade_path)
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VLNONE" | cut -d: -f2|sed 's/ //g')"
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
        echo "Invalid choice. Please enter a number between 1 and 5."
        exit
        ;;
esac
cekvalidasi=$(cat /usr/local/etc/xray/config.json | grep -i "${user}_ws" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user ${user}_ws already exist"
echo "please choose another name"
exit 1
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vlessws$/a\### '"${user}_ws $exp VlessWS-TLS "'\
,{"id": "'""$uuid""'","level": '"0"',"email": "'""${user}_ws""'"}' /usr/local/etc/xray/config.json
sed -i '/#vlessWS$/a\### '"${user}_ws $exp VlessWS-NTLS "'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""${user}_ws""'"' /usr/local/etc/xray/none.json
sed -i '/#vlessGRPCX$/a\### '"${user}_grpc $exp VlessGRPC "'\
,{"id": "'""$uuid""'","add": "'""www.cloudflare.com""'","email": "'""${user}_grpc""'"}' /usr/local/etc/xray/config.json
sed -i '/#vlessxtls$/a\### '"${user}_xtls $exp VlessXTLS "'\
,{"id": "'""$uuid""'","flow": "'"xtls-rprx-vision"'","level": '"0"',"email": "'""${user}_xtls""'"}' /usr/local/etc/xray/will666.json
sed -i '/#vlessupgrade$/a\### '"${user}_httpupgrade $exp VlessUPGRADE-TLS "'\
,{"id": "'""$uuid""'","security": "'""auto""'","email": "'""${user}_httpupgrade""'"}' /usr/local/etc/xray/config.json
sed -i '/#vlessUPGRADE$/a\### '"${user}_httpupgrade $exp VlessUPGRADE-NTLS "'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""${user}_httpupgrade""'"' /usr/local/etc/xray/none.json
vlesslink1ws="vless://${uuid}@${domain}:$tls?path=$pathws&security=tls&encryption=none&type=ws#${user}_ws"
vlesslink2ws="vless://${uuid}@${domain}:$none?path=$pathws&encryption=none&type=ws#${user}_ws"
vlesslink1grpc="vless://${uuid}@${domain}:${tls}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=${pathgrpc}&sni=${domain}#${user}_grpc"
vlesslink1xtls="vless://${uuid}@${domain}:${tls}?security=xtls&encryption=none&headerType=none&type=tcp&flow=xtls-rprx-vision&sni=isi_bug_disini#${user}_xtls"
vlesslink1httpupgrade="vless://${uuid}@${domain}:$tls?path=$pathhttpupgrade&security=tls&encryption=none&host=$domain&type=httpupgrade&sni=$domain#${user}_httpupgrade"
vlesslink2httpupgrade="vless://${uuid}@${domain}:$none?path=$pathhttpupgrade&security=none&encryption=none&host=$domain&type=httpupgrade#${user}_httpupgrade"
clear
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━━[XRAY/VLESS]━━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks WS : ${user}_ws"
echo -e "Remarks HTTPUpgrade : ${user}_httpupgrade"
echo -e "Remarks gRPC : ${user}_grpc"
echo -e "Remarks TCP XTLS : ${user}_xtls"
echo -e "IP Address : ${MYIP}"
echo -e "Port TLS : ${tls}"
echo -e "Port NONE-TLS : ${none}"
echo -e "ID : ${uuid}"
echo -e "Domain : ${domain}"
echo -e "Network : Websocket, gRPC, TCP, HTTPUpgrade"
echo -e "Websocket Path : ${pathws}"
echo -e "HTTPUpgrade Path : ${pathhttpupgrade}"
echo -e "gRPC ServiceName : ${pathgrpc}"
echo -e "Flow : xtls-rprx-vision"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS TLS : ${vlesslink1ws}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS NONE-TLS : ${vlesslink2ws}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK HTTPUPGRADE TLS : ${vlesslink1httpupgrade}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK HTTPUPGRADE NONE-TLS : ${vlesslink2httpupgrade}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK gRPC TLS : ${vlesslink1grpc}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK TCP XTLS : ${vlesslink1xtls}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "EXPIRED ON : $expuser hours"
sleep 3
systemctl restart xray
systemctl restart will666
systemctl restart xray@none