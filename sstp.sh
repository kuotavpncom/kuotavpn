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

# install xray
export HOMEBREW_FORCE_BREWED_CURL=1
apt install git -y
git config --global http.sslBackend gnutls
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --force --version 24.11.11
apt install python3-pip -y > /dev/null 2>&1
pip3 install xtlsapi==3.1.2 > /dev/null 2>&1
#
sleep 1
wget --header 'Authorization: token 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' --no-check-certificate -q -O /usr/bin/xv https://raw.githubusercontent.com/willstore69/niggafuckyou/main/xv
wget --header 'Authorization: token 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' --no-check-certificate -q -O /usr/bin/xd https://raw.githubusercontent.com/willstore69/niggafuckyou/main/xd
wget --header 'Authorization: token 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' --no-check-certificate -q -O /usr/bin/xvn https://raw.githubusercontent.com/willstore69/niggafuckyou/main/xvn
wget --header 'Authorization: token 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' --no-check-certificate -q -O /usr/bin/xdn https://raw.githubusercontent.com/willstore69/niggafuckyou/main/xdn
chmod +x /usr/bin/xv
chmod +x /usr/bin/xd
chmod +x /usr/bin/xvn
chmod +x /usr/bin/xdn

cat > "/etc/systemd/system/xray.service" << EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=nobody
Group=nogroup
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/config.json
RestartSec=5
Restart=always
SyslogIdentifier=xray
LimitNOFILE=infinity
OOMScoreAdjust=100

[Install]
WantedBy=multi-user.target
EOF

cat > "/etc/systemd/system/xray@none.service" << EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=nobody
Group=nogroup
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /usr/local/etc/xray/none.json
RestartSec=5
Restart=always
SyslogIdentifier=xray
LimitNOFILE=infinity
OOMScoreAdjust=100

[Install]
WantedBy=multi-user.target
EOF

sleep 1
systemctl daemon-reload
systemctl enable xray@none
systemctl enable xray

sleep 1
wget --no-check-certificate -q https://raw.githubusercontent.com/scriptvpskita/x/main/memek.sh && chmod +x memek.sh && ./memek.sh && rm -rf memek.sh

echo "oke"
sleep 2