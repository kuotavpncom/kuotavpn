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

# date
touch /var/log/xray/access3.log
date_1minute=$(date -R -d "1 minute ago" | awk '{print $5}' | cut -d: -f 1-2)

# Function to process logs
process_log() {
    local log_file=$1
    local uplink_dir=$2
    local downlink_dir=$3
    local log_type=$4
    DATA_USER=$(cat $log_file | grep -w "accepted" | awk {'print $11'} | sort -u | sed '/^$/d')
    if [ -z "$DATA_USER" ]; then
        echo ""
        echo -e "No User Login Detect for $log_type [!]"
        echo ""
        return
    fi
    for user in $DATA_USER; do
        PROTOCOL=$(cat $log_file | grep -w "$user" | awk '!/proxy\/vmess\/encoding/ && !/8\.8\.8\.8/ && !/127\.0\.0\.1/ {print $7}' | tr -d '[' | tr -d ']' | sort -u | sed '/^email:/d')
        if [[ -z "$PROTOCOL" ]]; then
        continue
        fi
            echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo -e "[User Login Xray - $log_type]"
            echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        DATA_FILE_UP="${uplink_dir}/${user}"
        DATA_FILE_DOWN="${downlink_dir}/${user}"
        TIME_SRCIP_DSTIP=$(cat $log_file | grep -w "$user" | awk '!/proxy\/vmess\/encoding/ && !/127\.0\.0\.1/ && !/8\.8\.8\.8/ && !/8\.8\.4\.4/ && !/1\.1\.1\.1/ && !/1\.0\.1\.0/ {print $2, $4, $8, $6}' | grep -w "^${date_1minute}" | grep -w ">>" | awk {'print $1, $2, $4'} | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | awk '{gsub(/:0$/, "", $2); print}' | awk 'NR==2 {gsub(/tcp:/, "", $0)} {print}' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | tr -d '[' | tr -d ']' | sed 's/tcp://' | sed 's/udp://' | awk '{ last[$2] = $0 } END { for (key in last) print last[key] }' | sort -u | awk {'print $1, $2, $3'} | sed 's/ / » /g')
        IP_Login=$(echo -e "$TIME_SRCIP_DSTIP" | wc -l)
        if [[ -e $DATA_FILE_UP ]]; then
            byt2_xray=$(cat $DATA_FILE_UP)
            if (( byt2_xray >= 1024*1024*1024*1024 )); then
                size_in_gb_uplink_xray=$(echo "scale=2; $byt2_xray/1024/1024/1024/1024" | bc)
                size_unit_uplink_xray="TB"
            elif (( byt2_xray >= 1024*1024*1024 )); then
                size_in_gb_uplink_xray=$(echo "scale=2; $byt2_xray/1024/1024/1024" | bc)
                size_unit_uplink_xray="GB"
            elif (( byt2_xray >= 1024*1024 )); then
                size_in_gb_uplink_xray=$(echo "scale=2; $byt2_xray/1024/1024" | bc)
                size_unit_uplink_xray="MB"
            else
                size_in_gb_uplink_xray=$(echo "scale=2; $byt2_xray/1024" | bc)
                size_unit_uplink_xray="KB"
            fi
        else
            size_in_gb_uplink_xray=""
            size_unit_uplink_xray=""
        fi
        if [[ -e $DATA_FILE_DOWN ]]; then
            byt1_xray=$(cat $DATA_FILE_DOWN)
            if (( byt1_xray >= 1024*1024*1024*1024 )); then
                size_in_gb_downlink_xray=$(echo "scale=2; $byt1_xray/1024/1024/1024/1024" | bc)
                size_unit_downlink_xray="TB"
            elif (( byt1_xray >= 1024*1024*1024 )); then
                size_in_gb_downlink_xray=$(echo "scale=2; $byt1_xray/1024/1024/1024" | bc)
                size_unit_downlink_xray="GB"
            elif (( byt1_xray >= 1024*1024 )); then
                size_in_gb_downlink_xray=$(echo "scale=2; $byt1_xray/1024/1024" | bc)
                size_unit_downlink_xray="MB"
            else
                size_in_gb_downlink_xray=$(echo "scale=2; $byt1_xray/1024" | bc)
                size_unit_downlink_xray="KB"
            fi
        else
            size_in_gb_downlink_xray=""
            size_unit_downlink_xray=""
        fi
        if [[ -n $size_in_gb_uplink_xray && -n $size_in_gb_downlink_xray ]]; then
            total_xray=$(echo "$byt1_xray + $byt2_xray" | bc)
            if (( total_xray >= 1024*1024*1024*1024 )); then
                size_in_gb_total_xray=$(echo "scale=2; $total_xray/1024/1024/1024/1024" | bc)
                size_unit_total_xray="TB"
            elif (( total_xray >= 1024*1024*1024 )); then
                size_in_gb_total_xray=$(echo "scale=2; $total_xray/1024/1024/1024" | bc)
                size_unit_total_xray="GB"
            elif (( total_xray >= 1024*1024 )); then
                size_in_gb_total_xray=$(echo "scale=2; $total_xray/1024/1024" | bc)
                size_unit_total_xray="MB"
            else
                size_in_gb_total_xray=$(echo "scale=2; $total_xray/1024" | bc)
                size_unit_total_xray="KB"
            fi
        else
            size_in_gb_total_xray=""
            size_unit_total_xray=""
        fi

        echo -e "User: $user"
        if [[ "$PROTOCOL" == "vmess-ws" || "$PROTOCOL" == "vless-ws" || "$PROTOCOL" == "trojan-ws" ]]; then
        limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
        if [[ -n "$limit_quota" ]]; then
        size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
        echo -e "Protocol: $PROTOCOL"
        echo -e "Limit Quota: $size_limit_quota GB"
        else
        echo -e "Protocol: $PROTOCOL"
        echo -e "Limit Quota: No Limit"
        fi
        else
        echo -e "Protocol: $PROTOCOL"
        fi
        echo -e "UPlink: $size_in_gb_uplink_xray $size_unit_uplink_xray"
        echo -e "DOWNlink: $size_in_gb_downlink_xray $size_unit_downlink_xray"
        echo -e "TOTAL: $size_in_gb_total_xray $size_unit_total_xray"
        echo -e "IP Login: $IP_Login"
        echo "-----------------------------------------------"
        echo " TIME   |      SRC_IP     |      DST_IP"
        echo "-----------------------------------------------"
        while read -r line; do
            echo "$line"
        echo "-----------------------------------------------"
        done <<< "$TIME_SRCIP_DSTIP"
        echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo -e ""
    done
}

# Contoh pemanggilan untuk TLS
process_log "/var/log/xray/access.log" "/etc/xray/usage-uplink-tls" "/etc/xray/usage-downlink-tls" "TLS"

# Contoh pemanggilan untuk nTLS
process_log "/var/log/xray/access2.log" "/etc/xray/usage-uplink-ntls" "/etc/xray/usage-downlink-ntls" "nTLS"

# Contoh pemanggilan untuk ARGO
process_log "/var/log/xray/access3.log" "/etc/xray/usage-uplink-tls" "/etc/xray/usage-downlink-tls" "ARGO"
