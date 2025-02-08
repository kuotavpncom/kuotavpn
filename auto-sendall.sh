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

FILE=/home/apibot3
if [[ -z $(grep '[^[:space:]]' $FILE) ]] ; then
clear
echo -e "UPS ! You Dont Settings Api Bot, Please Use Menu auto-sendvpn First !"
exit 0
fi
chatid=$(cat /home/chatid3)
apibot=$(cat /home/apibot3)
INIPERTAMA () {
DOMAIN=$(cat /etc/xray/domain);
nsdomain=$(cat /etc/ns/domain);
pubkey=$(cat /etc/william/slowdns/server.pub);
clear
IP=$(wget -qO- ipinfo.io/ip);
ssl="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d: -f2)"
ssl2="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d " " -f 22|sed 's/,//g')"
ws="$(cat ~/log-install.txt | grep -w "SSHWS" | cut -d: -f2|sed 's/ //g')"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpnssl="$(cat ~/log-install.txt | grep -w "OpenVPN SSL" | cut -d: -f2|sed 's/ //g')"
ovpnws="$(cat ~/log-install.txt | grep -w "OpenVPN WS" | cut -d: -f2|sed 's/ //g')"
Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
Pass=$Login
echo Ping Host
echo Cek Hak Akses...
sleep 0.5
echo Permission Accepted
clear
sleep 0.5
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "+1 days" +"%Y-%m-%d"` -s /bin/false -M $Login
expired_date=`date -d "+1 days" +"%Y-%m-%d"`
exp=`date -d "+1 days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
exp_timestamp=$(date -d "@${exp}" +%s)
current_timestamp=$(date +%s)
days_left=$(( (exp_timestamp - current_timestamp + 86399) / 86400 ))
if [[ $days_left -lt 0 ]]; then
days_left=0
fi
limit_quota=5
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null

# Hapus pesan sebelumnya jika ada
if [ -f /tmp/message_id_ssh.txt ]; then
    OLD_MESSAGE_ID=$(cat /tmp/message_id_ssh.txt)
    DELETE_RESULT=$(curl -s -X POST https://api.telegram.org/bot${apibot}/deleteMessage \
     -F chat_id="${chatid}" -F message_id="${OLD_MESSAGE_ID}")
    
    # If delete message fails, print error and continue
    if [[ "$DELETE_RESULT" == *"error_code"* ]]; then
        echo "Failed to delete previous message. Continuing to send new message."
    fi
fi

MESSAGE_ID=$(curl -s -X POST https://api.telegram.org/bot${apibot}/sendMessage \
 -F chat_id="${chatid}" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
━━━━━━━━━━━━━━━━━━━━━━
⚡️ Detail Akun Trial SSH VPN ⚡️
━━━━━━━━━━━━━━━━━━━━━━
Server : $DOMAIN
Username : $Login
Password : $Pass
Expired : $expired_date ($days_left days)
━━━━━━━━━━━━━━━━━━━━━━
Dropbear : 443
Stunnel : $ssl
WS HTTP : 2052
WS TLS : 443
Config OpenVPN : http://$DOMAIN:8081/ovpn.zip
━━━━━━━━━━━━━━━━━━━━━━
DNS Hostname : $nsdomain
Port stunnel : $ssl
Dns for slowdns : 1.1.1.1 / 8.8.8.8
Pub key slowdns : $pubkey
━━━━━━━━━━━━━━━━━━━━━━\`\`\`" | jq -r '.result.message_id')

# Simpan ID pesan baru ke file
echo "${MESSAGE_ID}" > /tmp/message_id_ssh.txt

INIKEDUA
}

INIKEDUA () {
MYIP=$(curl -s ipinfo.io/ip)
if [ -z "$MYIP" ]; then
MYIP=$(curl -s http://ip-api.com/json | jq .query | tr -d '"')
fi
if [ -z "$MYIP" ]; then
MYIP=$(curl -s ipinfo.io | jq .ip | tr -d '"')
fi
DOMAIN=$(cat /etc/xray/domain);
pathku=$(cat /etc/xray/path/trojan_ws_path)
source /var/lib/premium-script/ipvps.conf
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
expired_date=`date -d "+1 days" +"%Y-%m-%d"`
exp=`date -d "+1 days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
exp_timestamp=$(date -d "@${exp}" +%s)
current_timestamp=$(date +%s)
days_left=$(( (exp_timestamp - current_timestamp + 86399) / 86400 ))
if [[ $days_left -lt 0 ]]; then
days_left=0
fi
limit_quota=5
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
sed -i '/#trojanws$/a\### '"$user $expired_date TrojanWS "'\
,{"password": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/config.json
trojanlink="trojan://${uuid}@isi_bug_disini:${tls}?path=${pathku}&security=tls&host=${domain}&type=ws&sni=${domain}#${user}"

# Hapus pesan sebelumnya jika ada
if [ -f /tmp/message_id_trojan.txt ]; then
    OLD_MESSAGE_ID=$(cat /tmp/message_id_trojan.txt)
    DELETE_RESULT=$(curl -s -X POST https://api.telegram.org/bot${apibot}/deleteMessage \
     -F chat_id="${chatid}" -F message_id="${OLD_MESSAGE_ID}")
    
    # If delete message fails, print error and continue
    if [[ "$DELETE_RESULT" == *"error_code"* ]]; then
        echo "Failed to delete previous message. Continuing to send new message."
    fi
fi

MESSAGE_ID=$(curl -s -X POST https://api.telegram.org/bot${apibot}/sendMessage \
 -F chat_id="${chatid}" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
━━━━━━━━━━━━━━━━━━━━━━
⚡️ Detail Akun Trial TROJAN WS ⚡️
━━━━━━━━━━━━━━━━━━━━━━
Server : ${domain}
Username : ${user}
UUID : ${uuid}
Quota : ${limit_quota}GB
Expired : $expired_date ($days_left days)
━━━━━━━━━━━━━━━━━━━━━━
Port TROJAN : ${tls}
Path : ${pathku}
━━━━━━━━━━━━━━━━━━━━━━
link : ${trojanlink}
━━━━━━━━━━━━━━━━━━━━━━\`\`\`" | jq -r '.result.message_id')

# Simpan ID pesan baru ke file
echo "${MESSAGE_ID}" > /tmp/message_id_trojan.txt

INIKETIGA
}

INIKETIGA () {
MYIP=$(curl -s ipinfo.io/ip)
if [ -z "$MYIP" ]; then
MYIP=$(curl -s http://ip-api.com/json | jq .query | tr -d '"')
fi
if [ -z "$MYIP" ]; then
MYIP=$(curl -s ipinfo.io | jq .ip | tr -d '"')
fi
DOMAIN=$(cat /etc/xray/domain);
pathku=$(cat /etc/xray/path/vless_ws_path)
source /var/lib/premium-script/ipvps.conf
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VLNONE" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "A client with the specified name $Login was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
expired_date=`date -d "+1 days" +"%Y-%m-%d"`
exp=`date -d "+1 days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
exp_timestamp=$(date -d "@${exp}" +%s)
current_timestamp=$(date +%s)
days_left=$(( (exp_timestamp - current_timestamp + 86399) / 86400 ))
if [[ $days_left -lt 0 ]]; then
days_left=0
fi
limit_quota=5
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
sed -i '/#vlessws$/a\### '"$user $expired_date VlessWS-TLS "'\
,{"id": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/config.json
sed -i '/#vlessWS$/a\### '"$user $expired_date VlessWS-NTLS "'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/none.json
vlesslink1="vless://${uuid}@${domain}:$tls?path=${pathku}&security=tls&encryption=none&type=ws#${user}"
vlesslink2="vless://${uuid}@${domain}:$none?path=${pathku}&encryption=none&type=ws#${user}"

# Hapus pesan sebelumnya jika ada
if [ -f /tmp/message_id_vless.txt ]; then
    OLD_MESSAGE_ID=$(cat /tmp/message_id_vless.txt)
    DELETE_RESULT=$(curl -s -X POST https://api.telegram.org/bot${apibot}/deleteMessage \
     -F chat_id="${chatid}" -F message_id="${OLD_MESSAGE_ID}")
    
    # If delete message fails, print error and continue
    if [[ "$DELETE_RESULT" == *"error_code"* ]]; then
        echo "Failed to delete previous message. Continuing to send new message."
    fi
fi

MESSAGE_ID=$(curl -s -X POST https://api.telegram.org/bot${apibot}/sendMessage \
 -F chat_id="${chatid}" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
━━━━━━━━━━━━━━━━━━━━━━
⚡️ Detail Akun Trial VLESS WS ⚡️
━━━━━━━━━━━━━━━━━━━━━━
Server :  ${domain}
Username : ${user}
UUID : ${uuid}
Quota : ${limit_quota}GB
Expired : $expired_date ($days_left days)
━━━━━━━━━━━━━━━━━━━━━━
Port TLS : $tls
Port HTTP : $none
Path : ${pathku}
━━━━━━━━━━━━━━━━━━━━━━
Link TLS : ${vlesslink1}
━━━━━━━━━━━━━━━━━━━━━━
Link HTTP : ${vlesslink2}
━━━━━━━━━━━━━━━━━━━━━━\`\`\`" | jq -r '.result.message_id')

# Simpan ID pesan baru ke file
echo "${MESSAGE_ID}" > /tmp/message_id_vless.txt

INIKEEMPAT
}

INIKEEMPAT () {
MYIP=$(curl -s ipinfo.io/ip)
if [ -z "$MYIP" ]; then
MYIP=$(curl -s http://ip-api.com/json | jq .query | tr -d '"')
fi
if [ -z "$MYIP" ]; then
MYIP=$(curl -s ipinfo.io | jq .ip | tr -d '"')
fi
DOMAIN=$(cat /etc/xray/domain);
pathku=$(cat /etc/xray/path/vmess_ws_path)
source /var/lib/premium-script/ipvps.conf
tls="$(cat ~/log-install.txt | grep -w "TLS" | cut -d: -f2|sed 's/ //g')"
none="$(cat ~/log-install.txt | grep -w "VMNONE" | cut -d: -f2|sed 's/ //g')"
user=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
		CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
			echo ""
			echo -e "A client with the specified name $Login was already created, please choose another name."
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
expired_date=`date -d "+1 days" +"%Y-%m-%d"`
exp=`date -d "+1 days" +%s`
detail_exp=$(date -d "@${exp}" "+%Y-%m-%d %H:%M:%S %Z")
exp_timestamp=$(date -d "@${exp}" +%s)
current_timestamp=$(date +%s)
days_left=$(( (exp_timestamp - current_timestamp + 86399) / 86400 ))
if [[ $days_left -lt 0 ]]; then
days_left=0
fi
limit_quota=5
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
sed -i '/#vmessws$/a\### '"$user $expired_date VmessWS-TLS "'\
,{"id": "'""$uuid""'","level": '"0"',"email": "'""$user""'"}' /usr/local/etc/xray/config.json
sed -i '/#vmessWS$/a\### '"$user $expired_date VmessWS-NTLS "'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user""'"' /usr/local/etc/xray/none.json
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
      "host": "",
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
      "host": "",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
vmesslink1="vmess://$(base64 -w 0 /etc/xray/vmess/$user-tls.json)"
vmesslink2="vmess://$(base64 -w 0 /etc/xray/vmess/$user-none.json)"

# Hapus pesan sebelumnya jika ada
if [ -f /tmp/message_id_vmess.txt ]; then
    OLD_MESSAGE_ID=$(cat /tmp/message_id_vmess.txt)
    DELETE_RESULT=$(curl -s -X POST https://api.telegram.org/bot${apibot}/deleteMessage \
     -F chat_id="${chatid}" -F message_id="${OLD_MESSAGE_ID}")
    
    # If delete message fails, print error and continue
    if [[ "$DELETE_RESULT" == *"error_code"* ]]; then
        echo "Failed to delete previous message. Continuing to send new message."
    fi
fi

MESSAGE_ID=$(curl -s -X POST https://api.telegram.org/bot${apibot}/sendMessage \
 -F chat_id="${chatid}" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
━━━━━━━━━━━━━━━━━━━━━━
⚡️ Detail Akun Trial VMESS WS ⚡️
━━━━━━━━━━━━━━━━━━━━━━
Server : ${domain}
Username : ${user}
UUID : ${uuid}
Quota : ${limit_quota}GB
Expired : $expired_date ($days_left days)
━━━━━━━━━━━━━━━━━━━━━━
Port TLS : $tls
Port HTTP : $none
Path : ${pathku}
━━━━━━━━━━━━━━━━━━━━━━
Link TLS : ${vmesslink1}
━━━━━━━━━━━━━━━━━━━━━━
Link HTTP : ${vmesslink2}
━━━━━━━━━━━━━━━━━━━━━━\`\`\`" | jq -r '.result.message_id')

# Simpan ID pesan baru ke file
echo "${MESSAGE_ID}" > /tmp/message_id_vmess.txt

rm -rf /tmp/log
}
INIPERTAMA
clear
sleep 5
systemctl restart xray
systemctl restart xray@none
/etc/init.d/cron restart
