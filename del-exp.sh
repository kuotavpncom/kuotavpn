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

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
data=( `cat /var/lib/premium-script/data-user-l2tp | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/var/lib/premium-script/data-user-l2tp" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/var/lib/premium-script/data-user-l2tp"
sed -i '/^"'"$user"'" l2tpd/d' /etc/ppp/chap-secrets
sed -i '/^'"$user"':\$1\$/d' /etc/ipsec.d/passwd
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
fi
done
data=( `cat /usr/local/etc/xray/config.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3)
if ! [[ "$exp" =~ ^[0-9]+$ ]]; then
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -lt "0" ]]; then
echo -e "${red}User Expired :${NC} ${user} ${exp}"
sed -i "/^### $user $exp/,+1d" /usr/local/etc/xray/config.json
sed -i "/^### $user $exp/,+1d" /etc/cf-argo/config.json
#tls
rm -rf /etc/usage/vlesswstls-downlink/${user}
rm -rf /etc/usage/vlesswstls-uplink/${user}
rm -rf /etc/william/limit-xray/vlessws/${user}
rm -rf /etc/usage/vlessxtls-downlink/${user}
rm -rf /etc/usage/vlessxtls-uplink/${user}
rm -rf /etc/usage/vlessgrpctls-downlink/${user}
rm -rf /etc/usage/vlessgrpctls-uplink/${user}
rm -rf /etc/usage/vmesswstls-downlink/${user}
rm -rf /etc/usage/vmesswstls-uplink/${user}
rm -rf /etc/william/limit-xray/vmessws/${user}
rm -rf /etc/usage/vmessgrpctls-uplink/${user}
rm -rf /etc/usage/vmessgrpctls-downlink/${user}
rm -rf /etc/usage/vmesstcphttp-uplink/${user}
rm -rf /etc/usage/vmesstcphttp-downlink/${user}
rm -rf /etc/usage/trojanws-uplink/${user}
rm -rf /etc/usage/trojanws-downlink/${user}
rm -rf /etc/william/limit-xray/trojanws/${user}
rm -rf /etc/usage/trojan-uplink/${user}
rm -rf /etc/usage/trojan-downlink/${user}
rm -rf /etc/usage/trojangrpctls-uplink/${user}
rm -rf /etc/usage/trojangrpctls-downlink/${user}
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
rm -rf /etc/william/limit-quota/$user
#user
rm -rf /etc/xray/vmess/$user-tls.json
rm -rf /etc/xray/vmess/$user-tcp.json
rm -rf /etc/xray/vmess/$user-none.json
rm -rf /etc/xray/vmess/$user-grpc.json
fi
fi
done
data=( `cat /usr/local/etc/xray/will666.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/will666.json" | cut -d ' ' -f 3)
if ! [[ "$exp" =~ ^[0-9]+$ ]]; then
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -lt "0" ]]; then
echo -e "${red}User Expired :${NC} ${user} ${exp}"
sed -i "/^### $user $exp/,/^,{/d" /usr/local/etc/xray/will666.json
fi
fi
done
data=( `cat /usr/local/etc/xray/will69.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/will69.json" | cut -d ' ' -f 3)
if ! [[ "$exp" =~ ^[0-9]+$ ]]; then
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -lt "0" ]]; then
echo -e "${red}User Expired :${NC} ${user} ${exp}"
sed -i "/^### $user $exp/,/^,{/d" /usr/local/etc/xray/will69.json
rm -rf /etc/usage/trojan-downlink/${user}
rm -rf /etc/usage/trojan-uplink/${user}
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
rm -rf /etc/william/limit-quota/$user
nyari=$(find /home/vps/public_html/config | grep -w "$user")
for anu in "${nyari[@]}"
do
rm -rf $anu
done
fi
fi
done
data=( `cat /usr/local/etc/xray/none.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/etc/xray/none.json" | cut -d ' ' -f 3)
if ! [[ "$exp" =~ ^[0-9]+$ ]]; then
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -lt "0" ]]; then
echo -e "${red}User Expired :${NC} ${user} ${exp}"
sed -i "/^### $user $exp/,+1d" /usr/local/etc/xray/none.json
sed -i "/^### $user $exp/,+1d" /etc/cf-argo/config.json
#ntls
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
rm -f /etc/xray/vmess/$user-tls.json /etc/xray/vmess/$user-none.json
rm -rf /etc/william/limit-xray/vmessws/${user}
rm -rf /etc/william/limit-xray/vlessws/${user}
rm -rf /etc/xray/usage-uplink-tls/${user}
rm -rf /etc/xray/usage-downlink-tls/${user}
rm -rf /etc/xray/usage-uplink-ntls/${user}
rm -rf /etc/xray/usage-downlink-ntls/${user}
rm -rf /etc/william/limit-quota/$user
fi
fi
done
clear
hariini=`date +%d-%m-%Y`
echo "Thank you for removing the EXPIRED USERS"
echo "--------------------------------------"
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
username=`echo $tuserval | cut -f1 -d:`
userexp=`echo $tuserval | cut -f2 -d:`
userexpireinseconds=$(( $userexp * 86400 ))
tglexp=`date -d @$userexpireinseconds`             
tgl=`echo $tglexp |awk -F" " '{print $3}'`
while [ ${#tgl} -lt 2 ]
do
tgl="0"$tgl
done
while [ ${#username} -lt 15 ]
do
username=$username" " 
done
bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
echo "echo "Expired- User : $username Expire at : $tgl $bulantahun"" >> /usr/local/bin/alluser
todaystime=`date +%s`
if [ $userexpireinseconds -ge $todaystime ] ;
then
:
else
echo "echo "Expired- Username : $username are expired at: $tgl $bulantahun and removed : $hariini "" >> /usr/local/bin/deleteduser
echo "Username $username that are expired at $tgl $bulantahun removed from the VPS $hariini"
userdel -f $username
sed -i "/${username} >/d" /etc/william/udp/udp.conf
sed -i "/${username}/d" /etc/william/udp/listbanned-ssh.conf
fi
done
echo " "
echo "--------------------------------------"
echo "Script are successfully run"
systemctl restart udp-custom
systemctl restart dropbear
systemctl restart stunnel5
systemctl restart xray
systemctl restart xray@none
systemctl restart will69
systemctl restart will666
systemctl restart argo-xray