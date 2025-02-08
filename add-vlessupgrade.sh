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

domain=$(cat /etc/xray/domain)
pathku=$(cat /etc/xray/path/vless_upgrade_path)
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VMNONE" | cut -d: -f2|sed 's/ //g')"
alternatifportntls=$(cat /etc/nginx/conf.d/vmnone.conf | grep listen | sed -n '2,$p' | awk '{printf $2 ", "; if(NR==FNR) printf ""}' | sed '$s/, $/./')
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
cekvalidasi=$(cat /usr/local/etc/xray/config.json | grep -i "$user" | awk {'print $2'} | head -1 | wc -l)
if [ "$cekvalidasi" == "1" ]; then
echo ""
echo "user $user already exist"
echo "please choose another name"
exit 1
fi
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "+$masaaktif days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
sed -i '/#vlessupgrade$/a\### '"$user $exp VlessUPGRADE-TLS "'\
,{"id": "'""$uuid""'","security": "'""auto""'","email": "'""$user""'"}' /usr/local/etc/xray/config.json
sed -i '/#vlessUPGRADE$/a\### '"$user $exp VlessUPGRADE-NTLS "'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/none.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=$pathku&security=tls&encryption=none&host=$domain&type=httpupgrade&sni=$domain#$user"
vlesslink2="vless://${uuid}@${domain}:$none?path=$pathku&security=none&encryption=none&host=$domain&type=httpupgrade#$user"
clear
echo -e ""
{
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━[XRAY/VLESS_UPGRADE]━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "Remarks : ${user}"
echo -e "Domain : ${domain}"
echo -e "IP Address : ${MYIP}"
echo -e "Port TLS : ${tls}"
echo -e "Port NONE-TLS : ${none}"
echo -e "Port Alternatif NONE-TLS : $alternatifportntls"
echo -e "ID : ${uuid}"
echo -e "Network : HTTPUpgrade"
echo -e "HTTPUpgrade Path : ${pathku}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK HTTPUPGRADE TLS : ${vlesslink1}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "LINK HTTPUPGRADE NONE-TLS : ${vlesslink2}"
echo -e "━━━━━━━━━━━━━━━━━━━━━"
echo -e "EXPIRED ON : $detail_exp"
} 2>&1 | tee -a /tmp/created-vless.log
sed -i 's/ID : \(.*\)/ID : <code>\1<\/code>/g' /tmp/created-vless.log
sed -i 's/LINK HTTPUPGRADE TLS : \(.*\)/LINK HTTPUPGRADE TLS : <code>\1<\/code>/g' /tmp/created-vless.log
sed -i 's/LINK HTTPUPGRADE NONE-TLS : \(.*\)/LINK HTTPUPGRADE NONE-TLS : <code>\1<\/code>/g' /tmp/created-vless.log
KEY=$(cat /etc/william/profile/private/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/private/chatid 2>/dev/null)
message=$(cat /tmp/created-vless.log)
curl -s -X POST https://api.telegram.org/bot${KEY}/sendMessage -F chat_id="${CHATID}" -F text="
$message" -F parse_mode=html > /dev/null 2>&1
rm -rf /tmp/created-vless.log
xv $user $uuid vless-ws