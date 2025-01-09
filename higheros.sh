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
    echo -e "Contact Admin : t.me/emdevika"
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
  echo -e "Contact Admin : t.me/emdevika"
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
  echo -e "Contact Admin : t.me/emdevika"
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
organization=kuotavpn
organizationalunit=kuotavpn
commonname=kuotavpn
email=kuotavpn@gmail.com

source /etc/os-release
release=$ID
os_version=$(cat /etc/os-release | grep -w "VERSION_ID" | awk -F'"' '{print $2}' | cut -d. -f1)

# install stunnel 5
if [[ "${release}" == "ubuntu" ]]; then
if [[ "$os_version" -ge 22 ]]; then
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

#
apt-get install bc

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
systemctl enable stunnel5
systemctl stop stunnel5
systemctl start stunnel5
systemctl restart stunnel5
fi
fi

# install stunnel 5
if [[ "${release}" == "debian" ]]; then
if [[ "$os_version" -ge 11 ]]; then
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
systemctl enable stunnel5
systemctl stop stunnel5
systemctl start stunnel5
systemctl restart stunnel5
fi
fi

sleep 3

echo "WAIT.."
source /etc/os-release
release=$ID
os_version=$(cat /etc/os-release | grep -w "VERSION_ID" | awk -F'"' '{print $2}' | cut -d. -f1)

if [[ "${release}" == "ubuntu" ]]; then
if [[ "$os_version" -ge 22 ]]; then
apt -y reinstall sslh

cat > /lib/systemd/system/sslh.service << END
[Unit]
Description=SSL/SSH multiplexer
After=network.target
Documentation=man:sslh(8)

[Service]
EnvironmentFile=/etc/default/sslh
ExecStart=/usr/sbin/sslh --foreground --user sslh --listen 0.0.0.0:443 --ssh 127.0.0.1:22 --tls 127.0.0.1:1369 --openvpn 127.0.0.1:1194 --anyprot 127.0.0.1:109 --pidfile /var/run/sslh/sslh.pid
KillMode=process
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl start sslh
systemctl restart sslh
chmod 777 /var/run/sslh/sslh.pid
systemctl restart sslh
fi
fi

if [[ "${release}" == "debian" ]]; then
if [[ "$os_version" -ge 11 ]]; then
apt -y reinstall sslh
cat > /lib/systemd/system/sslh.service << END
[Unit]
Description=SSL/SSH multiplexer
After=network.target
Documentation=man:sslh(8)

[Service]
EnvironmentFile=/etc/default/sslh
ExecStart=/usr/sbin/sslh --foreground --user sslh --listen 0.0.0.0:443 --ssh 127.0.0.1:22 --tls 127.0.0.1:1369 --openvpn 127.0.0.1:1194 --anyprot 127.0.0.1:109 --pidfile /var/run/sslh/sslh.pid
KillMode=process
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl start sslh
systemctl restart sslh
chmod 777 /var/run/sslh/sslh.pid
systemctl restart sslh
fi
fi

# INSTALL OPENVPN FOR UBUNTU & DEBIAN HIGHER OS
if [[ "${release}" == "ubuntu" ]]; then
if [[ "$os_version" -ge 22 ]]; then
apt-get install liblzo2-dev -y
apt install openvpn-systemd-resolved -y
sed -i 's|up /etc/openvpn/update-resolv-conf|up /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-tcp-1194.conf
sed -i 's|down /etc/openvpn/update-resolv-conf|down /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-tcp-1194.conf
sed -i 's|up /etc/openvpn/update-resolv-conf|up /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-udp-2200.conf
sed -i 's|down /etc/openvpn/update-resolv-conf|down /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-udp-2200.conf
systemctl restart openvpn-server@server-tcp-1194
systemctl restart openvpn-server@server-udp-2200
fi
fi

if [[ "${release}" == "debian" ]]; then
if [[ "$os_version" -ge 11 ]]; then
apt-get install liblzo2-dev -y
apt install openvpn-systemd-resolved -y
sed -i 's|up /etc/openvpn/update-resolv-conf|up /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-tcp-1194.conf
sed -i 's|down /etc/openvpn/update-resolv-conf|down /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-tcp-1194.conf
sed -i 's|up /etc/openvpn/update-resolv-conf|up /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-udp-2200.conf
sed -i 's|down /etc/openvpn/update-resolv-conf|down /etc/openvpn/update-systemd-resolved|g' /etc/openvpn/server/server-udp-2200.conf
systemctl restart openvpn-server@server-tcp-1194
systemctl restart openvpn-server@server-udp-2200
fi
fi

# Validate 24.04
source /etc/os-release
release=$ID
os_version=$(cat /etc/os-release | grep -w "VERSION_ID" | awk -F'"' '{print $2}' | cut -d. -f1)
if [[ "${release}" == "ubuntu" ]]; then
if [[ "$os_version" -ge 24 ]]; then
apt-get update -y
apt-get install software-properties-common -y
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -y
apt-get install python3.10 -y
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
update-alternatives --set python3 /usr/bin/python3.10
apt-get remove --purge python3-cryptography -y > /dev/null 2>&1
apt-get remove --purge python3-pip -y > /dev/null 2>&1
apt-get autoremove -y
apt-get clean
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --force-reinstall
rm -rf get-pip.py
mv /usr/local/bin/pip /usr/bin/pip3
chmod +x /usr/bin/pip3
pip3 install --upgrade pip setuptools wheel > /dev/null 2>&1
pip3 install cffi cryptography telegram > /dev/null 2>&1
pip3 install --upgrade pip > /dev/null 2>&1
pip3 install aiohttp==3.10.3 > /dev/null 2>&1
pip3 uninstall python-telegram-bot -y
pip3 install python-telegram-bot==21.4 > /dev/null 2>&1
pip3 install nest_asyncio==1.6.0 > /dev/null 2>&1
pip3 install xtlsapi==3.1.2 > /dev/null 2>&1
pip3 install flask > /dev/null 2>&1
pip3 install waitress > /dev/null 2>&1
mv /usr/lib/python3/dist-packages/apt_pkg.cpython-312-x86_64-linux-gnu.so /usr/lib/python3/dist-packages/apt_pkg.so
apt update -y
fi
fi

if [[ "${release}" == "debian" ]]; then
if [[ "$os_version" -ge 10 ]]; then
apt-get update && apt-get install -y \
wget build-essential \
libssl-dev zlib1g-dev \
libncurses5-dev libncursesw5-dev \
libreadline-dev libsqlite3-dev \
libgdbm-dev libdb5.3-dev libbz2-dev \
libexpat1-dev liblzma-dev tk-dev \
libffi-dev libgdbm-compat-dev
wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar -xf Python-3.10.0.tgz
cd Python-3.10.0
./configure --enable-optimizations --prefix=/usr
make -j$(nproc)
make altinstall
rm -rf /root/Python-3.10*
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 2
update-alternatives --set python3 /usr/bin/python3.10 > /dev/null 2>&1
apt-get remove --purge python3-cryptography -y > /dev/null 2>&1
apt-get remove --purge python3-pip -y > /dev/null 2>&1
apt-get autoremove -y
apt-get clean
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --force-reinstall
rm -rf get-pip.py
mv /usr/local/bin/pip /usr/bin/pip3
chmod +x /usr/bin/pip3
pip3 install --upgrade pip setuptools wheel > /dev/null 2>&1
pip3 install cffi cryptography telegram > /dev/null 2>&1
pip3 install --upgrade pip > /dev/null 2>&1
pip3 install aiohttp==3.10.3 > /dev/null 2>&1
pip3 uninstall python-telegram-bot -y > /dev/null 2>&1
pip3 install python-telegram-bot==21.4 > /dev/null 2>&1
pip3 install nest_asyncio==1.6.0 > /dev/null 2>&1
pip3 install xtlsapi==3.1.2 > /dev/null 2>&1
pip3 install flask > /dev/null 2>&1
pip3 install waitress > /dev/null 2>&1
fi
fi