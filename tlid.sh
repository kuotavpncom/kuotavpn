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

echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "CHANGE OR ADD NEW LIMIT QUOTA USER"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " [1]. VMESS WS"
echo -e " [2]. VLESS WS"
echo -e " [3]. TROJAN WS"
echo -e " [x]. EXIT"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p " Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
echo ""
protocol=$(grep -E -w "VmessWS-TLS" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 4-4 | head -1)
if [[ $protocol = "VmessWS-TLS" ]];
then
echo "found"
else
echo "You have no existing clients!"
exit 1
fi
NUMBER_OF_CLIENTS=$(grep -c -E "$protocol " "/usr/local/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi
	clear
	echo ""
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo " Select User Please :)"
	echo " Press CTRL+C to return"
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo "     No User  Expired  Protocol"
	grep -E -w "$protocol " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E -w "$protocol" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
if [[ -z "$limit_quota" || "$limit_quota" == "0" ]]; then
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
else
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user"
echo -e "Current Limit Quota : $size_limit_quota GB"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
fi
;;
2)
echo ""
protocol=$(grep -E -w "VlessWS-TLS" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 4-4 | head -1)
if [[ $protocol = "VlessWS-TLS" ]];
then
echo "found"
else
echo "You have no existing clients!"
exit 1
fi
NUMBER_OF_CLIENTS=$(grep -c -E "$protocol " "/usr/local/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi
	clear
	echo ""
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo " Select User Please :)"
	echo " Press CTRL+C to return"
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo "     No User  Expired  Protocol"
	grep -E -w "$protocol " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E -w "$protocol" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
if [[ -z "$limit_quota" || "$limit_quota" == "0" ]]; then
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
else
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user"
echo -e "Current Limit Quota : $size_limit_quota GB"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
fi
;;
3)
echo ""
protocol=$(grep -E -w "TrojanWS" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 4-4 | head -1)
if [[ $protocol = "TrojanWS" ]];
then
echo "found"
else
echo "You have no existing clients!"
exit 1
fi
NUMBER_OF_CLIENTS=$(grep -c -E "$protocol " "/usr/local/etc/xray/config.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi
	clear
	echo ""
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo " Select User Please :)"
	echo " Press CTRL+C to return"
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	echo "     No User  Expired  Protocol"
	grep -E -w "$protocol " "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E -w "$protocol" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
if [[ -z "$limit_quota" || "$limit_quota" == "0" ]]; then
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Add Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
else
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user"
echo -e "Current Limit Quota : $size_limit_quota GB"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Limit Quota User (GB) {0 = no limit}: " limit_quota
while ! [[ "$limit_quota" =~ ^[0-9]+$ ]]; do
  echo "Input tidak valid! masukkan angka saja."
  read -p "Limit Quota User (GB): " limit_quota
done
quota=$(echo "scale=0; $limit_quota*1024*1024*1024 / 1" | bc)
mkdir -p /etc/william/limit-quota/
echo "$quota" > "/etc/william/limit-quota/$user"
echo ""
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Change Limit Quota User For : $user ${green}Success !!${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac