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

ARGO_DOMAIN_SSH=$(cat /etc/cf-argo/argo2_domain)
DOMAIN=$(cat /etc/xray/domain);
nsdomain=$(cat /etc/ns/domain);
pubkey=$(cat /etc/william/slowdns/server.pub);
alternatifportntls=$(cat /etc/nginx/conf.d/vmnone.conf | grep listen | sed -n '1,$p' | awk '{printf $2 ", "; if(NR==FNR) printf ""}' | sed 's/ 69, 55//g' | sed '$s/, $/./' | sed 's/\(.*\),/\1/' | sed 's/127.0.0.1:21408,//g')
ngecek=$(cat /etc/systemd/system/slowdns.service | grep -o "22")
clear
IP=$(wget -qO- ipinfo.io/ip);
tls="$(cat ~/log-install.txt | grep -w "XRAY TLS" | cut -d: -f2|sed 's/ //g')"
ssl2="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d " " -f 22|sed 's/,//g')"
ws="$(cat ~/log-install.txt | grep -w "SSHWS" | cut -d: -f2|sed 's/ //g')"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpnssl="$(cat ~/log-install.txt | grep -w "OpenVPN SSL" | cut -d: -f2|sed 's/ //g')"
ovpnws="$(cat ~/log-install.txt | grep -w "OpenVPN WS" | cut -d: -f2|sed 's/ //g')"
current_user=$(cat /etc/william/udp/config.json | grep -o '"user": "[^"]*' | sed 's/"user": "//')
echo ""
Login=trial69`</dev/urandom tr -dc X-Z0-9 | head -c5`
echo "random user : $Login"
read -p "Expired (1-5 hours): " expuser
case $expuser in
    1)
        exp=$(date -d "+60 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    2)
        exp=$(date -d "+120 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    3)
        exp=$(date -d "+180 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    4)
        exp=$(date -d "+240 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    5)
        exp=$(date -d "+300 minutes" +%s)
        echo "Expired ON: $expuser hour"
        ;;
    *)
        echo "Invalid choice. Please enter a number between 1 and 4."
        exit
        ;;
esac
echo -e "$Login » $exp" >> /usr/local/etc/xray/ssh.json
Pass=1
echo Membuat Akun: $Login
sleep 0.5
echo Setting Password: $Pass
sleep 0.5
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e "${Login} > ${Pass}" >> /etc/william/udp/udp.conf
echo -e ""
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "INFORMASI TRIAL"
echo -e "SSH & OVPN ACCOUNT"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "IP-Addres : $MYIP"
echo -e "Hostname : $DOMAIN"
echo -e "Username : $Login"
echo -e "Password : $Pass"
if [[ -n $ARGO_DOMAIN_SSH ]]; then
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Argo SSH Domain : $ARGO_DOMAIN_SSH"
echo -e "Argo HTTP PORT : 80, 8080, 8880, 2052, 2082, 2086, 2095"
echo -e "Argo HTTPS PORT : 443, 2053, 2083, 2087, 2096, 8443"
fi
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Port openssh : 22, $tls"
echo -e "Port dropbear : 109, 143, $tls"
echo -e "Port ssh udp : 1-65535"
echo -e "Port stunnel : $tls, "
echo -e "Port ssh websocket http : $ws"
echo -e "Alternatif port ovpn & ssh websocket http : $alternatifportntls"
echo -e "Port ssh websocket https : $ssl2"
echo -e "Port ovpn websocket http : $ovpnws"
echo -e "Port squid : 2086, 3128"
echo -e "Port badvpn/udpgw : 7100-7300"
if [[ "$ngecek" = "22" ]]; then
echo -e "DNS Hostname : $nsdomain"
echo -e "Pub key slowdns : $pubkey"
echo -e "Dns for slowdns : 1.1.1.1 / 8.8.8.8"
fi
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "OPENVPN TCP : $ovpn http://$DOMAIN:8081/client-tcp-$ovpn.ovpn"
echo -e "OPENVPN TCP : $tls http://$DOMAIN:8081/client-tcp-$tls.ovpn"
echo -e "OPENVPN UDP : $ovpn2 http://$DOMAIN:8081/client-udp-$ovpn2.ovpn"
echo -e "OPENVPN SSL : $ovpnssl http://$DOMAIN:8081/client-tcp-ssl-$ovpnssl.ovpn"
echo -e "ALL OPENVPN CONFIG : http://$DOMAIN:8081/openvpn.zip"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Payload SSH WS : GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf]Upgrade: Websocket[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf][crlf]"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Payload OVPN WS : GET /ovpn HTTP/1.1[crlf]Host: $DOMAIN[crlf]Upgrade: Websocket[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf][crlf]"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Payload WS ENHANCED : PATCH / HTTP/1.1[crlf]Host: [host][crlf]Host: ISI_BUG_DISINI[crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "Expired on : $expuser hour"
systemctl restart udp-custom