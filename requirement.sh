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
IP=$(curl -sS ipinfo.io/ip) 
repogithub='kuotavpncom/kuotavpn/main'
repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.kuotavpn.com/ZGFmdGFySVA/${IP}'
  curl -s "https://www.kuotavpn.com/ZGFmdGFySVA/${IP}" -o /tmp/permission.txt
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

cd /usr/bin
wget --no-check-certificate -q -O bundling-trial-vmess "https://raw.githubusercontent.com/$repogithub/bundling-trial-vmess.sh"
wget --no-check-certificate -q -O bundling-trial-vless "https://raw.githubusercontent.com/$repogithub/bundling-trial-vless.sh"
wget --no-check-certificate -q -O bundling-trial-tr "https://raw.githubusercontent.com/$repogithub/bundling-trial-tr.sh"
wget --no-check-certificate -q -O menu2 "https://raw.githubusercontent.com/$repogithub/menu2.sh"
wget --no-check-certificate -q -O del-exp "https://raw.githubusercontent.com/$repogithub/del-exp.sh"
wget --no-check-certificate -q -O del-texp "https://raw.githubusercontent.com/$repogithub/del-texp.sh"
#wget --no-check-certificate -q -O menu "https://raw.githubusercontent.com/$repogithub/menu.sh"
wget --no-check-certificate -q -O menu-ssh "https://raw.githubusercontent.com/$repogithub/menu-ssh.sh"
wget --no-check-certificate -q -O menu-tr "https://raw.githubusercontent.com/$repogithub/menu-tr.sh"
wget --no-check-certificate -q -O menu-trgrpc "https://raw.githubusercontent.com/$repogithub/menu-trgrpc.sh"
wget --no-check-certificate -q -O menu-trws "https://raw.githubusercontent.com/$repogithub/menu-trws.sh"
wget --no-check-certificate -q -O menu-vless "https://raw.githubusercontent.com/$repogithub/menu-vless.sh"
wget --no-check-certificate -q -O menu-vlessgrpc "https://raw.githubusercontent.com/$repogithub/menu-vlessgrpc.sh"
wget --no-check-certificate -q -O menu-vlessxtls "https://raw.githubusercontent.com/$repogithub/menu-vlessxtls.sh"
wget --no-check-certificate -q -O menu-vmess "https://raw.githubusercontent.com/$repogithub/menu-vmess.sh"
wget --no-check-certificate -q -O menu2 "https://raw.githubusercontent.com/$repogithub/new-menu.sh"
wget --no-check-certificate -q -O menu "https://raw.githubusercontent.com/$repogithub/new-menu.sh"
echo -e "PROSES...."
wget --no-check-certificate -q -O menu-vmessgrpc "https://raw.githubusercontent.com/$repogithub/menu-vmessgrpc.sh"
wget --no-check-certificate -q -O menu-vmesstcp "https://raw.githubusercontent.com/$repogithub/menu-vmesstcp.sh"
wget --no-check-certificate -q -O add-ssh "https://raw.githubusercontent.com/$repogithub/add-ssh.sh"
wget --no-check-certificate -q -O trial-ssh "https://raw.githubusercontent.com/$repogithub/trial-ssh.sh"
wget --no-check-certificate -q -O hapus "https://raw.githubusercontent.com/$repogithub/hapus.sh"
wget --no-check-certificate -q -O renew "https://raw.githubusercontent.com/$repogithub/renew.sh"
wget --no-check-certificate -q -O add-vmess "https://raw.githubusercontent.com/$repogithub/add-vmess.sh"
wget --no-check-certificate -q -O trial-vmess "https://raw.githubusercontent.com/$repogithub/trial-vmess.sh"
wget --no-check-certificate -q -O add-vless "https://raw.githubusercontent.com/$repogithub/add-vless.sh"
wget --no-check-certificate -q -O trial-vless "https://raw.githubusercontent.com/$repogithub/trial-vless.sh"
wget --no-check-certificate -q -O add-trws "https://raw.githubusercontent.com/$repogithub/add-trws.sh"
wget --no-check-certificate -q -O trial-trws "https://raw.githubusercontent.com/$repogithub/trial-trws.sh"
wget --no-check-certificate -q -O add-vmesstcp "https://raw.githubusercontent.com/$repogithub/add-vmesstcp.sh"
wget --no-check-certificate -q -O trial-vmesstcp "https://raw.githubusercontent.com/$repogithub/trial-vmesstcp.sh"
wget --no-check-certificate -q -O add-vlessxtls "https://raw.githubusercontent.com/$repogithub/add-vlessxtls.sh"
wget --no-check-certificate -q -O trial-vlessxtls "https://raw.githubusercontent.com/$repogithub/trial-vlessxtls.sh"
wget --no-check-certificate -q -O add-tr "https://raw.githubusercontent.com/$repogithub/add-tr.sh"
wget --no-check-certificate -q -O trial-tr "https://raw.githubusercontent.com/$repogithub/trial-tr.sh"
wget --no-check-certificate -q -O add-trgrpc "https://raw.githubusercontent.com/$repogithub/add-trgrpc.sh"
wget --no-check-certificate -q -O trial-trgrpc "https://raw.githubusercontent.com/$repogithub/trial-trgrpc.sh"
wget --no-check-certificate -q -O add-vmessgrpc "https://raw.githubusercontent.com/$repogithub/add-vmessgrpc.sh"
wget --no-check-certificate -q -O trial-vmessgrpc "https://raw.githubusercontent.com/$repogithub/trial-vmessgrpc.sh"
wget --no-check-certificate -q -O add-vlessgrpc "https://raw.githubusercontent.com/$repogithub/add-vlessgrpc.sh"
wget --no-check-certificate -q -O trial-vlessgrpc "https://raw.githubusercontent.com/$repogithub/trial-vlessgrpc.sh"
wget --no-check-certificate -q -O clear-log "https://raw.githubusercontent.com/$repogithub/clear-log.sh"
wget --no-check-certificate -q -O cek-xray "https://raw.githubusercontent.com/$repogithub/cek-xray.sh"
wget --no-check-certificate -q -O change-port "https://raw.githubusercontent.com/$repogithub/change-port.sh"
wget --no-check-certificate -q -O force-host "https://raw.githubusercontent.com/$repogithub/force-host.sh"
wget --no-check-certificate -q -O backup-bot "https://raw.githubusercontent.com/$repogithub/backup-bot.sh"
wget --no-check-certificate -q -O bckp-bot "https://raw.githubusercontent.com/$repogithub/bckp-bot.sh"
wget --no-check-certificate -q -O traffic-xraytls "https://raw.githubusercontent.com/$repogithub/traffic-xraytls.sh"
wget --no-check-certificate -q -O traffic-xrayntls "https://raw.githubusercontent.com/$repogithub/traffic-xrayntls.sh"
wget --no-check-certificate -q -O update-kernel "https://raw.githubusercontent.com/$repogithub/update-kernel.sh"
wget --no-check-certificate -q -O fix-kernel-cloud "https://raw.githubusercontent.com/$repogithub/fix-kernel-cloud.sh"
wget --no-check-certificate -q -O auto-sendcreated "https://raw.githubusercontent.com/$repogithub/auto-sendcreated.sh"
wget --no-check-certificate -q -O auto-sendtrial "https://raw.githubusercontent.com/$repogithub/auto-sendvpn.sh"
wget --no-check-certificate -q -O auto-sendall "https://raw.githubusercontent.com/$repogithub/auto-sendall.sh"
wget --no-check-certificate -q -O del-tr "https://raw.githubusercontent.com/$repogithub/del-tr.sh"
wget --no-check-certificate -q -O del-trws "https://raw.githubusercontent.com/$repogithub/del-trws.sh"
wget --no-check-certificate -q -O del-vless "https://raw.githubusercontent.com/$repogithub/del-vless.sh"
wget --no-check-certificate -q -O del-vlessxtls "https://raw.githubusercontent.com/$repogithub/del-vlessxtls.sh"
wget --no-check-certificate -q -O del-vmess "https://raw.githubusercontent.com/$repogithub/del-vmess.sh"
wget --no-check-certificate -q -O del-vmesstcp "https://raw.githubusercontent.com/$repogithub/del-vmesstcp.sh"
wget --no-check-certificate -q -O detail-tr "https://raw.githubusercontent.com/$repogithub/detail-tr.sh"
wget --no-check-certificate -q -O detail-trws "https://raw.githubusercontent.com/$repogithub/detail-trws.sh"
wget --no-check-certificate -q -O detail-vless "https://raw.githubusercontent.com/$repogithub/detail-vless.sh"
wget --no-check-certificate -q -O detail-vlessxtls "https://raw.githubusercontent.com/$repogithub/detail-vlessxtls.sh"
wget --no-check-certificate -q -O detail-vmess "https://raw.githubusercontent.com/$repogithub/detail-vmess.sh"
wget --no-check-certificate -q -O detail-vmesstcp "https://raw.githubusercontent.com/$repogithub/detail-vmesstcp.sh"
wget --no-check-certificate -q -O detail-vmessgrpc "https://raw.githubusercontent.com/$repogithub/detail-vmessgrpc.sh"
wget --no-check-certificate -q -O detail-vlessgrpc "https://raw.githubusercontent.com/$repogithub/detail-vlessgrpc.sh"
wget --no-check-certificate -q -O detail-trgrpc "https://raw.githubusercontent.com/$repogithub/detail-trgrpc.sh"
wget --no-check-certificate -q -O renew-tr "https://raw.githubusercontent.com/$repogithub/renew-tr.sh"
wget --no-check-certificate -q -O renew-trws "https://raw.githubusercontent.com/$repogithub/renew-trws.sh"
wget --no-check-certificate -q -O renew-vless "https://raw.githubusercontent.com/$repogithub/renew-vless.sh"
wget --no-check-certificate -q -O renew-vlessxtls "https://raw.githubusercontent.com/$repogithub/renew-vlessxtls.sh"
wget --no-check-certificate -q -O renew-vmess "https://raw.githubusercontent.com/$repogithub/renew-vmess.sh"
wget --no-check-certificate -q -O renew-vmesstcp "https://raw.githubusercontent.com/$repogithub/renew-vmesstcp.sh"
wget --no-check-certificate -q -O restart "https://raw.githubusercontent.com/$repogithub/restart.sh"
echo "MASIH PROSES HEHE..."
wget --no-check-certificate -q -O auto-certxray "https://raw.githubusercontent.com/$repogithub/auto-certxray.sh"
wget --no-check-certificate -q -O update-version "https://raw.githubusercontent.com/$repogithub/update-version.sh"
wget --no-check-certificate -q -O path-trws "https://raw.githubusercontent.com/$repogithub/path-trws.sh"
wget --no-check-certificate -q -O path-vless "https://raw.githubusercontent.com/$repogithub/path-vless.sh"
wget --no-check-certificate -q -O path-vmess "https://raw.githubusercontent.com/$repogithub/path-vmess.sh"
wget --no-check-certificate -q -O path-vmesstcp "https://raw.githubusercontent.com/$repogithub/path-vmesstcp.sh"
wget --no-check-certificate -q -O path-vmessgrpc "https://raw.githubusercontent.com/$repogithub/path-vmessgrpc.sh"
wget --no-check-certificate -q -O path-vlessgrpc "https://raw.githubusercontent.com/$repogithub/path-vlessgrpc.sh"
wget --no-check-certificate -q -O path-trgrpc "https://raw.githubusercontent.com/$repogithub/path-trgrpc.sh"
wget --no-check-certificate -q -O renew-vmessgrpc "https://raw.githubusercontent.com/$repogithub/renew-vmessgrpc.sh"
wget --no-check-certificate -q -O del-vmessgrpc "https://raw.githubusercontent.com/$repogithub/del-vmessgrpc.sh"
wget --no-check-certificate -q -O del-vlessgrpc "https://raw.githubusercontent.com/$repogithub/del-vlessgrpc.sh"
wget --no-check-certificate -q -O renew-vlessgrpc "https://raw.githubusercontent.com/$repogithub/renew-vlessgrpc.sh"
wget --no-check-certificate -q -O del-trgrpc "https://raw.githubusercontent.com/$repogithub/del-trgrpc.sh"
wget --no-check-certificate -q -O renew-trgrpc "https://raw.githubusercontent.com/$repogithub/renew-trgrpc.sh"
wget --no-check-certificate -q -O menu-bundling "https://raw.githubusercontent.com/$repogithub/menu-bundling.sh"
wget --no-check-certificate -q -O bundling-vmess "https://raw.githubusercontent.com/$repogithub/bundling-vmess.sh"
wget --no-check-certificate -q -O bundling-vless "https://raw.githubusercontent.com/$repogithub/bundling-vless.sh"
wget --no-check-certificate -q -O bundling-tr "https://raw.githubusercontent.com/$repogithub/bundling-tr.sh"
wget --no-check-certificate -q -O change-slowdns "https://raw.githubusercontent.com/$repogithub/change-slowdns.sh"
wget --no-check-certificate -q -O menu-l2tp "https://raw.githubusercontent.com/$repogithub/menu-l2tp.sh"
wget --no-check-certificate -q -O add-l2tp "https://raw.githubusercontent.com/$repogithub/add-l2tp.sh"
wget --no-check-certificate -q -O del-l2tp "https://raw.githubusercontent.com/$repogithub/del-l2tp.sh"
#wget --no-check-certificate -q -O cek-l2tp "https://raw.githubusercontent.com/$repogithub/cek-l2tp.sh"
wget --no-check-certificate -q -O renew-l2tp "https://raw.githubusercontent.com/$repogithub/renew-l2tp.sh"
wget --no-check-certificate -q -O change-user-udp "https://raw.githubusercontent.com/$repogithub/change-user-udp.sh"
wget --no-check-certificate -q -O change-alt-port "https://raw.githubusercontent.com/$repogithub/change-alt-port.sh"
wget --no-check-certificate -q -O backup "https://raw.githubusercontent.com/$repogithub/backup.sh"
wget --no-check-certificate -q -O bckp "https://raw.githubusercontent.com/$repogithub/bckp.sh"
wget --no-check-certificate -q -O restore "https://raw.githubusercontent.com/$repogithub/restore.sh"
wget --no-check-certificate -q -O warp "https://raw.githubusercontent.com/$repogithub/warp.sh"
wget --no-check-certificate -q -O change-uuid "https://raw.githubusercontent.com/$repogithub/change-uuid.sh"
wget --no-check-certificate -q -O ban-xray "https://raw.githubusercontent.com/$repogithub/evos.sh"
wget --no-check-certificate -q -O unban-xray "https://raw.githubusercontent.com/$repogithub/rrq.sh"
wget --no-check-certificate -q -O add-limit "https://raw.githubusercontent.com/$repogithub/onic.sh"
wget --no-check-certificate -q -O change-limit "https://raw.githubusercontent.com/$repogithub/alterego.sh"
wget --no-check-certificate -q -O change-limitbw "https://raw.githubusercontent.com/$repogithub/tlid.sh"
wget --no-check-certificate -q -O unban-ssh "https://raw.githubusercontent.com/$repogithub/bigetron.sh"
wget --no-check-certificate -q -O ban-ssh "https://raw.githubusercontent.com/$repogithub/blacklist.sh"
wget --no-check-certificate -q -O menu-trojanupgrade "https://raw.githubusercontent.com/$repogithub/menu-trojanupgrade.sh"
wget --no-check-certificate -q -O menu-vmessupgrade "https://raw.githubusercontent.com/$repogithub/menu-vmessupgrade.sh"
wget --no-check-certificate -q -O menu-vlessupgrade "https://raw.githubusercontent.com/$repogithub/menu-vlessupgrade.sh"
wget --no-check-certificate -q -O add-vmessupgrade "https://raw.githubusercontent.com/$repogithub/add-vmessupgrade.sh"
wget --no-check-certificate -q -O trial-vmessupgrade "https://raw.githubusercontent.com/$repogithub/trial-vmessupgrade.sh"
wget --no-check-certificate -q -O del-vmessupgrade "https://raw.githubusercontent.com/$repogithub/del-vmessupgrade.sh"
wget --no-check-certificate -q -O detail-vmessupgrade "https://raw.githubusercontent.com/$repogithub/detail-vmessupgrade.sh"
wget --no-check-certificate -q -O renew-vmessupgrade "https://raw.githubusercontent.com/$repogithub/renew-vmessupgrade.sh"
wget --no-check-certificate -q -O add-vlessupgrade "https://raw.githubusercontent.com/$repogithub/add-vlessupgrade.sh"
wget --no-check-certificate -q -O trial-vlessupgrade "https://raw.githubusercontent.com/$repogithub/trial-vlessupgrade.sh"
wget --no-check-certificate -q -O del-vlessupgrade "https://raw.githubusercontent.com/$repogithub/del-vlessupgrade.sh"
wget --no-check-certificate -q -O detail-vlessupgrade "https://raw.githubusercontent.com/$repogithub/detail-vlessupgrade.sh"
wget --no-check-certificate -q -O renew-vlessupgrade "https://raw.githubusercontent.com/$repogithub/renew-vlessupgrade.sh"
wget --no-check-certificate -q -O add-trojanupgrade "https://raw.githubusercontent.com/$repogithub/add-trojanupgrade.sh"
wget --no-check-certificate -q -O trial-trojanupgrade "https://raw.githubusercontent.com/$repogithub/trial-trojanupgrade.sh"
wget --no-check-certificate -q -O del-trojanupgrade "https://raw.githubusercontent.com/$repogithub/del-trojanupgrade.sh"
wget --no-check-certificate -q -O detail-trojanupgrade "https://raw.githubusercontent.com/$repogithub/detail-trojanupgrade.sh"
wget --no-check-certificate -q -O renew-trojanupgrade "https://raw.githubusercontent.com/$repogithub/renew-trojanupgrade.sh"
wget --no-check-certificate -q -O warp-advanced "https://raw.githubusercontent.com/$repogithub/warp-advanced.sh"
wget --no-check-certificate -q -O argo-setup "https://raw.githubusercontent.com/$repogithub/argo-setup.sh"
wget --no-check-certificate -q -O config-api "https://raw.githubusercontent.com/$repogithub/config-api.sh"
wget --no-check-certificate -q -O config-bot "https://raw.githubusercontent.com/$repogithub/config-bot.sh"
wget --no-check-certificate -q -O cek "https://raw.githubusercontent.com/osjekwknwjsk/awikwok/main/cek.sh"
echo "Waduh Kapan Kelar Ini....."
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
    wget --no-check-certificate -q -O change-uuidx "https://raw.githubusercontent.com/$repogithub/change-uuidx.sh"
    wget --no-check-certificate -q -O lock-ssh "https://raw.githubusercontent.com/$repogithub/locks.sh"
    wget --no-check-certificate -q -O unlock-ssh "https://raw.githubusercontent.com/$repogithub/unlocks.sh"
    wget --no-check-certificate -q -O lock-xray "https://raw.githubusercontent.com/$repogithub/lockx.sh"
    wget --no-check-certificate -q -O unlock-xray "https://raw.githubusercontent.com/$repogithub/unlockx.sh"
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
chmod +x warp-advanced
chmod +x menu-ssh
chmod +x menu-tr
chmod +x menu-trgrpc
chmod +x menu-trws
chmod +x menu-vless
chmod +x menu-vlessgrpc
chmod +x menu-vlessxtls
chmod +x menu-vmess
chmod +x menu-vmessgrpc
chmod +x menu-vmesstcp
chmod +x add-vmess
chmod +x trial-vmess
chmod +x add-vless
chmod +x trial-vless
chmod +x add-trws
chmod +x trial-trws
chmod +x add-vmesstcp
chmod +x trial-vmesstcp
chmod +x add-vlessxtls
chmod +x trial-vlessxtls
chmod +x add-tr
chmod +x trial-tr
chmod +x add-trgrpc
chmod +x trial-trgrpc
chmod +x add-vlessgrpc
chmod +x trial-vlessgrpc
chmod +x add-vmessgrpc
chmod +x trial-vmessgrpc
chmod +x clear-log
chmod +x cek-xray
chmod +x change-port
chmod +x menu2
chmod +x menu
chmod +x add-ssh
chmod +x trial-ssh
chmod +x force-host
chmod +x del-exp
chmod +x backup-bot
chmod +x bckp-bot
chmod +x update-kernel
chmod +x fix-kernel-cloud
chmod +x auto-sendcreated
chmod +x auto-sendtrial
chmod +x auto-sendall
chmod +x del-tr
chmod +x del-trws
chmod +x del-vless
chmod +x del-vlessxtls
chmod +x del-vmess
chmod +x del-vmesstcp
chmod +x detail-tr
chmod +x detail-trws
chmod +x detail-vless
chmod +x detail-vlessxtls
chmod +x detail-vmess
chmod +x detail-vmesstcp
chmod +x detail-vmessgrpc
chmod +x detail-vlessgrpc
chmod +x detail-trgrpc
chmod +x renew-tr
chmod +x renew-trws
chmod +x renew-vless
chmod +x renew-vlessxtls
chmod +x renew-vmess
chmod +x renew-vmesstcp
chmod +x restart
chmod +x auto-certxray
chmod +x path-trws
chmod +x path-vless
chmod +x path-vmess
chmod +x path-vmesstcp
chmod +x path-vmessgrpc
chmod +x path-vlessgrpc 
chmod +x path-trgrpc 
chmod +x update-version
chmod +x renew-vmessgrpc
chmod +x del-vmessgrpc
chmod +x del-vlessgrpc
chmod +x renew-vlessgrpc
chmod +x del-trgrpc
chmod +x renew-trgrpc
chmod +x menu-bundling
chmod +x bundling-vmess
chmod +x bundling-vless
chmod +x bundling-tr
chmod +x change-slowdns
chmod +x add-l2tp
chmod +x del-l2tp
#chmod +x cek-l2tp
chmod +x renew-l2tp
chmod +x menu-l2tp
chmod +x change-user-udp
chmod +x change-alt-port
chmod +x backup
chmod +x bckp
chmod +x restore
chmod +x warp
chmod +x change-uuid
chmod +x ban-xray
chmod +x unban-xray
chmod +x add-limit
chmod +x change-limit
chmod +x change-limitbw
chmod +x unban-ssh
chmod +x ban-ssh
chmod +x del-texp
chmod +x menu-trojanupgrade
chmod +x menu-vmessupgrade
chmod +x menu-vlessupgrade
chmod +x add-vmessupgrade
chmod +x trial-vmessupgrade
chmod +x del-vmessupgrade
chmod +x detail-vmessupgrade
chmod +x renew-vmessupgrade
chmod +x add-vlessupgrade
chmod +x trial-vlessupgrade
chmod +x del-vlessupgrade
chmod +x detail-vlessupgrade
chmod +x renew-vlessupgrade
chmod +x add-trojanupgrade
chmod +x trial-trojanupgrade
chmod +x del-trojanupgrade
chmod +x detail-trojanupgrade
chmod +x renew-trojanupgrade
chmod +x bundling-trial-vmess
chmod +x bundling-trial-vless
chmod +x bundling-trial-tr
chmod +x cek
chmod +x argo-setup
chmod +x config-api
chmod +x config-bot
chmod +x change-uuidx
chmod +x hapus
chmod +x renew
chmod +x lock-ssh
chmod +x unlock-ssh
chmod +x lock-xray
chmod +x unlock-xray