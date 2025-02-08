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

mkdir -p /etc/william/profile/
mkdir -p /etc/william/limit-ssh/
mkdir -p /etc/william/limit-xray/vmessws/
mkdir -p /etc/william/limit-xray/vlessws/
mkdir -p /etc/william/limit-xray/trojanws/
KEY=$(cat /etc/william/profile/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/chatid 2>/dev/null)
echo -e "========================"
echo -e "AKTIVATE LIMIT IP XRAY & SSH"
echo -e "========================"
echo -e "limit xray only support:"
echo -e "- vmess ws"
echo -e "- vless ws"
echo -e "- trojan ws"
echo -e "--------------------------"
echo -e "limit ssh only support:"
echo -e "- ssh direct"
echo -e "- ssh stunnel"
echo -e "- ssh dropbear"
echo -e "- ssh ws ssl"
echo -e "- ssh ws"
echo -e "========================"
if [[ -n $KEY || -n $CHATID ]]; then
echo -e "STATUS LIMIT IP (${green}ON !${NC})"
echo -e "========================"
echo -e " [1] Change API BOT TELEGRAM"
echo -e " [2] Change CHAT ID TELEGRAM"
echo -e " [3] Stop Limit IP Xray & SSH"
echo -e " [x] EXIT"
echo -e ""
read -p " Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "CHANGE API BOT TELEGRAM : " apibot
if [[ -z $apibot ]]; then
echo "Please Input API BOT TELEGRAM !"
exit
fi
echo -e "$apibot" > /etc/william/profile/key
echo "CHANGE API BOT SUCCESS"
if ! grep -q -w "ban-xray" /etc/crontab; then
echo -e "*/20 * * * * root ban-xray" >> /etc/crontab
/etc/init.d/cron restart
fi
if ! grep -q -w "ban-ssh" /etc/crontab; then
echo -e "*/3 * * * * root ban-ssh" >> /etc/crontab
/etc/init.d/cron restart
fi
;;
2)
read -p "CHAT ID TELEGRAM : " chatid
if [[ -z $chatid ]]; then
echo "Please Input CHAT ID TELEGRAM !"
exit
fi
echo -e "$chatid" > /etc/william/profile/chatid
echo "CHANGE CHAT ID TELEGRAM SUCCESS"
if ! grep -q -w "ban-xray" /etc/crontab; then
echo -e "*/20 * * * * root ban-xray" >> /etc/crontab
/etc/init.d/cron restart
fi
if ! grep -q -w "ban-ssh" /etc/crontab; then
echo -e "*/3 * * * * root ban-ssh" >> /etc/crontab
/etc/init.d/cron restart
fi
;;
3)
read -p " Are You Sure ? [yes/no] :  " answer
if [ "$answer" == "y" ] || [ "$answer" == "ya" ] || [ "$answer" == "yes" ]; then
sed -i "/ban-ssh/d" /etc/crontab
sed -i "/ban-xray/d" /etc/crontab
/etc/init.d/cron restart
rm -rf /etc/william/profile/*
echo -e "Success Stop Limit IP"
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
else
echo -e "STATUS LIMIT IP (${red}OFF !${NC})"
echo -e ""
read -p "API BOT TELEGRAM : " apibot
if [[ -z $apibot ]]; then
echo "PLEASE INPUT API BOT TELEGRAM !"
exit
fi
echo -e "$apibot" > /etc/william/profile/key
echo "INPUT API BOT SUCCESS"
echo ""
read -p "CHAT ID TELEGRAM : " chatid
if [[ -z $chatid ]]; then
echo "PLEASE INPUT CHAT ID TELEGRAM !"
exit
fi
echo -e "$chatid" > /etc/william/profile/chatid
echo "INPUT CHAT ID TELEGRAM SUCCESS"
echo ""
if ! grep -q -w "ban-xray" /etc/crontab; then
echo -e "*/20 * * * * root ban-xray" >> /etc/crontab
/etc/init.d/cron restart
fi
if ! grep -q -w "ban-ssh" /etc/crontab; then
echo -e "*/3 * * * * root ban-ssh" >> /etc/crontab
/etc/init.d/cron restart
fi
clear
echo -e "SUCCESS AKTIVATE LIMIT IP !"
fi
