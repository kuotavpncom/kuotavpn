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

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(grep -c -E "^## BEGIN_Sendall" /etc/crontab)
if [[ "$cek" = "1" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
touch /home/chatid3
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  » Auto Send Trial Account Via Telegram Bot «"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " Status Autosend Trial Via Bot Is $sts"
echo -e "   [1]  Auto Send Account"
echo -e "   [2]  Change Api Bot & Chat ID"
echo -e "   [3]  Stop Autosend Account"
echo -e "   [x]  Kembali Ke Menu"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
ips=$(wget -qO- ipinfo.io/ip);
domain=$(cat /etc/xray/domain)
chatid=$(cat /home/chatid3 2>/dev/null)
apibot=$(cat /home/apibot3 2>/dev/null)
if [[ "$chatid" = "" ]]; then
echo "Please Enter Your Chat ID Group"
read -rp "Chat ID: " -e chatid
cat > "/home/chatid3" << EOF
$chatid
EOF
fi
if [[ "$apibot" = "" ]]; then
echo "Please Enter Your Api Bot"
echo "Get Api Bot From @BotFather"
echo "Dont Forget To Added Your Bot To Your Group"
read -rp "Api Bot: " -e apibot
cat > "/home/apibot3" << EOF
$apibot
EOF
fi
cek=$(grep -c -E "^## BEGIN_Sendall" /etc/crontab)
if [[ "$cek" = "0" ]]; then
echo "Want To Make Bot Will Auto Send Account ?"
echo "Account Will Be Send Automatically at 03:00 GMT +7 To Your Telegram Group"
read -p "Type Yes If Agree [yes/no]: " pilihan
	if [[ "$pilihan" = 'yes' ]]; then
cat << EOF >> /etc/crontab
## BEGIN_Sendall
0 3 * * * root auto-sendall
## END_Sendall
EOF
service cron restart
sleep 1
echo " Please Wait"
clear
echo " Autobackup Has Been Started"
echo " Account Will Be Send Automatically at 03:00 GMT +7"
else
echo "oke maybe next time..."
fi
auto-sendall
clear
echo "done, please cek your group telegram"
fi
;;
2)
FILE=/home/apibot3
if test -f "$FILE"; then
read -rp "Type Your New Api Bot: " -e apibot
cat > "/home/apibot3" << EOF
$apibot
EOF
read -rp "Type Your New Chat ID Group: " -e chatid
cat > "/home/chatid3" << EOF
$chatid
EOF
clear
echo "Succesfully Changed Api Bot & Chat ID Succesfully"
else
    echo "Api Bot & Chat ID Not Found, So Cannot To Change"
    exit 1
fi
service cron restart
;;
3)
sed -i "/^## BEGIN_Sendall/,/^## END_Sendall/d" /etc/crontab
clear
echo "Succesfully Stop AutoSend Account VPN"
service cron restart
;;
x)
clear
menu2
;;
*)
echo "Please enter an correct number"
;;
esac

