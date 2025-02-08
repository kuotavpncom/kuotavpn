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
repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
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

DOMAIN=$(cat /etc/xray/domain);
DOMAINXRAY=$(cat /etc/xray/domain);
nsdomain=$(cat /etc/ns/domain);
fileCN=$(cat /etc/xray/certinfo.crt);
if [ -z "$fileCN" ]; then
status="${red}OFF$NC"
else
status="${green}ON$NC"
fi
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   [1]  Change/Add New Domain + Include Renew Cert"
echo -e "    +  Your Domain IS $green$DOMAIN $NC"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   [2]  Change/Add New NS Domain"
echo -e "    +  Your NS Domain IS $green$nsdomain $NC"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   [3]  Hide Your CN"
echo -e "    +  STATUS: $status"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   [x]  Kembali Ke Menu"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-3 or x] :  " prot
echo -e ""
case $prot in
1)
read -rp "Domain/Host: " -e host
echo -e "$green Starting..... $NC"
sleep 2
LOOKUP=$(nslookup "$host" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | grep "$MYIP" | cut -d " " -f 2);
echo "Please Wait, We Will Check Your Domain"
sleep 2
if [[ $MYIP = $LOOKUP ]]; then
echo -e "$green Domain is Valid And Pointed To $MYIP $NC"
else
echo -e "$red UPS ! looks like the domain you entered is not valid"
echo -e "$red please recheck the domain you entered is correct"
echo -e "$red please point the domain to ip and try again $NC"
exit 0
fi
echo -e "$green Starting Added Subdomain And Renew Cert.... $NC"
sleep 2
source ~/.bashrc
if nc -z localhost 80;then
echo -e "Starting To Stop Port 80 Before Continue"
echo -e "Please Wait..."
sleep 2
awikwok=$(netstat -ntlulp | grep -w "80" | awk {'print $7'} | cut -d "/" -f 2 | sed 's/://g' | sort | uniq);
systemctl stop $awikwok > /dev/null 2>&1
systemctl stop $awikwok@none > /dev/null 2>&1
echo -e "${green}success stop port 80${NC}"
fi
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $host --standalone --keylength ec-384 --force
~/.acme.sh/acme.sh --install-cert -d $host --ecc --fullchain-file /etc/ssl/private/fullchain.pem --key-file /etc/ssl/private/privkey.pem
chown -R nobody:nogroup /etc/ssl/private/
chmod 777 /etc/ssl/private/
chmod +x /etc/ssl/private/fullchain.pem
chmod +x /etc/ssl/private/privkey.pem
echo $host > /etc/xray/domain
echo $host > /etc/v2ray/domain
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
sed -i "s/$DOMAINXRAY/$host/g" /usr/local/etc/xray/none.json
sed -i "s/$DOMAINXRAY/$host/g" /usr/local/etc/xray/config.json
sed -i "s/$DOMAINXRAY/$host/g" /etc/nginx/conf.d/alone.conf
sed -i "s/$DOMAINXRAY/$host/g" /etc/nginx/conf.d/vmnone.conf
sed -i "s/$DOMAINXRAY/$host/g" /etc/nginx/conf.d/vlnone.conf
clear
echo -e "$green Successfully Added New Domain And Renew Cert $NC"
systemctl start $awikwok > /dev/null 2>&1
systemctl start $awikwok@none > /dev/null 2>&1
systemctl restart $awikwok > /dev/null 2>&1
systemctl restart $awikwok@none > /dev/null 2>&1
systemctl restart will69 > /dev/null 2>&1
systemctl restart will666 > /dev/null 2>&1
systemctl restart nginx
echo -e "$green Successfully Start Port 80 $NC"
;;
2)
old=$(cat /etc/ns/domain)
clear
echo -e "   $red Please Read This Carefully $NC"
echo -e "   IF You Dont Know What You Are Doing. Please ${red}Stop !${NC}"
echo -e "   Changing the NS DOMAIN incorrectly will result in ${red}SLOWDNS${NC} not working properly"
echo ""
read -p "Input Your New NS Domain : " new
echo -e "$green Starting..... $NC"
sleep 2
sed -i "s/$old/$new/g" /etc/systemd/system/slowdns.service
echo $new > /etc/ns/domain
systemctl daemon-reload
sleep 1
systemctl restart slowdns.service
clear
echo -e "$green Successfully Added New NS Domain $NC"
;;
3)
if [ -n "$fileCN" ]; then
echo -e "TURN OFF HIDE CN"
echo -e "PLEASE WAIT......."
cp /etc/xray/certinfo.crt /etc/ssl/private/fullchain.pem
cp /etc/xray/certinfo.key /etc/ssl/private/privkey.pem
rm -rf /etc/xray/certinfo.crt
rm -rf /etc/xray/certinfo.key
systemctl restart xray
systemctl restart will666
systemctl restart will69
systemctl restart nginx
echo -e "OKE SUKSES TURN OFF HIDE CN"
else
echo -e "STARTING HIDE YOUR CN TO PROTECT FROM SOME SCANNER METHODS"
echo -e "PLEASE WAIT......."
sleep 3
cp /etc/ssl/private/fullchain.pem /etc/xray/certinfo.crt
cp /etc/ssl/private/privkey.pem /etc/xray/certinfo.key
wget --no-check-certificate -q -O /etc/ssl/private/fullchain.pem "https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/crot.crt"
wget --no-check-certificate -q -O /etc/ssl/private/privkey.pem "https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/crot.key"
systemctl restart xray
systemctl restart will666
systemctl restart will69
systemctl restart nginx
echo -e "HIDE CN ACTIVE"
fi
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac