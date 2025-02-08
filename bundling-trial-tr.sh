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
IP=$(curl -sS ipinfo.io/ip)
repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
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

domain=$(cat /etc/xray/domain)
pathws=$(cat /etc/xray/path/trojan_ws_path)
pathgrpc=$(cat /etc/xray/path/trojan_grpc_path)
pathhttpupgrade=$(cat /etc/xray/path/trojan_upgrade_path)
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
        echo "Invalid choice. Please enter a number between 1 and 5."
        exit
        ;;
esac
cekvalidasi=$(cat /usr/local/etc/xray/will69.json | grep -i "${user}_tcp" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user ${user}_tcp already exist"
echo "please choose another name"
exit 1
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojanws$/a\### '"${user}_ws $exp TrojanWS "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""${user}_ws""'"}' /usr/local/etc/xray/config.json
sed -i '/#trojanGRPCX$/a\### '"${user}_grpc $exp TrojanGRPC "'\
,{"password": "'""$uuid""'","add": "'""www.cloudflare.com""'","email": "'""${user}_grpc""'"}' /usr/local/etc/xray/config.json
sed -i '/#trojantcp$/a\### '"${user}_tcp $exp Trojan "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""${user}_tcp""'"}' /usr/local/etc/xray/will69.json
sed -i '/#trojanupgrade$/a\### '"${user}_httpupgrade $exp TrojanUPGRADE-TLS "'\
,{"password": "'""$uuid""'","security": "'""auto""'","email": "'""${user}_httpupgrade""'"}' /usr/local/etc/xray/config.json
trojanlinkws="trojan://${uuid}@${domain}:${tls}?path=${pathws}&security=tls&host=${domain}&type=ws&sni=${domain}#${user}_ws"
trojanlinkgrpc="trojan://${uuid}@${domain}:${tls}?mode=gun&security=tls&type=grpc&serviceName=${pathgrpc}&sni=${domain}#${user}_grpc"
trojanlinktcp="trojan://$uuid@$domain:$tls?security=tls&alpn=http/1.1&headerType=none&type=tcp&sni=isi_bug_disini#${user}_tcp"
trojanlinkhttpupgrade="trojan://${uuid}@${domain}:${tls}?path=${pathhttpupgrade}&security=tls&host=${domain}&type=httpupgrade&sni=${domain}#${user}_httpupgrade"
clear
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━━[XRAY/TROJAN]━━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks WS : ${user}_ws"
echo -e "Remarks HTTPUpgrade : ${user}_httpupgrade"
echo -e "Remarks gRPC : ${user}_grpc"
echo -e "Remarks TCP : ${user}_tcp"
echo -e "IP Address : ${MYIP}"
echo -e "Domain : ${domain}"
echo -e "Port TLS : ${tls}"
echo -e "Password : ${uuid}"
echo -e "Network : Websocket, gRPC, TCP, HTTPUpgrade"
echo -e "Websocket Path : ${pathws}"
echo -e "HTTPUpgrade Path : ${pathhttpupgrade}"
echo -e "gRPC ServiceName : ${pathgrpc}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS TLS : ${trojanlinkws}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK HTTPUpgrade TLS : ${trojanlinkhttpupgrade}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK gRPC TLS : ${trojanlinkgrpc}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK TCP TLS : ${trojanlinktcp}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "EXPIRED ON : $expuser hours"
sleep 3
systemctl restart xray
systemctl restart will69