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
repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/logs.txt
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

pathku=$(cat /etc/xray/path/vmess_tcp_path)
source /var/lib/premium-script/ipvps.conf
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
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
cekvalidasi=$(cat /usr/local/etc/xray/config.json | grep -i "$user" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user $user already exist"
echo "please choose another name"
exit 1
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#vmesstcp$/a\### '"$user $exp Vmess-TCP "'\
,{"id": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/config.json
cat>/etc/xray/vmess/$user-tcp.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${tls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "tcp",
      "path": "${pathku}",
      "type": "http",
      "host": "",
      "tls": "tls"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmesslink1="vmess://$(base64 -w 0 /etc/xray/vmess/$user-tcp.json)"
systemctl restart xray
service cron restart
clear
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━[XRAY/VMESS_TCP_HTTP]━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks : ${user}"
echo -e "IP Address : ${MYIP}"
echo -e "Domain : ${domain}"
echo -e "Port TLS : ${tls}"
echo -e "ID : ${uuid}"
echo -e "Network : TCP"
echo -e "Head Type : HTTP"
echo -e "HTTP Path : ${pathku}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK TCP HTTP TLS : ${vmesslink1}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "EXPIRED ON : $expuser hour"