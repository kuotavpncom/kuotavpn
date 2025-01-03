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

# cek ip address
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

# cek client name
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

user=$1

if [ -z "$1" ]; then
    echo "No username provided!"
    exit
fi

argoxray=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
argopath="/argo-vm"
domain=$(cat /etc/xray/domain)
pathku=$(cat /etc/xray/path/vmess_ws_path)
pubkey=$(cat /etc/william/slowdns/server.pub);
nsdomain=$(cat /etc/ns/domain);
ngecek=$(cat /etc/systemd/system/slowdns.service | grep -o "443")
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VMNONE" | cut -d: -f2|sed 's/ //g')"
alternatifportntls=$(cat /etc/nginx/conf.d/vmnone.conf | grep listen | sed -n '2,$p' | awk '{printf $2 ", "; if(NR==FNR) printf ""}' | sed '$s/, $/./')
protocol1=$(grep -E -w "VmessWS-TLS" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 4-4 | head -1)
protocol2=$(grep -E -w "VmessWS-NTLS" "/usr/local/etc/xray/none.json" | cut -d ' ' -f 4-4 | head -1)
if [[ $protocol1 = "VmessWS-TLS" ]];
then
echo "found"
else
echo "You have no existing clients!"
exit 1
fi
NUMBER_OF_CLIENTS=$(grep -c -E "$protocol1 " "/usr/local/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi


# Check Exp Info
exp=$(grep -w "$user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 1-4 | head -n1 | awk {'print $3'})
if [ -z "$exp" ]; then
echo -e "User $user Not Found"
exit
fi
if [[ "$exp" =~ ^[0-9]+$ ]]; then
expinfo=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
fi
exp_timestamp=$(date -d "@${exp}" +%s)
current_timestamp=$(date +%s)
days_left=$(( (exp_timestamp - current_timestamp + 86399) / 86400 ))
if [[ $days_left -lt 0 ]]; then
days_left=0
fi
uuid=$(cat /usr/local/etc/xray/config.json | grep -w "$user" | awk {'print $2'} | tail -n 1 | tr -d '"' | sed 's/level://g' | tr -d ',')
cat>/etc/xray/vmess/$user-tls.json<<EOF
{
    "v": "2",
    "ps": "${user}",
    "add": "${domain}",
    "port": "${tls}",
    "id": "${uuid}",
    "aid": "0",
    "net": "ws",
    "path": "${pathku}",
    "type": "none",
    "host": "${domain}",
    "tls": "tls"
}
EOF

cat>/etc/xray/vmess/$user-none.json<<EOF
{
    "v": "2",
    "ps": "${user}",
    "add": "${domain}",
    "port": "${none}",
    "id": "${uuid}",
    "aid": "0",
    "net": "ws",
    "path": "${pathku}",
    "type": "none",
    "host": "${domain}",
    "tls": "none"
}
EOF
if [[ -n $argoxray ]]; then
argolinktls=$(echo 'vmess://'$(echo '{"add":"'$argoxray'","aid":"0","host":"'$argoxray'","id":"'$uuid'","net":"ws","path":"'$argopath'","port":"443","ps":"'${user}'","tls":"tls","type":"none","v":"2"}' | base64 -w 0))
argolinkntls=$(echo 'vmess://'$(echo '{"add":"'$argoxray'","aid":"0","host":"'$argoxray'","id":"'$uuid'","net":"ws","path":"'$argopath'","port":"80","ps":"'${user}'","tls":"","type":"none","v":"2"}' | base64 -w 0))
fi
vmesslink1="vmess://$(base64 -w 0 /etc/xray/vmess/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/xray/vmess/$user-none.json)"
clear
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "[XRAY/VMESS_WS]"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks : ${user}"
ceklimit_ip=$(cat /etc/william/limit-xray/vmessws/$user 2>/dev/null)
if [[ -z $ceklimit_ip || $ceklimit_ip == 0 ]]; then
    echo -e "Limit IP : No Limit"
else
    echo -e "Limit IP : $ceklimit_ip"
fi
echo -e "IP Address : ${MYIP}"
echo -e "Domain : ${domain}"
if [[ "$ngecek" = "443" ]]; then
    echo -e "DNS Domain : $nsdomain"
    echo -e "Pub key slowdns : $pubkey"
fi
echo -e "Port TLS : ${tls}"
echo -e "Port NONE-TLS : ${none}"
echo -e "Port Alternatif NONE-TLS : $alternatifportntls"
if [[ -n $argoxray ]]; then
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Argo WS Domain : $argoxray"
echo -e "Argo WS Path : $argopath"
echo -e "Argo NTLS PORT : 80, 8080, 8880, 2052, 2082, 2086, 2095"
echo -e "Argo TLS PORT : 443, 2053, 2083, 2087, 2096, 8443"
echo -e "━━━━━━━━━━━━━━━━━━━━"
fi
echo -e "ID : ${uuid}"
echo -e "Network : Websocket"
echo -e "Websocket Path : ${pathku}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS TLS : ${vmesslink1}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS NONE-TLS : ${vmesslink2}"
echo -e "━━━━━━━━━━━━━━━━━━━━"
if [[ -n $argoxray ]]; then
echo -e "LINK WS ARGO TLS : $argolinktls"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK WS ARGO NTLS : $argolinkntls"
echo -e "━━━━━━━━━━━━━━━━━━━━"
fi
if [[ "$exp" =~ ^[0-9]+$ ]]; then
echo "Expired On  : $expinfo ($days_left days left)"
else
echo "Expired On  : $exp"
fi