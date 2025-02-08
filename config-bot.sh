#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit
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
echo -e "Contact Admin : t.me/emdevika"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit
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
echo -e "Contact Admin : t.me/emdevika"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit
fi

# cek client name
clientname=$(cat /usr/local/etc/clientname)
checkclient=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $2}' | sort | uniq` )
if [[ "$clientname" = "$checkclient" ]]; then
echo -e "${green}Client Name Accepted${NC}"
clear
else
echo -e "${red}Client Name Not Compatible !${NC}"
echo -e "Contact Admin : t.me/emdevika"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

mydomain=$(cat /etc/xray/domain)
apifile=$(cat /etc/william/apiX 2>/dev/null)
if [ -z "$apifile" ]; then
    echo ""
    echo -e "You Need To Activate API Before Doing This !"
    exit
fi

echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Configurasi BOT Telegram"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Manage accounts via Telegram BOT"
echo -e "create, delete, renew, check login & cek detail account"
echo -e "by t.me/emdevika"
echo -e "━━━━━━━━━━━━━━━━━━━━"
valid_bot=$(cat /etc/william/valid_bot.txt 2>/dev/null)
valid_id=$(cat /etc/william/valid_id.txt 2>/dev/null)
if [[ -n "$valid_bot" && -n "$valid_id" ]]; then
    echo -e "Your API Bot Telegram:"
    echo -e "$valid_bot"
    echo -e "---------------------"
    echo -e "IDs Telegram Allowed:"
    echo -e "$valid_id"
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    echo -e " [1]  Change API Key Bot Telegram"
    echo -e " [2]  Manage Telegram IDs"
    echo -e " [3]  Manage Servers"
    echo -e " [4]  Restart Services Bot"
    echo -e " [5]  Disable & Delete Services Bot"
    echo -e " [x]  Exit"
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    echo -e ""
    read -p "Select From Options [1-5 or x] :  " prot
    echo -e ""
    case $prot in
        1)
            echo ""
            read -p "Please input your new API key: " apikey
            if [ -z "$apikey" ]; then
                echo -e "Input not valid!\nAPI key cannot be empty."
                exit
            fi
            echo "OKAY"
            echo ""
            sleep 2
            echo "$apikey" > /etc/william/valid_bot.txt
            systemctl restart apibot.service > /dev/null 2>&1
            ;;
        2)
            echo ""
            echo -e "Manage Telegram IDs:"
            echo -e " [a] Add New ID"
            echo -e " [b] Change Existing ID"
            echo -e " [c] Delete ID"
            echo -e " [x] Back"
            read -p "Select an option [a-c or x]: " id_option
            case $id_option in
                a)
                    read -p "Please input new Telegram ID: " new_id
                    if [ -z "$new_id" ]; then
                        echo -e "Input not valid!\nID cannot be empty."
                        exit
                    fi
                    if ! [[ "$new_id" =~ ^[0-9]+$ ]]; then
                        echo -e "Input not valid!\nID must contain only numeric characters."
                        exit
                    fi
                    echo "$new_id" >> /etc/william/valid_id.txt
                    echo "New ID added successfully."
                    systemctl restart apibot.service > /dev/null 2>&1
                    ;;
                b)
                    read -p "Enter the ID to be replaced: " old_id
                    read -p "Enter the new ID: " new_id
                    if [ -z "$old_id" ] || [ -z "$new_id" ]; then
                        echo -e "Input not valid!\nBoth IDs must be provided."
                        exit
                    fi
                    if ! [[ "$old_id" =~ ^[0-9]+$ ]] || ! [[ "$new_id" =~ ^[0-9]+$ ]]; then
                        echo -e "Input not valid!\nIDs must contain only numeric characters."
                        exit
                    fi
                    sed -i "s/$old_id/$new_id/" /etc/william/valid_id.txt
                    echo "ID replaced successfully."
                    systemctl restart apibot.service > /dev/null 2>&1
                    ;;
                c)
                    read -p "Enter the ID to be deleted: " del_id
                    if [ -z "$del_id" ]; then
                        echo -e "Input not valid!\nID cannot be empty."
                        exit
                    fi
                    if ! [[ "$del_id" =~ ^[0-9]+$ ]]; then
                        echo -e "Input not valid!\nID must contain only numeric characters."
                        exit
                    fi
                    sed -i "/$del_id/d" /etc/william/valid_id.txt
                    echo "ID deleted successfully."
                    systemctl restart apibot.service > /dev/null 2>&1
                    ;;
                x)
                    config-bot
                    ;;
                *)
                    echo "Please enter a correct option"
                    ;;
            esac
            ;;
        3)
            echo ""
            echo -e "Manage Servers:"
            echo -e " [a] Add Server"
            echo -e " [b] Delete Server"
            echo -e " [c] List Server"
            echo -e " [x] back"
            read -p "Select an option [a-c or x]: " server_option
            case $server_option in
                a)
                    read -p "Enter the server details (IP/hostname): " server_details
                    if [ -z "$server_details" ]; then
                        echo -e "Input not valid!\nServer details cannot be empty."
                        exit
                    fi
                    echo "$server_details" >> /etc/william/myvps.txt
                    echo "Server added successfully."
                    systemctl restart apibot.service > /dev/null 2>&1
                    ;;
                b)
                    read -p "Enter the server details to be deleted (IP/hostname): " server_details
                    if [ -z "$server_details" ]; then
                        echo -e "Input not valid!\nServer details cannot be empty."
                        exit
                    fi
                    sed -i "/$server_details/d" /etc/william/myvps.txt
                    echo "Server deleted successfully."
                    systemctl restart apibot.service > /dev/null 2>&1
                    ;;
                c)
                    listserver=$(cat /etc/william/myvps.txt 2>/dev/null)
                    echo -e "List Server:"
                    echo -e "$listserver"
                    ;;
                x)
                    config-bot
                    ;;
                *)
                    echo "Please enter a correct option"
                    ;;
            esac
            ;;
        4)
            systemctl restart apibot.service > /dev/null 2>&1
            echo "Bot service restarted successfully."
            ;;
        5)
            systemctl stop apibot.service > /dev/null 2>&1
            systemctl disable apibot.service > /dev/null 2>&1
            rm -rf /etc/william/valid_id.txt
            rm -rf /etc/william/valid_bot.txt
            echo "Bot service disabled and configuration files deleted."
            ;;
        x)
            exit
            ;;
        *)
            echo "Please enter a correct number"
            ;;
    esac
else
    echo ""
    echo -e "Get API Key Bot Telegram => https://t.me/BotFather"
    read -p "Please Input Your API KEY: " apikey
    if [ -z "$apikey" ]; then
        echo -e "Input not valid!\nAPI key cannot be empty."
        exit
    fi
    echo "OKAY!"
    echo "$apikey" > /etc/william/valid_bot.txt
    echo ""
    echo -e "Get ID Telegram => https://t.me/MissRose_bot\nType /id"
    read -p "Please Input Your ID Telegram: " idvalid
    if [ -z "$idvalid" ]; then
        echo -e "Input not valid!\nID cannot be empty."
        exit
    fi
    if ! [[ "$idvalid" =~ ^[0-9]+$ ]]; then
        echo -e "Input not Valid!\nID key must contain only numeric."
        exit
    fi
    echo "OKAY!"
    echo "$idvalid" > /etc/william/valid_id.txt
    echo ""
    echo "Installing requirement, please wait..."
    sleep 2
    pip3 install --upgrade pip > /dev/null 2>&1
    pip3 install aiohttp==3.10.3 > /dev/null 2>&1
    pip3 install python-telegram-bot==21.4 > /dev/null 2>&1
    pip3 install nest_asyncio==1.6.0 > /dev/null 2>&1
    wget --no-check-certificate -q -O /usr/bin/apxb https://raw.githubusercontent.com/$repogithub/bot-vpn.py
    chmod +x /usr/bin/apxb
    cat > /etc/systemd/system/apibot.service << END
[Unit]
Description=Services API BOT TELEGRAM By @kuotavpn
After=network.target

[Service]
ExecStart=/usr/bin/apxb
User=root
Group=root
PermissionsStartOnly=true
AmbientCapabilities=CAP_DAC_OVERRIDE
LimitNOFILE=infinity
OOMScoreAdjust=100

[Install]
WantedBy=multi-user.target
END

    systemctl daemon-reload
    systemctl enable apibot.service > /dev/null 2>&1 2>/dev/null
    systemctl start apibot.service > /dev/null 2>&1 2>/dev/null
    systemctl restart apibot.service > /dev/null 2>&1 2>/dev/null
    clear
    echo ""
    echo "All Complete!"
fi
