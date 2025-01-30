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
  repopermission='https://www.kuotavpn.com/ZGFmdGFySVA'
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

# cek ip address
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

# cek client name
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

user=$1

cek_banned=$(cat /usr/local/etc/xray/config.json | grep "#banned" | awk '{print $1}' | sort -u)
cek_lock=$(cat /usr/local/etc/xray/config.json | grep "#lock" | awk '{print $1}' | sort -u)
if [[ -z $cek_banned && -z $cek_lock ]]; then
    echo -e "No Account Got Banned or Locked!"
    exit
fi
if [ -z "$user" ]; then
    echo "Please Input user !"
    exit 1
fi

# lanjut ke logic jika ada user yang dibanned/dilock

cek1=$(cat /usr/local/etc/xray/config.json | grep -w "#banned_vmessws" | awk '{print $1, $5}' | tr -d '"' | tr -d '}' | awk '{print $2}' | grep -w "$user")
# Mengecek hasil cek1
if [ -z "$cek1" ]; then
    # Jika cek1 kosong (tidak ditemukan), ganti cek2 dengan banned_vlessws
    cek2=$(cat /usr/local/etc/xray/config.json | grep -w "#banned_vlessws" | awk '{print $1, $5}' | tr -d '"' | tr -d '}' | awk '{print $2}' | grep -w "$user")
    
    if [ -z "$cek2" ]; then
        # Jika cek2 kosong (tidak ditemukan), ganti cek3 dengan banned_trojanws
        cek3=$(cat /usr/local/etc/xray/config.json | grep -w "#banned_trojanws" | awk '{print $1, $5}' | tr -d '"' | tr -d '}' | awk '{print $2}' | grep -w "$user")
        
        if [ -z "$cek3" ]; then
            # Jika cek3 kosong (tidak ditemukan), set cek4 ke lock
            cek4=$(cat /usr/local/etc/xray/config.json | grep -w "#lock" | awk '{print $1, $5}' | tr -d '"' | tr -d '}' | awk '{print $2}' | grep -w "$user")
            if [ -z "$cek4" ]; then
                echo "User $user Not Found In Database Locked/Banned"
            else
                sed -i '/#lock.*"email": "'"$user"'"/s/#lock //' /usr/local/etc/xray/config.json
                sed -i '/#lock.*"email": "'"$user"'"/s/#lock //' /usr/local/etc/xray/none.json
                echo -e "━━━━━━━━━━━━━━━━━━━━"
                echo -e "UNLOCK ACCOUNT SUCCESS !"
                echo -e "━━━━━━━━━━━━━━━━━━━━"
                echo -e "user : $user"
                echo -e "━━━━━━━━━━━━━━━━━━━━"
                systemctl restart xray
                systemctl restart xray@none
            fi
        else
            # Jika cek3 ditemukan
            sed -i '/#banned_trojanws.*"email": "'"$user"'"/s/#banned_trojanws //' /usr/local/etc/xray/config.json
            echo -e "━━━━━━━━━━━━━━━━━━━━"
            echo -e "UNBAN ACCOUNT SUCCESS !"
            echo -e "━━━━━━━━━━━━━━━━━━━━"
            echo -e "user : $user"
            echo -e "type : trojanws"
            echo -e "━━━━━━━━━━━━━━━━━━━━"
            systemctl restart xray
        fi
    else
        # Jika cek2 ditemukan
        sed -i '/#banned_vlessws.*"email": "'"$user"'"/s/#banned_vlessws //' /usr/local/etc/xray/config.json
        sed -i '/#banned_vlessws.*"email": "'"$user"'"/s/#banned_vlessws //' /usr/local/etc/xray/none.json
        echo -e "━━━━━━━━━━━━━━━━━━━━"
        echo -e "UNBAN ACCOUNT SUCCESS !"
        echo -e "━━━━━━━━━━━━━━━━━━━━"
        echo -e "user : $user"
        echo -e "type : vlessws"
        echo -e "━━━━━━━━━━━━━━━━━━━━"
        systemctl restart xray
        systemctl restart xray@none
    fi
else
    # Jika cek1 ditemukan
    sed -i '/#banned_vmessws.*"email": "'"$user"'"/s/#banned_vmessws //' /usr/local/etc/xray/config.json
    sed -i '/#banned_vmessws.*"email": "'"$user"'"/s/#banned_vmessws //' /usr/local/etc/xray/none.json
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    echo -e "UNBAN ACCOUNT SUCCESS !"
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    echo -e "user : $user"
    echo -e "type : vmess ws"
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    systemctl restart xray
    systemctl restart xray@none
fi
