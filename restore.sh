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

rm -rf /tmp/vm*
rm -rf /tmp/vl*
rm -rf /tmp/tr*
rm -rf /tmp/tr*
mkdir -p /etc/cf-argo/
DOMAIN=$(cat /etc/xray/domain);
clear
echo "Please choose an option:"
echo ""
echo "1) Restore from VPS backup link"
echo "2) Restore from VPS zip file"
echo "3) Restore from VPS link/zip no replace"
read -rp "Select an option [1-3]: " option

if [[ "$option" == "1" ]]; then
    echo "This Feature Can Only Be Used According To VPS Data With This Autoscript"
    echo "Please input link to your VPS data backup file."
    echo "You can check it on your email if you run backup data VPS before."
    read -rp "Link File: " -e url

    if echo "$url" | grep -q 'drive.google.com'; then
        echo "Please Wait Sir....."
        pip3 install gdown >/dev/null 2>&1
        gdown "${url}" -O backup.zip >/dev/null 2>&1
# UNZIP DARI HASIL PILIHAN USER
unzip backup.zip
rm -f backup.zip
sleep 1
echo "Start Restore"
cd /root/backup
cp -r xray /etc/
cp -r v2ray /etc/
cp -r premium-script /var/lib/
cp -r public_html /home/vps/
cp -r private /etc/ssl/
cp -r william /etc/
cp -r slowdns /etc/william/
cp -r conf.d /etc/nginx/
cp -r openvpn /etc/
cp passwd /etc/
cp group /etc/
cp gshadow /etc/
cp shadow /etc/
cp config.json /usr/local/etc/xray/
cp none.json /usr/local/etc/xray/
cp will69.json /usr/local/etc/xray/
cp will666.json /usr/local/etc/xray/
cp chap-secrets /etc/ppp/
cp ipsec.secrets /etc/
cp cdn.service /etc/systemd/system/
cp log-install.txt /root/
rm -rf /root/backup
rm -rf backup.zip
cd /root
rm -rf /root/backup
rm -rf backup.zip
/etc/william/slowdns/./dns-server -gen-key -privkey-file /etc/william/slowdns/server.key -pubkey-file /etc/william/slowdns/server.pub
systemctl restart stunnel5
systemctl restart cdn
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart slowdns
systemctl restart udp-custom
sleep 1
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-ssl-442.ovpn /home/vps/public_html/client-tcp-ssl-442.ovpn
cp /etc/ipsec.d/cacerts/vpn_ca_cert.pem /home/vps/public_html/${DOMAIN}_IKEV2-EAP-CA.pem
echo "Done"
echo "Reboot on 3sec"
sleep 3
reboot
    fi
elif [[ "$option" == "2" ]]; then
    echo "Looking for a local zip file that contains 'backup' in the name..."
    zipfile=$(ls /root/ | grep 'backup.zip')
    if [[ -z "$zipfile" ]]; then
        echo "No Backup Files Found!"
        exit 1
    fi
    echo "Found zip file: $zipfile"
    cp /root/$zipfile /root/backup.zip
    rm -rf $zipfile
# UNZIP DARI HASIL PILIHAN USER
unzip -P backup.zip
rm -f backup.zip
sleep 1
echo "Start Restore"
cd /root/backup
cp -r xray /etc/
cp -r v2ray /etc/
cp -r premium-script /var/lib/
cp -r public_html /home/vps/
cp -r private /etc/ssl/
cp -r william /etc/
cp -r slowdns /etc/william/
cp -r conf.d /etc/nginx/
cp passwd /etc/
cp group /etc/
cp gshadow /etc/
cp shadow /etc/
cp ssh.json /usr/local/etc/xray/
cp config.json /usr/local/etc/xray/
cp none.json /usr/local/etc/xray/
cp will666.json /usr/local/etc/xray/
cp will69.json /usr/local/etc/xray/
cp cdn.service /etc/systemd/system/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
cp log-install.txt /root/
cp issue.net /etc/
cd /root
rm -rf /root/backup
rm -rf backup.zip
/etc/william/slowdns/./dns-server -gen-key -privkey-file /etc/william/slowdns/server.key -pubkey-file /etc/william/slowdns/server.pub
systemctl restart stunnel5
systemctl restart cdn
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart slowdns
systemctl restart udp-custom
sleep 1
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-ssl-442.ovpn /home/vps/public_html/client-tcp-ssl-442.ovpn
cp /etc/ipsec.d/cacerts/vpn_ca_cert.pem /home/vps/public_html/${DOMAIN}_IKEV2-EAP-CA.pem
echo "Done"
echo "Reboot on 3sec"
sleep 3
reboot
elif [[ "$option" == "3" ]]; then
    echo "Choose a method to retrieve the backup data:"
    echo "1. Via link"
    echo "2. From local files"
    read -rp "Select an option (1/2): " method
    if [[ "$method" == "1" ]]; then
        echo "Please input link to your VPS data backup file."
        read -rp "Link File: " -e url
        if echo "$url" | grep -q 'drive.google.com'; then
            echo "Please Wait Sir....."
            pip3 install gdown >/dev/null 2>&1
            gdown "${url}" -O backup.zip >/dev/null 2>&1
# BAGIAN UNZIP
# UNZIP DARI HASIL PILIHAN USER
unzip -P backup.zip
rm -f backup.zip
sleep 1
echo "Start Restore"
cd /root/backup
cp -r xray /etc/
cp -r v2ray /etc/
cp -r premium-script /var/lib/
cp -r public_html /home/vps/
cp -r private /etc/ssl/
cp -r william /etc/
cp -r slowdns /etc/william/
cp -r conf.d /etc/nginx/
cp passwd /etc/
cp group /etc/
cp gshadow /etc/
cp shadow /etc/
cp ssh.json /usr/local/etc/xray/
cp cdn.service /etc/systemd/system/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
cp log-install.txt /root/
cp issue.net /etc/
#
# DATA SERVER
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data_server.json
cat /usr/local/etc/xray/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data_server.json

# DATA BACKUP
cat /root/backup/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data.json 2>/dev/null
cat /root/backup/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data.json 2>/dev/null

# GABUNGKAN SERVER & BACKUP
cat /tmp/trojanws_tls_data_server.json /tmp/trojanws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanws_tls_data.json 2>/dev/null
cat /tmp/vmesstcp_tls_data_server.json /tmp/vmesstcp_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmesstcp_tls_data.json 2>/dev/null
cat /tmp/vmessws_tls_data_server.json /tmp/vmessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_tls_data.json 2>/dev/null
cat /tmp/vlessws_tls_data_server.json /tmp/vlessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_tls_data.json 2>/dev/null
cat /tmp/vmessupgrade_tls_data_server.json /tmp/vmessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_tls_data.json 2>/dev/null
cat /tmp/vlessupgrade_tls_data_server.json /tmp/vlessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_tls_data.json 2>/dev/null
cat /tmp/trojanupgrade_tls_data_server.json /tmp/trojanupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanupgrade_tls_data.json 2>/dev/null
cat /tmp/trojangrpc_tls_data_server.json /tmp/trojangrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojangrpc_tls_data.json 2>/dev/null
cat /tmp/vlessgrpc_tls_data_server.json /tmp/vlessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessgrpc_tls_data_server.json /tmp/vmessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessws_ntls_data_server.json /tmp/vmessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_ntls_data.json 2>/dev/null
cat /tmp/vlessws_ntls_data_server.json /tmp/vlessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_ntls_data.json 2>/dev/null
cat /tmp/vmessupgrade_ntls_data_server.json /tmp/vmessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessupgrade_ntls_data_server.json /tmp/vlessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessxtls_data_server.json /tmp/vlessxtls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessxtls_data.json 2>/dev/null
cat /tmp/trojan_tcp_data_server.json /tmp/trojan_tcp_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojan_tcp_data.json 2>/dev/null
#pisahin
cp /usr/local/etc/xray/config.json /tmp/backup_config.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will666.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will69.json
cp /usr/local/etc/xray/none.json /tmp/backup_none.json
rm -rf /usr/local/etc/xray/config.json
rm -rf /usr/local/etc/xray/will666.json
rm -rf /usr/local/etc/xray/none.json
#
wget -q https://raw.githubusercontent.com/scriptvpskita/x/refs/heads/main/crot/crot/crot/crot/crot/crot/crott.sh && chmod +x crott.sh && ./crott.sh
#
sed -i "/^#trojanws$/ r /tmp/hasil_trojanws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmesstcp$/ r /tmp/hasil_vmesstcp_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessws$/ r /tmp/hasil_vmessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessws$/ r /tmp/hasil_vlessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessupgrade$/ r /tmp/hasil_vmessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessupgrade$/ r /tmp/hasil_vlessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#trojanupgrade$/ r /tmp/hasil_trojanupgrade_tls_data.json" /usr/local/etc/xray/config.json
# grpc on config.json
sed -i "/^#trojanGRPCX$/ r /tmp/hasil_trojangrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessGRPCX$/ r /tmp/hasil_vmessgrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessGRPCX$/ r /tmp/hasil_vlessgrpc_tls_data.json" /usr/local/etc/xray/config.json
# tls on will666.json
sed -i "/^#vlessxtls$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/will666.json
# tls on will69.json
sed -i "/^#trojantcp$/ r /tmp/hasil_trojantcp_data.json" /usr/local/etc/xray/will69.json
# ntls on none.json
sed -i "/^#vmessWS$/ r /tmp/hasil_vmessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessWS$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vmessUPGRADE$/ r /tmp/hasil_vmessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessUPGRADE$/ r /tmp/hasil_vlessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
#
cd /root
rm -rf /root/backup
rm -rf backup.zip
/etc/william/slowdns/./dns-server -gen-key -privkey-file /etc/william/slowdns/server.key -pubkey-file /etc/william/slowdns/server.pub
systemctl restart stunnel5
systemctl restart cdn
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart slowdns
systemctl restart udp-custom
sleep 1
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-ssl-442.ovpn /home/vps/public_html/client-tcp-ssl-442.ovpn
cp /etc/ipsec.d/cacerts/vpn_ca_cert.pem /home/vps/public_html/${DOMAIN}_IKEV2-EAP-CA.pem
echo "Done"
echo "Reboot on 3sec"
sleep 3
reboot
        else
            wget --no-check-certificate -O backup.zip "$url"
# BAGIAN UNZIP
# UNZIP DARI HASIL PILIHAN USER
unzip -P backup.zip
rm -f backup.zip
sleep 1
echo "Start Restore"
cd /root/backup
cp -r xray /etc/
cp -r v2ray /etc/
cp -r premium-script /var/lib/
cp -r public_html /home/vps/
cp -r private /etc/ssl/
cp -r william /etc/
cp -r slowdns /etc/william/
cp -r conf.d /etc/nginx/
cp passwd /etc/
cp group /etc/
cp gshadow /etc/
cp shadow /etc/
cp ssh.json /usr/local/etc/xray/
cp cdn.service /etc/systemd/system/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
cp log-install.txt /root/
cp issue.net /etc/
#
# DATA SERVER
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data_server.json
cat /usr/local/etc/xray/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data_server.json

# DATA BACKUP
cat /root/backup/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data.json 2>/dev/null
cat /root/backup/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data.json 2>/dev/null

# GABUNGKAN SERVER & BACKUP
cat /tmp/trojanws_tls_data_server.json /tmp/trojanws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanws_tls_data.json 2>/dev/null
cat /tmp/vmesstcp_tls_data_server.json /tmp/vmesstcp_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmesstcp_tls_data.json 2>/dev/null
cat /tmp/vmessws_tls_data_server.json /tmp/vmessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_tls_data.json 2>/dev/null
cat /tmp/vlessws_tls_data_server.json /tmp/vlessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_tls_data.json 2>/dev/null
cat /tmp/vmessupgrade_tls_data_server.json /tmp/vmessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_tls_data.json 2>/dev/null
cat /tmp/vlessupgrade_tls_data_server.json /tmp/vlessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_tls_data.json 2>/dev/null
cat /tmp/trojanupgrade_tls_data_server.json /tmp/trojanupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanupgrade_tls_data.json 2>/dev/null
cat /tmp/trojangrpc_tls_data_server.json /tmp/trojangrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojangrpc_tls_data.json 2>/dev/null
cat /tmp/vlessgrpc_tls_data_server.json /tmp/vlessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessgrpc_tls_data_server.json /tmp/vmessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessws_ntls_data_server.json /tmp/vmessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_ntls_data.json 2>/dev/null
cat /tmp/vlessws_ntls_data_server.json /tmp/vlessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_ntls_data.json 2>/dev/null
cat /tmp/vmessupgrade_ntls_data_server.json /tmp/vmessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessupgrade_ntls_data_server.json /tmp/vlessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessxtls_data_server.json /tmp/vlessxtls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessxtls_data.json 2>/dev/null
cat /tmp/trojan_tcp_data_server.json /tmp/trojan_tcp_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojan_tcp_data.json 2>/dev/null
#pisahin
cp /usr/local/etc/xray/config.json /tmp/backup_config.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will666.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will69.json
cp /usr/local/etc/xray/none.json /tmp/backup_none.json
rm -rf /usr/local/etc/xray/config.json
rm -rf /usr/local/etc/xray/will666.json
rm -rf /usr/local/etc/xray/none.json
#
wget -q https://raw.githubusercontent.com/scriptvpskita/x/refs/heads/main/crot/crot/crot/crot/crot/crot/crott.sh && chmod +x crott.sh && ./crott.sh
#
sed -i "/^#trojanws$/ r /tmp/hasil_trojanws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmesstcp$/ r /tmp/hasil_vmesstcp_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessws$/ r /tmp/hasil_vmessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessws$/ r /tmp/hasil_vlessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessupgrade$/ r /tmp/hasil_vmessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessupgrade$/ r /tmp/hasil_vlessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#trojanupgrade$/ r /tmp/hasil_trojanupgrade_tls_data.json" /usr/local/etc/xray/config.json
# grpc on config.json
sed -i "/^#trojanGRPCX$/ r /tmp/hasil_trojangrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessGRPCX$/ r /tmp/hasil_vmessgrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessGRPCX$/ r /tmp/hasil_vlessgrpc_tls_data.json" /usr/local/etc/xray/config.json
# tls on will666.json
sed -i "/^#vlessxtls$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/will666.json
# tls on will69.json
sed -i "/^#trojantcp$/ r /tmp/hasil_trojantcp_data.json" /usr/local/etc/xray/will69.json
# ntls on none.json
sed -i "/^#vmessWS$/ r /tmp/hasil_vmessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessWS$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vmessUPGRADE$/ r /tmp/hasil_vmessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessUPGRADE$/ r /tmp/hasil_vlessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
#
cd /root
rm -rf /root/backup
rm -rf backup.zip
/etc/william/slowdns/./dns-server -gen-key -privkey-file /etc/william/slowdns/server.key -pubkey-file /etc/william/slowdns/server.pub
systemctl restart stunnel5
systemctl restart cdn
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart slowdns
systemctl restart udp-custom
sleep 1
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-ssl-442.ovpn /home/vps/public_html/client-tcp-ssl-442.ovpn
cp /etc/ipsec.d/cacerts/vpn_ca_cert.pem /home/vps/public_html/${DOMAIN}_IKEV2-EAP-CA.pem
echo "Done"
echo "Reboot on 3sec"
sleep 3
reboot
        fi
    elif [[ "$method" == "2" ]]; then
        echo "Listing all zip files in /root directory..."
        files=$(ls /root/ | grep 'backup.zip')
        if [[ -z "$files" ]]; then
            echo "No zip files found in /root!"
            exit 1
        fi
        select zipfile in $files; do
            if [[ -n "$zipfile" ]]; then
                echo "Selected: $zipfile"
                cp "$zipfile" /root/backup.zip
# BAGIAN UNZIP
# UNZIP DARI HASIL PILIHAN USER
unzip -P backup.zip
rm -f backup.zip
sleep 1
echo "Start Restore"
cd /root/backup
cp -r xray /etc/
cp -r v2ray /etc/
cp -r premium-script /var/lib/
cp -r public_html /home/vps/
cp -r private /etc/ssl/
cp -r william /etc/
cp -r slowdns /etc/william/
cp -r conf.d /etc/nginx/
cp passwd /etc/
cp group /etc/
cp gshadow /etc/
cp shadow /etc/
cp ssh.json /usr/local/etc/xray/
cp cdn.service /etc/systemd/system/
cp chap-secrets /etc/ppp/
cp passwd1 /etc/ipsec.d/passwd
cp log-install.txt /root/
cp issue.net /etc/
#
# DATA SERVER
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data_server.json
cat /usr/local/etc/xray/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data_server.json
cat /usr/local/etc/xray/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data_server.json
cat /usr/local/etc/xray/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data_server.json

# DATA BACKUP
cat /root/backup/config.json | grep -w -A 1 "TrojanWS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "Vmess-TCP " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmesstcp_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessWS-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanUPGRADE-TLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojanupgrade_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "TrojanGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojangrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VlessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessgrpc_tls_data.json 2>/dev/null
cat /root/backup/config.json | grep -w -A 1 "VmessGRPC " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessgrpc_tls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessWS-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessws_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VmessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vmessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/none.json | grep -w -A 1 "VlessUPGRADE-NTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessupgrade_ntls_data.json 2>/dev/null
cat /root/backup/will666.json | grep -w -A 1 "VlessXTLS " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/vlessxtls_data.json 2>/dev/null
cat /root/backup/will69.json | grep -w -A 1 "Trojan " | awk -v user="### $nameofuser" ' /^--$/ {if (block ~ user) {print block;exit}block = ""}{ block = block $0 ORS }END { if (block ~ user) print block }' | sed '$d' > /tmp/trojan_tcp_data.json 2>/dev/null

# GABUNGKAN SERVER & BACKUP
cat /tmp/trojanws_tls_data_server.json /tmp/trojanws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanws_tls_data.json 2>/dev/null
cat /tmp/vmesstcp_tls_data_server.json /tmp/vmesstcp_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmesstcp_tls_data.json 2>/dev/null
cat /tmp/vmessws_tls_data_server.json /tmp/vmessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_tls_data.json 2>/dev/null
cat /tmp/vlessws_tls_data_server.json /tmp/vlessws_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_tls_data.json 2>/dev/null
cat /tmp/vmessupgrade_tls_data_server.json /tmp/vmessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_tls_data.json 2>/dev/null
cat /tmp/vlessupgrade_tls_data_server.json /tmp/vlessupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_tls_data.json 2>/dev/null
cat /tmp/trojanupgrade_tls_data_server.json /tmp/trojanupgrade_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojanupgrade_tls_data.json 2>/dev/null
cat /tmp/trojangrpc_tls_data_server.json /tmp/trojangrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojangrpc_tls_data.json 2>/dev/null
cat /tmp/vlessgrpc_tls_data_server.json /tmp/vlessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessgrpc_tls_data_server.json /tmp/vmessgrpc_tls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessgrpc_tls_data.json 2>/dev/null
cat /tmp/vmessws_ntls_data_server.json /tmp/vmessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessws_ntls_data.json 2>/dev/null
cat /tmp/vlessws_ntls_data_server.json /tmp/vlessws_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessws_ntls_data.json 2>/dev/null
cat /tmp/vmessupgrade_ntls_data_server.json /tmp/vmessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vmessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessupgrade_ntls_data_server.json /tmp/vlessupgrade_ntls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessupgrade_ntls_data.json 2>/dev/null
cat /tmp/vlessxtls_data_server.json /tmp/vlessxtls_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_vlessxtls_data.json 2>/dev/null
cat /tmp/trojan_tcp_data_server.json /tmp/trojan_tcp_data.json 2>/dev/null | awk '!seen[$0]++' > /tmp/hasil_trojan_tcp_data.json 2>/dev/null
#pisahin
cp /usr/local/etc/xray/config.json /tmp/backup_config.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will666.json
cp /usr/local/etc/xray/will666.json /tmp/backup_will69.json
cp /usr/local/etc/xray/none.json /tmp/backup_none.json
rm -rf /usr/local/etc/xray/config.json
rm -rf /usr/local/etc/xray/will666.json
rm -rf /usr/local/etc/xray/none.json
#
wget -q https://raw.githubusercontent.com/scriptvpskita/x/refs/heads/main/crot/crot/crot/crot/crot/crot/crott.sh && chmod +x crott.sh && ./crott.sh
#
sed -i "/^#trojanws$/ r /tmp/hasil_trojanws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmesstcp$/ r /tmp/hasil_vmesstcp_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessws$/ r /tmp/hasil_vmessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessws$/ r /tmp/hasil_vlessws_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessupgrade$/ r /tmp/hasil_vmessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessupgrade$/ r /tmp/hasil_vlessupgrade_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#trojanupgrade$/ r /tmp/hasil_trojanupgrade_tls_data.json" /usr/local/etc/xray/config.json
# grpc on config.json
sed -i "/^#trojanGRPCX$/ r /tmp/hasil_trojangrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vmessGRPCX$/ r /tmp/hasil_vmessgrpc_tls_data.json" /usr/local/etc/xray/config.json
sed -i "/^#vlessGRPCX$/ r /tmp/hasil_vlessgrpc_tls_data.json" /usr/local/etc/xray/config.json
# tls on will666.json
sed -i "/^#vlessxtls$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/will666.json
# tls on will69.json
sed -i "/^#trojantcp$/ r /tmp/hasil_trojantcp_data.json" /usr/local/etc/xray/will69.json
# ntls on none.json
sed -i "/^#vmessWS$/ r /tmp/hasil_vmessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessWS$/ r /tmp/hasil_vlessws_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vmessUPGRADE$/ r /tmp/hasil_vmessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
sed -i "/^#vlessUPGRADE$/ r /tmp/hasil_vlessupgrade_ntls_data.json" /usr/local/etc/xray/none.json
#
cd /root
rm -rf /root/backup
rm -rf backup.zip
/etc/william/slowdns/./dns-server -gen-key -privkey-file /etc/william/slowdns/server.key -pubkey-file /etc/william/slowdns/server.pub
systemctl restart stunnel5
systemctl restart cdn
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart slowdns
systemctl restart udp-custom
sleep 1
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn
cp /etc/openvpn/client-tcp-ssl-442.ovpn /home/vps/public_html/client-tcp-ssl-442.ovpn
cp /etc/ipsec.d/cacerts/vpn_ca_cert.pem /home/vps/public_html/${DOMAIN}_IKEV2-EAP-CA.pem
echo "Done"
echo "Reboot on 3sec"
sleep 3
reboot
            else
                echo "Invalid selection. Try again."
            fi
        done
    else
        echo "Invalid method selected. Exiting."
        exit 1
    fi
else
    echo "Invalid option selected. Exiting."
    exit 1
fi