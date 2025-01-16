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

# Tampilan menu
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${red}                         [ MAIN MENU ]                         ${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green [•1]  $NC MENU SSH, SLOWDNS & OVPN [${green}menu-ssh${NC}]"
echo -e "$green [•2]  $NC MENU VMESS WS [${green}menu-vmess${NC}]"
echo -e "$green [•3]  $NC MENU VMESS HTTPUPGRADE [${green}menu-vmessupgrade${NC}]"
echo -e "$green [•4]  $NC MENU VMESS GRPC [${green}menu-vmessgrpc${NC}]"
echo -e "$green [•5]  $NC MENU VMESS TCP HTTP [${green}menu-vmesstcp${NC}]"
echo -e "$green [•6]  $NC MENU VLESS WS [${green}menu-vless${NC}]"
echo -e "$green [•7]  $NC MENU VLESS HTTPUPGRADE [${green}menu-vlessupgrade${NC}]"
echo -e "$green [•8]  $NC MENU VLESS GRPC [${green}menu-vlessgrpc${NC}]"
echo -e "$green [•9]  $NC MENU VLESS TCP XTLS [${green}menu-vlessxtls${NC}]"
echo -e "$green [•10] $NC MENU TROJAN WS [${green}menu-trws${NC}]"
echo -e "$green [•11] $NC MENU TROJAN HTTPUPGRADE [${green}menu-trojanupgrade${NC}]"
echo -e "$green [•12] $NC MENU TROJAN TCP [${green}menu-tr${NC}]"
echo -e "$green [•13] $NC MENU TROJAN GRPC [${green}menu-trgrpc${NC}]"
echo -e "$green [•14] $NC MENU L2TP [${green}menu-l2tp${NC}]"
echo -e "$green [•15] $NC MENU BUNDLING [${green}menu-bundling${NC}]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${red}                        [ OTHER MENU ]                         ${NC}"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green [•16] $NC ARGO SETUP FOR SSH & XRAY [${green}argo-setup${NC}]"
echo -e "$green [•17] $NC CONFIGURE BOT MANAGEMENT [${green}config-bot${NC}]"
echo -e "$green [•18] $NC CONFIGURE API DEVELOPMENT [${green}config-api${NC}]"
echo -e "$green [•19] $NC CHANGE DOMAIN OR FORCE DOMAIN [${green}force-host${NC}]"
echo -e "$green [•20] $NC CHANGE SLOWDNS MODE [${green}change-slowdns${NC}]"
echo -e "$green [•21] $NC CHANGE PORT [${green}change-port${NC}]"
echo -e "$green [•22] $NC CHANGE UUID OR PASSWORD ACCOUNT VPN [XRAY] [${green}change-uuid${NC}]"
echo -e "$green [•23] $NC CHANGE ALTERNATIF PORT [${green}change-alt-port${NC}]"
echo -e "$green [•24] $NC AUTOBACKUP VIA BOT TELEGRAM [${green}backup-bot${NC}]"
echo -e "$green [•25] $NC AUTOSEND CREATED VPN VIA BOT TELEGRAM [${green}auto-sendcreated${NC}]"
echo -e "$green [•26] $NC AUTOSEND TRIAL VPN VIA BOT TELEGRAM [${green}auto-sendtrial${NC}]"
echo -e "$green [•27] $NC BACKUP VIA BOT TELEGRAM [${green}bckp-bot${NC}]"
echo -e "$green [•28] $NC MONITORING CPU USAGE [${green}htop${NC}]"
echo -e "$green [•29] $NC LIMIT BANDWITH SPEED SERVER [${green}limit-speed${NC}]"
echo -e "$green [•30] $NC CHECK USAGE OF RAM [${green}ram${NC}]"
echo -e "$green [•31] $NC RESTART ALL SERVICES [${green}restart${NC}]"
echo -e "$green [•32] $NC RESTORE DATA VPS [${green}restore${NC}]"
echo -e "$green [•33] $NC UPDATE KERNEL TO LATEST VERSION [${green}update-kernel${NC}]"
echo -e "$green [•34] $NC CHANGE KERNEL TYPE 'CLOUD' TO ANOTHER VERSION [${green}fix-kernel-cloud${NC}]"
echo -e "$green [•35] $NC INSTALL WEBMIN [${green}wbmn${NC}]"
echo -e "$green [•36] $NC SPEEDTEST SERVER [${green}speedtest${NC}]"
echo -e "$green [•37] $NC RETURN TO BEGINNING MENU [${green}menu2${NC}]"
echo -e "$green [•38] $NC WARP CLOUDFLARE [${green}warp${NC}]"
echo -e "$green [•39] $NC WARP ADVANCED [${green}warp-advanced${NC}]"
echo -e "$green [•40] $NC VIEW SERVER'S TOTAL BANDWIDTH [${green}vnstat${NC}]"
echo -e "$green [•41] $NC VIEW PROTOCOL & PORT INFORMATION [${green}info${NC}]"
echo -e "$green [•42] $NC REBOOT SERVER [${green}reboot${NC}]"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${red}  CLIENT NAME :${NC} $clientname        |      ${red}EXP DATE :${NC} $exp  "
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
echo -e "[CTRL + C] For Exit From Main Menu"
echo -e ""
read -p "Select From Options [1-42 or x] :  " menu
echo -e ""
case $menu in
1)
menu-ssh
;;
2)
menu-vmess
;;
3)
menu-vmessupgrade
;;
4)
menu-vmessgrpc
;;
5)
menu-vmesstcp
;;
6)
menu-vless
;;
7)
menu-vlessupgrade
;;
8)
menu-vlessgrpc
;;
9)
menu-vlessxtls
;;
10)
menu-trws
;;
11)
menu-trojanupgrade
;;
12)
menu-tr
;;
13)
menu-trgrpc
;;
14)
menu-l2tp
;;
15)
menu-bundling
;;
16)
argo-setup
;;
17)
config-bot
;;
18)
config-api
;;
19)
force-host
;;
20)
change-slowdns
;;
21)
change-port
;;
22)
change-uuid
;;
23)
change-alt-port
;;
24)
backup-bot
;;
25)
auto-sendcreated
;;
26)
auto-sendtrial
;;
27)
bckp-bot
;;
28)
htop
;;
29)
limit-speed
;;
30)
ram
;;
31)
restart
;;
32)
restore
;;
33)
update-kernel
;;
34)
fix-kernel-cloud
;;
35)
wbmn
;;
36)
speedtest
;;
37)
menu2
;;
38)
warp
;;
39)
warp-advanced
;;
40)
vnstat
;;
41)
info
;;
42)
reboot
;;
x)
clear
menu2
;;
*)
echo " Please Choose Number !"
sleep 2 
exec "$0"
;;
esac
