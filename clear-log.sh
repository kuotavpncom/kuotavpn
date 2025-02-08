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
curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/logs.txt
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

source /etc/os-release
VERSI=$VERSION_ID
if [[ $VERSI == '9' ]]; then
echo > /var/log/cloud-init.log
echo > /var/log/landscape/sysinfo.log
echo > /var/log/apt/term.log
echo > /var/log/apt/history.log
echo > /var/log/dpkg.log
echo > /var/log/nginx/error.log
echo > /var/log/nginx/vps-access.log
echo > /var/log/nginx/vps-error.log
echo > /var/log/nginx/access.log
echo > /var/log/ubuntu-advantage-timer.log
echo > /var/log/kern.log
echo > /var/log/cloud-init-output.log
echo > /var/log/fail2ban.log
echo > /var/log/squid/cache.log
echo > /var/log/squid/access.log
echo > /var/log/unattended-upgrades/unattended-upgrades.log
echo > /var/log/unattended-upgrades/unattended-upgrades-shutdown.log
echo > /var/log/unattended-upgrades/unattended-upgrades-dpkg.log
echo > /var/log/alternatives.log
echo > /var/log/accel-ppp/auth-fail.log
echo > /var/log/accel-ppp/accel-ppp.log
echo > /var/log/accel-ppp/emerg.log
echo > /var/log/ubuntu-advantage.log
echo > /var/log/auth.log
echo > /var/log/xray/error2.log
echo > /var/log/xray/error.log
echo > /var/log/xray/access2.log
echo > /var/log/xray/access.log
echo > /var/log/syslog
echo > /var/log/wtmp
echo > /var/log/utmp
echo > /var/log/btmp
echo > /var/log/lastlog
echo > /var/log/error.1
echo > /var/log/error
for CLEAN in $(find /var/log/ -type f)
do
    cp /dev/null  $CLEAN
done
history -c
clear
echo "clear log for debian 9 success"
fi
data=(`find /var/log/ -name *.log`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
data=(`find /var/log/ -name *.err`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
data=(`find /var/log/ -name mail.*`);
for log in "${data[@]}"
do
echo "$log clear"
echo > $log
done
echo > /var/log/syslog
echo > /var/log/btmp
echo > /var/log/messages
echo > /var/log/debug
echo > /var/log/xray/error2.log
echo > /var/log/xray/error.log
echo > /var/log/xray/access2.log
echo > /var/log/xray/access.log
echo > /var/log/wtmp
echo > /var/log/utmp
echo > /var/log/lastlog
history -c
for CLEAN in $(find /var/log/ -type f)
do
    cp /dev/null  $CLEAN
done
echo -e "Clear Log Success"
# numpang code lain
# Mendapatkan informasi dari config
chatid=$(cat /home/chatid3 2>/dev/null)
apibot=$(cat /home/apibot3 2>/dev/null)
chatidv2=$(cat /etc/william/profile/private/chatid 2>/dev/null)
apibotv2=$(cat /etc/william/profile/private/key 2>/dev/null)

info_exp=$(
    (
        grep -E -w "VmessWS-TLS " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "vmessGRPCX " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "vmessupgrade " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "VlessWS-TLS " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "VlessGRPC " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "VlessUPGRADE-TLS " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "VlessXTLS" "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "Trojan " "/usr/local/etc/xray/will69.json"
        grep -E -w "TrojanWS " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "TrojanGRPC " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
        grep -E -w "TrojanUPGRADE-TLS " "/usr/local/etc/xray/config.json" | awk {'print $2, $3, $4'} | cut -d '-' -f1
    )
)

# Mendapatkan timestamp sekarang
current_timestamp=$(date +%s)

# Iterasi setiap baris info_exp
echo "$info_exp" | while read -r user_info; do
    username=$(echo "$user_info" | awk '{print $1}')  # Username
    timestamp=$(echo "$user_info" | awk '{print $2}') # Timestamp
    detail_timestamp=$(date -d "@$timestamp" "+%Y-%m-%d %H:%M:%S %Z")
    protocol=$(echo "$user_info" | awk '{print $3}')  # Protocol

    # Hitung selisih waktu dalam detik
    difference=$((timestamp - current_timestamp))

    # Hitung selisih dalam hari
    days_remaining=$(( (difference + 86399) / 86400 ))

    # Jika selisih 3 hari atau kurang, ingatkan
    if [ "$days_remaining" -le 3 ] && [ "$days_remaining" -ge 0 ]; then
curl -s -X POST https://api.telegram.org/bot$apibot/sendMessage \
 -F chat_id="$chatid" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Akun Expired ❗
━━━━━━━━━━━━━━━━━━━
Username: $username
Protocol: $protocol
Expired on: $days_remaining days left
Detail Expired: $detail_timestamp
━━━━━━━━━━━━━━━━━━━
Segera melakukan perpanjangan akun\`\`\`"
#
curl -s -X POST https://api.telegram.org/bot$apibotv2/sendMessage \
 -F chat_id="$chatidv2" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Akun Expired ❗
━━━━━━━━━━━━━━━━━━━
Username: $username
Protocol: $protocol
Expired on: $days_remaining days left
Detail Expired: $detail_timestamp
━━━━━━━━━━━━━━━━━━━
Segera melakukan perpanjangan akun\`\`\`"
fi
done