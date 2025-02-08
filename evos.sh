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

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
KEY=$(cat /etc/william/profile/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/chatid 2>/dev/null)
if [[ -z $KEY || -z $CHATID ]]; then
echo "Please Fill API BOT & CHAT ID First !!"
exit
fi
if ! grep -q -w "ban-xray" /etc/crontab; then
echo -e "*/5 * * * * root ban-xray" >> /etc/crontab
/etc/init.d/cron restart
fi
if ! grep -q -w "ban-ssh" /etc/crontab; then
echo -e "*/3 * * * * root ban-ssh" >> /etc/crontab
/etc/init.d/cron restart
fi
domain=$(cat /etc/xray/domain)

# date
date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

# ambil user vmess-ws-tls
data_vmess_tls=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vmess-ws" | awk {'print $2'} | sort -u)

for useractive in $data_vmess_tls; do
    ip_limit_vmessws=$(cat /etc/william/limit-xray/vmessws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access.log; then
        ip_list=$(cat /var/log/xray/access.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)

        if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-tls/${useractive} && -e /etc/xray/usage-downlink-tls/${useractive} ]]; then
                byt1_vmesswstls=$(cat /etc/xray/usage-downlink-tls/${useractive})
                byt2_vmesswstls=$(cat /etc/xray/usage-uplink-tls/${useractive})
                sum_vmesswstls=$((byt1_vmesswstls + byt2_vmesswstls))

                if (( sum_vmesswstls >= 1024*1024*1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024/1024/1024" | bc)
                    size_unit_vmesswstls="TB"
                elif (( sum_vmesswstls >= 1024*1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024/1024" | bc)
                    size_unit_vmesswstls="GB"
                elif (( sum_vmesswstls >= 1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024" | bc)
                    size_unit_vmesswstls="MB"
                else
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024" | bc)
                    size_unit_vmesswstls="KB"
                fi
            else
                size_in_gb_vmesswstls=""
                size_unit_vmesswstls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User VMESS TLS Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG VMESS WS
            if [[ $cek_mulog -gt $ip_limit_vmessws && $ip_limit_vmessws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_vmessws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vmessws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_vmessws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN VMESS WS</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_vmessws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_vmesswstls $size_unit_vmesswstls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                    systemctl restart xray@none
                fi
            fi
        fi
    fi
done
# ambil user vmess-ws-tls argo
data_vmess_argo=$(cat /var/log/xray/access3.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "argo-vmessws" | awk {'print $2'} | sort -u)

for useractive in $data_vmess_argo; do
    ip_limit_vmessws=$(cat /etc/william/limit-xray/vmessws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access3.log; then
        ip_list=$(cat /var/log/xray/access3.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)

        if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-tls/${useractive} && -e /etc/xray/usage-downlink-tls/${useractive} ]]; then
                byt1_vmesswstls=$(cat /etc/xray/usage-downlink-tls/${useractive})
                byt2_vmesswstls=$(cat /etc/xray/usage-uplink-tls/${useractive})
                sum_vmesswstls=$((byt1_vmesswstls + byt2_vmesswstls))

                if (( sum_vmesswstls >= 1024*1024*1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024/1024/1024" | bc)
                    size_unit_vmesswstls="TB"
                elif (( sum_vmesswstls >= 1024*1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024/1024" | bc)
                    size_unit_vmesswstls="GB"
                elif (( sum_vmesswstls >= 1024*1024 )); then
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024/1024" | bc)
                    size_unit_vmesswstls="MB"
                else
                    size_in_gb_vmesswstls=$(echo "scale=2; $sum_vmesswstls/1024" | bc)
                    size_unit_vmesswstls="KB"
                fi
            else
                size_in_gb_vmesswstls=""
                size_unit_vmesswstls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User VMESS ARGO Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG VMESS WS
            if [[ $cek_mulog -gt $ip_limit_vmessws && $ip_limit_vmessws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_vmessws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vmessws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vmessws ,/' /etc/cf-argo/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_vmessws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN VMESS WS ARGO</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_vmessws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_vmesswstls $size_unit_vmesswstls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                    systemctl restart xray@none
                    systemctl restart argo-xray
                fi
            fi
        fi
    fi
done
# ambil user vmess-ws-ntls
data_vmess_ntls=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vmess-ws" | awk {'print $2'} | sort -u)
for useractive in $data_vmess_ntls; do
    ip_limit_vmessws=$(cat /etc/william/limit-xray/vmessws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access2.log; then
        ip_list=$(cat /var/log/xray/access2.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)
        
            if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-ntls/${useractive} && -e /etc/xray/usage-downlink-ntls/${useractive} ]]; then
                byt1_vmesswsntls=$(cat /etc/xray/usage-downlink-ntls/${useractive})
                byt2_vmesswsntls=$(cat /etc/xray/usage-uplink-ntls/${useractive})
                sum_vmesswsntls=$((byt1_vmesswsntls + byt2_vmesswsntls))

                if (( sum_vmesswsntls >= 1024*1024*1024*1024 )); then
                    size_in_gb_vmesswsntls=$(echo "scale=2; $sum_vmesswsntls/1024/1024/1024/1024" | bc)
                    size_unit_vmesswsntls="TB"
                elif (( sum_vmesswsntls >= 1024*1024*1024 )); then
                    size_in_gb_vmesswsntls=$(echo "scale=2; $sum_vmesswsntls/1024/1024/1024" | bc)
                    size_unit_vmesswsntls="GB"
                elif (( sum_vmesswsntls >= 1024*1024 )); then
                    size_in_gb_vmesswsntls=$(echo "scale=2; $sum_vmesswsntls/1024/1024" | bc)
                    size_unit_vmesswsntls="MB"
                else
                    size_in_gb_vmesswsntls=$(echo "scale=2; $sum_vmesswsntls/1024" | bc)
                    size_unit_vmesswsntls="KB"
                fi
            else
                size_in_gb_vmesswsntls=""
                size_unit_vmesswsntls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User VMESS NTLS Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG VMESS WS
            if [[ $cek_mulog -gt $ip_limit_vmessws && $ip_limit_vmessws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_vmessws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vmessws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_vmessws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN VMESS WS</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_vmessws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_vmesswsntls $size_unit_vmesswsntls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                    systemctl restart xray@none
                fi
            fi
        fi
    fi
done
# date
date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

# ambil user vless-ws-tls
data_vless_tls=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vless-ws" | awk {'print $2'} | sort -u)

for useractive in $data_vless_tls; do
    ip_limit_vlessws=$(cat /etc/william/limit-xray/vlessws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access.log; then
        ip_list=$(cat /var/log/xray/access.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)

        if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-tls/${useractive} && -e /etc/xray/usage-downlink-tls/${useractive} ]]; then
                byt1_vlesswstls=$(cat /etc/xray/usage-downlink-tls/${useractive})
                byt2_vlesswstls=$(cat /etc/xray/usage-uplink-tls/${useractive})
                sum_vlesswstls=$((byt1_vlesswstls + byt2_vlesswstls))

                if (( sum_vlesswstls >= 1024*1024*1024*1024 )); then
                    size_in_gb_vlesswstls=$(echo "scale=2; $sum_vlesswstls/1024/1024/1024/1024" | bc)
                    size_unit_vlesswstls="TB"
                elif (( sum_vlesswstls >= 1024*1024*1024 )); then
                    size_in_gb_vlesswstls=$(echo "scale=2; $sum_vlesswstls/1024/1024/1024" | bc)
                    size_unit_vlesswstls="GB"
                elif (( sum_vlesswstls >= 1024*1024 )); then
                    size_in_gb_vlesswstls=$(echo "scale=2; $sum_vlesswstls/1024/1024" | bc)
                    size_unit_vlesswstls="MB"
                else
                    size_in_gb_vlesswstls=$(echo "scale=2; $sum_vlesswstls/1024" | bc)
                    size_unit_vlesswstls="KB"
                fi
            else
                size_in_gb_vlesswstls=""
                size_unit_vlesswstls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User vless TLS Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG VLESS WS
            if [[ $cek_mulog -gt $ip_limit_vlessws && $ip_limit_vlessws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_vlessws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vlessws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_vlessws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN VLESS WS</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_vlessws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_vlesswstls $size_unit_vlesswstls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                    systemctl restart xray@none
                fi
            fi
        fi
    fi
done
# ambil user vless-ws-ntls
data_vless_ntls=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vless-ws" | awk {'print $2'} | sort -u)
for useractive in $data_vless_ntls; do
    ip_limit_vlessws=$(cat /etc/william/limit-xray/vlessws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access2.log; then
        ip_list=$(cat /var/log/xray/access2.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)
        
            if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-ntls/${useractive} && -e /etc/xray/usage-downlink-ntls/${useractive} ]]; then
                byt1_vlesswsntls=$(cat /etc/xray/usage-downlink-ntls/${useractive})
                byt2_vlesswsntls=$(cat /etc/xray/usage-uplink-ntls/${useractive})
                sum_vlesswsntls=$((byt1_vlesswsntls + byt2_vlesswsntls))

                if (( sum_vlesswsntls >= 1024*1024*1024*1024 )); then
                    size_in_gb_vlesswsntls=$(echo "scale=2; $sum_vlesswsntls/1024/1024/1024/1024" | bc)
                    size_unit_vlesswsntls="TB"
                elif (( sum_vlesswsntls >= 1024*1024*1024 )); then
                    size_in_gb_vlesswsntls=$(echo "scale=2; $sum_vlesswsntls/1024/1024/1024" | bc)
                    size_unit_vlesswsntls="GB"
                elif (( sum_vlesswsntls >= 1024*1024 )); then
                    size_in_gb_vlesswsntls=$(echo "scale=2; $sum_vlesswsntls/1024/1024" | bc)
                    size_unit_vlesswsntls="MB"
                else
                    size_in_gb_vlesswsntls=$(echo "scale=2; $sum_vlesswsntls/1024" | bc)
                    size_unit_vlesswsntls="KB"
                fi
            else
                size_in_gb_vlesswsntls=""
                size_unit_vlesswsntls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User vless NTLS Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG vless WS
            if [[ $cek_mulog -gt $ip_limit_vlessws && $ip_limit_vlessws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_vlessws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_vlessws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_vlessws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN VLESS WS</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_vlessws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_vlesswsntls $size_unit_vlesswsntls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                    systemctl restart xray@none
                fi
            fi
        fi
    fi
done
# date
date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

# ambil user trojan-ws-tls
data_trojan_tls=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "trojan-ws" | awk {'print $2'} | sort -u)

for useractive in $data_trojan_tls; do
    ip_limit_trojanws=$(cat /etc/william/limit-xray/trojanws/$useractive 2>/dev/null)
    date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

    if grep -q -w "${useractive}" /var/log/xray/access.log; then
        ip_list=$(cat /var/log/xray/access.log | grep -w "$useractive" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        cek_mulog=$(echo -e "$ip_list" | wc -l)

        if [ -n "$ip_list" ]; then
            if [[ -e /etc/xray/usage-uplink-tls/${useractive} && -e /etc/xray/usage-downlink-tls/${useractive} ]]; then
                byt1_trojanwstls=$(cat /etc/xray/usage-downlink-tls/${useractive})
                byt2_trojanwstls=$(cat /etc/xray/usage-uplink-tls/${useractive})
                sum_trojanwstls=$((byt1_trojanwstls + byt2_trojanwstls))

                if (( sum_trojanwstls >= 1024*1024*1024*1024 )); then
                    size_in_gb_trojanwstls=$(echo "scale=2; $sum_trojanwstls/1024/1024/1024/1024" | bc)
                    size_unit_trojanwstls="TB"
                elif (( sum_trojanwstls >= 1024*1024*1024 )); then
                    size_in_gb_trojanwstls=$(echo "scale=2; $sum_trojanwstls/1024/1024/1024" | bc)
                    size_unit_trojanwstls="GB"
                elif (( sum_trojanwstls >= 1024*1024 )); then
                    size_in_gb_trojanwstls=$(echo "scale=2; $sum_trojanwstls/1024/1024" | bc)
                    size_unit_trojanwstls="MB"
                else
                    size_in_gb_trojanwstls=$(echo "scale=2; $sum_trojanwstls/1024" | bc)
                    size_unit_trojanwstls="KB"
                fi
            else
                size_in_gb_trojanwstls=""
                size_unit_trojanwstls=""
            fi

            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "━━━━━━━━[Monitoring User TROJAN TLS Login]━━━━━━━"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "USERNAME : $useractive"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$ip_list"
            echo -e "${cyan}-------------------------------------------${NC}"
            echo -e "$cek_mulog"
            echo -e "${cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo ""

            # MULOG trojan WS
            if [[ $cek_mulog -gt $ip_limit_trojanws && $ip_limit_trojanws -ne 0 ]]; then
                ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$useractive" | awk '{print $1}' | grep -w "#banned_trojanws" | wc -l)
                if [[ "$ngecek_banned" = "1" ]]; then
                    echo -e "user already banned"
                else
                    sed -i '/"email": "'"$useractive"'"/s/,/#banned_trojanws ,/' /usr/local/etc/xray/config.json
                    sed -i '/"email": "'"$useractive"'"/s/},/#banned_trojanws },/' /usr/local/etc/xray/none.json

                    TIME="10"
                    URL="https://api.telegram.org/bot$KEY/sendMessage"
                    TEXT="
<b>━━━━━━━━━━━━━━━━━━</b>
<b>MULTI LOGIN TROJAN WS</b>
<b>━━━━━━━━━━━━━━━━━━</b>
<b>Username: </b><code>$useractive</code>
<b>Domain: </b><code>$domain</code>
<b>Limit IP: </b><code>$ip_limit_trojanws</code>
<b>Multi Login IP: </b><code>$cek_mulog</code>
<b>Quota Usage: </b><code>$size_in_gb_trojanwstls $size_unit_trojanwstls</code>
<b>Action: </b><code>BANNED</code>
<b>-----------------LOGS-----------------</b>
$ip_list
<b>-----------------------------------------</b>
<b>info : time on » ip » access</b>
<b>━━━━━━━━━━━━━━━━━━</b>
"
                    curl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
                    systemctl restart xray
                fi
            fi
        fi
    fi
done