#!/usr/bin/env bash
history -c
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
curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/logs.txt
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

mkdir -p /etc/william/profile/private/
KEY=$(cat /etc/william/profile/private/key 2>/dev/null)
CHATID=$(cat /etc/william/profile/private/chatid 2>/dev/null)
echo "======================"
echo "AUTOSEND ACCOUNT VPN"
echo "AFTER CREATED"
echo "======================"
if [[ -n $KEY ]]; then
echo -e "STATUS AUTOSEND ACCOUNT (${green}ON !${NC})"
echo -e "Current ID : $CHATID"
echo -e "Current API BOT : $KEY"
echo "======================"
echo -e " [1] Change User ID (warn: don't use id groub)"
echo -e " [2] Change API BOT TELEGRAM"
echo -e " [3] Stop AUTOSEND ACCOUNT"
echo -e " [x] EXIT"
echo -e ""
read -p " Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
echo "Change User ID"
read -p "Enter New ID: " newid
if [[ $newid =~ ^[0-9]+$ ]]; then
echo "done"
echo "$newid" > /etc/william/profile/private/chatid
else
echo "input tidak valid"
exit
fi
;;
2)
echo "Change API BOT Telegram"
read -p "Enter New API BOT: " newapi
echo "$newapi" > /etc/william/profile/private/key
echo "done"
;;
3)
read -p " Are You Sure ? [yes/no] :  " answer
if [ "$answer" == "y" ] || [ "$answer" == "ya" ] || [ "$answer" == "yes" ]; then
rm -rf /etc/william/profile/private/*
echo -e "Success Stop"
else
echo -e "oh maybe next time :V"
fi
;;
x)
exit
menu2
;;
*)
echo "Please enter an correct number"
;;
esac
else
echo -e "STATUS AUTOSEND ACCOUNT (${red}OFF !${NC})"
echo "======================"
echo "Your User ID (don't use id groub)"
read -p "Enter New ID: " newid
if [[ $newid =~ ^[0-9]+$ ]]; then
echo "done"
echo "$newid" > /etc/william/profile/private/chatid
else
echo "input tidak valid"
exit
fi
echo "======================"
echo ""
echo "API BOT Telegram"
read -p "Enter New API BOT: " newapi
echo "$newapi" > /etc/william/profile/private/key
echo "done"
echo "======================"
echo ""
echo "ACTIVATE AUTOSEND AFTER CREATED ACCOUNT DONE !"
echo "When you create an SSH or Xray VPN account"
echo "the account details will be automatically sent to"
echo "your personal Telegram."
fi