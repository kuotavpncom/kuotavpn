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
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Configurasi Api Script"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "api documentation: https://github.com/kuotavpncom/api/tree/main"
echo -e "don't forget to click star and follow my github :v"
echo -e "by t.me/emdevika"
echo -e "━━━━━━━━━━━━━━━━━━━━"
apifile=$(cat /etc/william/apiX 2>/dev/null)
if [ -n "$apifile" ]; then
echo -e "Your Api Key: $apifile"
echo -e "End Point Local: http://localhost:5069/"
echo -e "End Point Public: http://${mydomain}:5069/"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "API keys are private/confidential. Please do not share them publicly.\nYou certainly wouldn’t want the public to access your API\nand create accounts secretly, right?"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e " [1]  Change API Key"
echo -e " [2]  Restart Services API"
echo -e " [3]  Update API"
echo -e " [4]  Disable Services & Delete API"
echo -e " [x]  Exit"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p " Select From Options [1-4 or x] :  " prot
echo -e ""
case $prot in
1)
echo ""
read -p "Please Input Your New API KEY: " apikey
if [ -z "$apikey" ]; then
echo -e "Input not valid!\nAPI key cannot be empty."
exit
fi
if [ ${#apikey} -lt 3 ]; then
echo -e "Input not valid!\nAPI key must be at least 3 characters long."
exit
fi
if ! [[ "$apikey" =~ ^[a-zA-Z0-9]+$ ]]; then
echo -e "Input not valid!\nAPI key must contain only alphanumeric characters."
exit
fi
echo "API key is Valid And Saved"
sleep 2
echo "$apikey" > /etc/william/apiX
systemctl restart apisc.service
;;
2)
sleep 3
systemctl restart apisc.service
echo ""
echo "Restart API Success"
;;
3)
echo "please wait...."
sleep 2
    wget --no-check-certificate -q -O /usr/bin/apxx https://raw.githubusercontent.com/$repogithub/api.py
    wget --no-check-certificate -q -O /usr/bin/add-sshx "https://raw.githubusercontent.com/$repogithub/add-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vmws "https://raw.githubusercontent.com/$repogithub/add-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/add-trojanws "https://raw.githubusercontent.com/$repogithub/add-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vlws "https://raw.githubusercontent.com/$repogithub/add-vlws.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vmgrpc "https://raw.githubusercontent.com/$repogithub/add-vmgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vlgrpc "https://raw.githubusercontent.com/$repogithub/add-vlgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/add-trojangrpc "https://raw.githubusercontent.com/$repogithub/add-trojangrpc.sh"
    
    wget --no-check-certificate -q -O /usr/bin/trial-sshx "https://raw.githubusercontent.com/$repogithub/trial-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vmws "https://raw.githubusercontent.com/$repogithub/trial-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-trojanws "https://raw.githubusercontent.com/$repogithub/trial-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vlws "https://raw.githubusercontent.com/$repogithub/trial-vlws.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vmgrpc "https://raw.githubusercontent.com/$repogithub/trial-vmgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vlgrpc "https://raw.githubusercontent.com/$repogithub/trial-vlgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-trojangrpc "https://raw.githubusercontent.com/$repogithub/trial-trojangrpc.sh"
    
    wget --no-check-certificate -q -O /usr/bin/del-sshx "https://raw.githubusercontent.com/$repogithub/del-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vmws "https://raw.githubusercontent.com/$repogithub/del-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/del-trojanws "https://raw.githubusercontent.com/$repogithub/del-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vlws "https://raw.githubusercontent.com/$repogithub/del-vlws.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vmgrpc "https://raw.githubusercontent.com/$repogithub/del-vmgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vlgrpc "https://raw.githubusercontent.com/$repogithub/del-vlgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/del-trojangrpc "https://raw.githubusercontent.com/$repogithub/del-trojangrpc.sh"
    
    wget --no-check-certificate -q -O /usr/bin/detail-vmws "https://raw.githubusercontent.com/$repogithub/detail-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-trojanws "https://raw.githubusercontent.com/$repogithub/detail-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-vlws "https://raw.githubusercontent.com/$repogithub/detail-vlws.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-vmgrpc "https://raw.githubusercontent.com/$repogithub/detail-vmgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-vlgrpc "https://raw.githubusercontent.com/$repogithub/detail-vlgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-trojangrpc "https://raw.githubusercontent.com/$repogithub/detail-trojangrpc.sh"
    
    wget --no-check-certificate -q -O /usr/bin/renew-sshx "https://raw.githubusercontent.com/$repogithub/renew-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vmws "https://raw.githubusercontent.com/$repogithub/renew-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-trojanws "https://raw.githubusercontent.com/$repogithub/renew-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vlws "https://raw.githubusercontent.com/$repogithub/renew-vlws.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vmgrpc "https://raw.githubusercontent.com/$repogithub/renew-vmgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vlgrpc "https://raw.githubusercontent.com/$repogithub/renew-vlgrpc.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-trojangrpc "https://raw.githubusercontent.com/$repogithub/renew-trojangrpc.sh"
    
    wget --no-check-certificate -q -O /usr/bin/add-l2tpx "https://raw.githubusercontent.com/$repogithub/add-l2tpx.sh"
    wget --no-check-certificate -q -O /usr/bin/del-l2tpx "https://raw.githubusercontent.com/$repogithub/del-l2tpx.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-l2tpx "https://raw.githubusercontent.com/$repogithub/renew-l2tpx.sh"
    chmod +x /usr/bin/add-sshx
    chmod +x /usr/bin/add-vmws
    chmod +x /usr/bin/add-trojanws
    chmod +x /usr/bin/add-vlws
    chmod +x /usr/bin/add-vmgrpc
    chmod +x /usr/bin/add-vlgrpc
    chmod +x /usr/bin/add-trojangrpc
    
    chmod +x /usr/bin/del-sshx
    chmod +x /usr/bin/del-vmws
    chmod +x /usr/bin/del-trojanws
    chmod +x /usr/bin/del-vlws
    chmod +x /usr/bin/del-vmgrpc
    chmod +x /usr/bin/del-vlgrpc
    chmod +x /usr/bin/del-trojangrpc
    
    chmod +x /usr/bin/detail-vmws
    chmod +x /usr/bin/detail-trojanws
    chmod +x /usr/bin/detail-vlws
    chmod +x /usr/bin/detail-vmgrpc
    chmod +x /usr/bin/detail-vlgrpc
    chmod +x /usr/bin/detail-trojangrpc
    
    chmod +x /usr/bin/renew-sshx
    chmod +x /usr/bin/renew-vmws
    chmod +x /usr/bin/renew-trojanws
    chmod +x /usr/bin/renew-vlws
    chmod +x /usr/bin/renew-vmgrpc
    chmod +x /usr/bin/renew-vlgrpc
    chmod +x /usr/bin/renew-trojangrpc
    
    chmod +x /usr/bin/trial-sshx
    chmod +x /usr/bin/trial-vmws
    chmod +x /usr/bin/trial-trojanws
    chmod +x /usr/bin/trial-vlws
    chmod +x /usr/bin/trial-vmgrpc
    chmod +x /usr/bin/trial-vlgrpc
    chmod +x /usr/bin/trial-trojangrpc
    
    chmod +x /usr/bin/add-l2tpx
    chmod +x /usr/bin/del-l2tpx
    chmod +x /usr/bin/renew-l2tpx
    systemctl restart apisc.service 2>/dev/null
    echo "UPDATE DONE"
;;
4)
echo "Wait...."
sleep 3
systemctl stop apisc 2>/dev/null
systemctl disable apisc 2>/dev/null
rm -rf /etc/william/apiX
echo "Disable Services & Delete API Success"
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
    echo ""
    echo -e "API keys are private/confidential. Please do not share them publicly."
    echo -e "You certainly wouldn’t want the public to access your API and create accounts secretly, right?"
    read -p "Please Input Your API KEY: " apikey
    if [ -z "$apikey" ]; then
        echo -e "Input not valid!\nAPI key cannot be empty."
        exit
    fi
    if [ ${#apikey} -lt 3 ]; then
        echo -e "Input not valid!\nAPI key must be at least 3 characters long."
        exit
    fi
    if ! [[ "$apikey" =~ ^[a-zA-Z0-9]+$ ]]; then
        echo -e "Input not valid!\nAPI key must contain only alphanumeric characters."
        exit
    fi
    echo "API key is Valid And Saved"
    echo "$apikey" > /etc/william/apiX
    #
    echo "installing api, please wait..."
    pip3 install flask > /dev/null 2>&1
    pip3 install waitress > /dev/null 2>&1
    echo "installing requirement, please wait..."
    wget --header 'Authorization: token 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' --no-check-certificate -q -O /usr/bin/apxx https://raw.githubusercontent.com/$repogithub/api.py
    wget --no-check-certificate -q -O /usr/bin/add-sshx "https://raw.githubusercontent.com/$repogithub/add-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vmws "https://raw.githubusercontent.com/$repogithub/add-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/add-trojanws "https://raw.githubusercontent.com/$repogithub/add-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/add-vlws "https://raw.githubusercontent.com/$repogithub/add-vlws.sh"
    
    wget --no-check-certificate -q -O /usr/bin/del-sshx "https://raw.githubusercontent.com/$repogithub/del-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vmws "https://raw.githubusercontent.com/$repogithub/del-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/del-trojanws "https://raw.githubusercontent.com/$repogithub/del-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/del-vlws "https://raw.githubusercontent.com/$repogithub/del-vlws.sh"
    
    wget --no-check-certificate -q -O /usr/bin/detail-vmws "https://raw.githubusercontent.com/$repogithub/detail-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-trojanws "https://raw.githubusercontent.com/$repogithub/detail-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/detail-vlws "https://raw.githubusercontent.com/$repogithub/detail-vlws.sh"
    
    wget --no-check-certificate -q -O /usr/bin/renew-sshx "https://raw.githubusercontent.com/$repogithub/renew-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vmws "https://raw.githubusercontent.com/$repogithub/renew-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-trojanws "https://raw.githubusercontent.com/$repogithub/renew-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-vlws "https://raw.githubusercontent.com/$repogithub/renew-vlws.sh"
    
    wget --no-check-certificate -q -O /usr/bin/trial-sshx "https://raw.githubusercontent.com/$repogithub/trial-sshx.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vmws "https://raw.githubusercontent.com/$repogithub/trial-vmws.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-trojanws "https://raw.githubusercontent.com/$repogithub/trial-trojanws.sh"
    wget --no-check-certificate -q -O /usr/bin/trial-vlws "https://raw.githubusercontent.com/$repogithub/trial-vlws.sh"
    
    wget --no-check-certificate -q -O /usr/bin/add-l2tpx "https://raw.githubusercontent.com/$repogithub/add-l2tpx.sh"
    wget --no-check-certificate -q -O /usr/bin/del-l2tpx "https://raw.githubusercontent.com/$repogithub/del-l2tpx.sh"
    wget --no-check-certificate -q -O /usr/bin/renew-l2tpx "https://raw.githubusercontent.com/$repogithub/renew-l2tpx.sh"
    chmod +x /usr/bin/apxx
    chmod +x /usr/bin/add-sshx
    chmod +x /usr/bin/add-vmws
    chmod +x /usr/bin/add-trojanws
    chmod +x /usr/bin/add-vlws
    
    chmod +x /usr/bin/del-sshx
    chmod +x /usr/bin/del-vmws
    chmod +x /usr/bin/del-trojanws
    chmod +x /usr/bin/del-vlws
    
    chmod +x /usr/bin/detail-vmws
    chmod +x /usr/bin/detail-trojanws
    chmod +x /usr/bin/detail-vlws
    
    chmod +x /usr/bin/renew-sshx
    chmod +x /usr/bin/renew-vmws
    chmod +x /usr/bin/renew-trojanws
    chmod +x /usr/bin/renew-vlws
    
    chmod +x /usr/bin/trial-sshx
    chmod +x /usr/bin/trial-vmws
    chmod +x /usr/bin/trial-trojanws
    chmod +x /usr/bin/trial-vlws
    
    chmod +x /usr/bin/add-l2tpx
    chmod +x /usr/bin/del-l2tpx
    chmod +x /usr/bin/renew-l2tpx
    systemctl restart apisc.service 2>/dev/null
    #
cat > /etc/systemd/system/apisc.service << END 
[Unit]
Description=Services API Development By @kuotavpn
After=network.target

[Service]
ExecStart=/usr/bin/apxx
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
systemctl enable apisc.service
systemctl start apisc.service
systemctl restart apisc.service
clear
echo "All Complete !"
fi
