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

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=william
organizationalunit=william
commonname=william
email=asistenwilliam@gmail.com

# install stunnel 5
echo "install STUNNEL5"
sleep 2
mkdir -p /etc/stunnel/
cd /root/
wget --no-check-certificate https://github.com/willstore69/update/raw/main/stunnel-5.70.tar.gz
tar -xzvf stunnel-5.70.tar.gz && rm -rf stunnel-5.70.tar.gz
cd stunnel-5.70 && rm -rf stunnel-5.70
./configure
make
make install
mv /usr/local/bin/stunnel /usr/local/bin/stunnel5
chmod +x /usr/local/bin/stunnel5
rm -rf /usr/local/bin/stunnel3
rm -rf /usr/local/bin/stunnel
touch /etc/stunnel/stunnel5.conf
touch /etc/stunnel/stunnel5.pem

# Download Config Stunnel5
cat > /etc/stunnel/stunnel.conf << END 
cert = /etc/stunnel/stunnel5.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear ws ssl]
accept = 6443
connect = 127.0.0.1:2052

[openvpn]
accept = 442
connect = 127.0.0.1:1194
END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel5.pem

# Service Stunnel5 systemctl restart stunnel5
cat > /etc/systemd/system/stunnel5.service << END
[Unit]
Description=Stunnel5 Service
Documentation=https://stunnel.org
Documentation=https://github.com/willstore69
After=syslog.target network-online.target

[Service]
ExecStart=/usr/local/bin/stunnel5 /etc/stunnel/stunnel.conf
Type=forking
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

# Service Stunnel5 /etc/init.d/stunnel5
wget --no-check-certificate -q -O /etc/init.d/stunnel5 "https://raw.githubusercontent.com/scriptvpskita/list-version/main/stunnel5.init"

# Ubah Izin Akses
chmod 600 /etc/stunnel/stunnel5.pem
chmod +x /etc/init.d/stunnel5

# Remove File
rm -r -f /usr/local/share/doc/stunnel/
rm -r -f /usr/local/etc/stunnel/
rm -f /usr/local/bin/stunnel
rm -f /usr/local/bin/stunnel3
rm -f /usr/local/bin/stunnel4

# Restart Stunnel 5
systemctl stop stunnel5
systemctl enable stunnel5
systemctl start stunnel5
systemctl restart stunnel5

# step one : install package
mkdir -p /etc/william/
cd /etc/william/
apt install npm -y
clear
source /etc/os-release
OS=$PRETTY_NAME
if [[ $OS == 'Debian GNU/Linux 9 (stretch)' ]]; then
curl -sL https://deb.nodesource.com/setup_14.x | bash
apt-get install -y nodejs
apt upgrade -y
fi
apt install nodejs -y
wget --no-check-certificate -q -O PDirect.js "https://raw.githubusercontent.com/xkjdox/sojsiws/main/ndjdjdjdi.js"
chmod +x PDirect.js
cd

# step two : configurasi sshws+ssl443
cat > /etc/systemd/system/cdn.service << END 
[Unit]
Description=P7COM-nodews1-WILLIAM
Documentation=https://p7com.net/
Documentation=https://t.me/kuotavpn
After=network.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/node --expose-gc /etc/william/PDirect.js -dhost 127.0.0.1 -dport 109 -mport 2052
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=multi-user.target
END

# Install Ovpn-Websocket
apt install python -y
cd /etc/william/
wget --no-check-certificate -q -O ODirect.py "https://raw.githubusercontent.com/xkjdox/sojsiws/main/PDirectovpn.py"
chmod +x /etc/william/ODirect.py
# Install Service Ovpn-ws
source /etc/os-release
release=$ID
ubuntu_version=$(lsb_release -a 2>/dev/null | awk '/Description/ {print $2, $3}' | cut -d. -f1 | awk {'print $2'} | cut -d. -f1)
debian_version=$(lsb_release -a 2>/dev/null | grep -w "Release" | awk {'print $2'})

if [[ "${release}" == "ubuntu" ]]; then
if [[ "$ubuntu_version" -ge 22 ]]; then
apt-get install liblzo2-dev -y
wget https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
tar xzf Python-2.7.16.tgz
cd Python-2.7.16
./configure --enable-optimizations
make altinstall
rm -rf Python-2.7.16*

cat > /etc/systemd/system/cdn-ovpn.service << END 
[Unit]
Description=WS-OPENVPN By william
Documentation=https://t.me/kuotavpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/python2.7 -O /etc/william/ODirect.py 2095
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END

else
cat > /etc/systemd/system/cdn-ovpn.service << END 
[Unit]
Description=WS-OPENVPN By william
Documentation=https://t.me/kuotavpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /etc/william/ODirect.py 2095
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END
fi
fi

if [[ "${release}" == "debian" ]]; then
if [[ "$debian_version" -ge 12 ]]; then
apt-get install liblzo2-dev -y
wget https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
tar xzf Python-2.7.16.tgz
cd Python-2.7.16
./configure --enable-optimizations
make altinstall
rm -rf Python-2.7.16*

cat > /etc/systemd/system/cdn-ovpn.service << END 
[Unit]
Description=WS-OPENVPN By william
Documentation=https://t.me/kuotavpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/python2.7 -O /etc/william/ODirect.py 2095
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END

else
cat > /etc/systemd/system/cdn-ovpn.service << END 
[Unit]
Description=WS-OPENVPN By william
Documentation=https://t.me/kuotavpn
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /etc/william/ODirect.py 2095
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
END
fi
fi

# step three : enable service and reboot eh tapi boong
systemctl daemon-reload
systemctl enable cdn.service
systemctl start cdn.service
systemctl enable cdn-ovpn.service
systemctl start cdn-ovpn.service

clear
echo "INSTALL COMPLETED ! AUTOREBOOT ON 3 SEC."
sleep 1
echo "1"
sleep 1
echo "2"
sleep 2
echo "3"
echo "eh tapi boong"
sleep 1
rm -rf ssh-ws-ssl.sh
clear