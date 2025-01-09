#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo -e "Im Watching You..."
  echo -e "- @kuotavpn"
  exit 1
fi

if ! which fileio > /dev/null; then
wget -q -O /usr/bin/fileio "https://raw.githubusercontent.com/kuotavpncom/kuotavpn/fileio.sh"
chmod +x /usr/bin/fileio
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
echo -e "Wget is already installed"
fi

if ! which curl > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo -e "curl is already installed"
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
echo -e "Reason : Modified Package To Bypass Sc"
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
echo -e "Reason : Modified Package To Bypass Sc"
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
if ! which rsync > /dev/null; then
apt install rsync -y
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[ON]${Font_color_suffix}"
Error="${Red_font_prefix}[OFF]${Font_color_suffix}"
cek=$(grep -c -E "^## BEGIN_Backup" /etc/crontab)
if [[ "$cek" = "1" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo -e "   » Backup Data Via Telegram Bot «"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo -e " Status Autobackup Data Via Bot Is $sts"
echo -e "   [1]  Start Backup Data"
echo -e "   [2]  Change Api Bot & Chat ID"
echo -e "   [3]  Change Backup Time"
echo -e "   [4]  Stop Autobackup Data"
echo -e "   [x]  Kembali Ke Menu"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-4 or x] :  " prot
echo -e ""
case $prot in
1)
ips=$(curl -s ipinfo.io/ip);
domain=$( cat /etc/xray/domain )
chatid=$(cat /home/chatid)
apibot=$(cat /home/apibot)
if [[ "$chatid" = "" ]]; then
echo -e "Please Enter Your Chat ID Group"
read -rp "Chat ID: " -e chatid
cat <<EOF>>/home/chatid
$chatid
EOF
fi
if [[ "$apibot" = "" ]]; then
echo -e "Please Enter Your Api Bot"
echo -e "Get Api Bot In @BotFather"
echo -e "Dont Forget To Added Your Bot To Your Group"
read -rp "Api Bot: " -e apibot
cat <<EOF>>/home/apibot
$apibot
EOF
fi
cek=$(grep -c -E "^## BEGIN_Backup" /etc/crontab)
if [[ "$cek" = "0" ]]; then
echo -e "AutoBackup DATA 00:05 GMT +7 To Your Telegram"
cat << EOF >> /etc/crontab
## BEGIN_Backup
5 0 * * * root bckp-bot
## END_Backup
EOF
service cron restart
sleep 1
echo -e "Please Wait"
clear
rm -rf /home/vps/public_html/restore/
ips=$(curl -s ipinfo.io/ip);
domain=$( cat /etc/v2ray/domain )
chatid=$(cat /home/chatid)
apibot=$(cat /home/apibot)
date=$(date +"%Y-%m-%d" | cut -d "-" -f 2-3);
date2=$(date +"%Y-%m-%d");
time=$(date +"%H:%M:%S");
rm -f $ips-$date-$time.zip
rm -rf /root/backup
mkdir /root/backup
cd /root
cp /root/log-install.txt /root/backup/
cp /etc/passwd /root/backup
cp /etc/group /root/backup
cp /etc/shadow /root/backup
cp /etc/gshadow /root/backup
cp /etc/ppp/chap-secrets backup/chap-secrets
cp /etc/ipsec.secrets backup/ipsec.secrets
cp /etc/ipsec.d/passwd backup/passwd1
cp /usr/local/etc/xray/ssh.json backup/
cp /usr/local/etc/xray/config.json backup/
cp /usr/local/etc/xray/none.json backup/
cp /usr/local/etc/xray/will666.json backup/
cp /usr/local/etc/xray/will69.json backup/
argoxray=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
if [[ -n $argoxray ]]; then
cp /etc/cf-argo/config.json backup/
fi
cp /etc/systemd/system/cdn.service backup/
cp /etc/issue.net backup/
cp -r /etc/william/ backup/william
cp -r /etc/william/slowdns backup/slowdns
cp -r /etc/ssl/private/ backup/private
cp -r /var/lib/premium-script/ backup/premium-script
cp -r /home/vps/public_html backup/public_html
cp -r /etc/nginx/conf.d backup/conf.d
rsync -av --exclude='/vmess/' /etc/xray/ /root/backup/xray/
cp -r /etc/v2ray/ backup/v2ray/
rm -rf /root/backup/public_html/data-script/*
cd /root
zip -r -P "kuotavpn" backup_${ips}_${date2}_kuotavpn.zip backup > /dev/null 2>&1
bashupload=$(curl -s bashupload.com -T backup_${ips}_${date2}_kuotavpn.zip | grep "http" | awk {'print $2'})
response=$(fileio -u backup_${ips}_${date2}_kuotavpn.zip -e 7d | grep -w "status\|link\|maxDownloads\|expires\|autoDelete")
echo "$response" | sed 's/\x1B\[[0-9;]*m//g' | sed 's/\x0F//g' | awk -F'=> ' '
/status/ {print "Response: "$2}
/link/ {print "Link Restore: "$2}
/expires/ {print "Expired: "$2}
/maxDownloads/ {print "Max Use/Download: "$2"x"}
' > /tmp/mybckp
bekapfileio=$(cat /tmp/mybckp | sed 's/\x1b(B//g')
rclone copy /root/backup_${ips}_${date2}_kuotavpn.zip william:backup/
url=$(rclone link william:backup/backup_${ips}_${date2}_kuotavpn.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
curl -F chat_id="$chatid" -F document=@"backup_${ips}_${date2}_kuotavpn.zip" -F caption="
Thank You For Using Our Service
━━━━━━━━━━━━━━━━━
Date Backup : $date2
Time Backup : $time
━━━━━━━━━━━━━━━━━
Your Domain : $domain
Your IP VPS  : $ips
━━━━━━━━━━━━━━━━━
Link v1
Link Restore: $link
Max Use/Download: Unlimited
Expired: No Expired
━━━━━━━━━━━━━━━━━
Link v2
$bekapfileio
━━━━━━━━━━━━━━━━━
Link v3
Link Restore: $bashupload
Max Use/Download: 1x
Expired: 3 days After Backup
━━━━━━━━━━━━━━━━━" https://api.telegram.org/bot$apibot/sendDocument
rm -rf backup_${ips}_${date2}_kuotavpn.zip
clear
echo "done, please cek your group telegram"
rm -rf /root/backup
else
echo -e "AutoBackup Data Already Active"
exit
fi
;;
2)
FILE=/home/apibot
if test -f "$FILE"; then
read -rp "Type Your New Api Bot: " -e apibot
cat > "/home/apibot" << EOF
$apibot
EOF
read -rp "Type Your New Chat ID Group: " -e chatid
cat > "/home/chatid" << EOF
$chatid
EOF
clear
echo -e "Succesfully Changed Api Bot & Chat ID Succesfully"
else
    echo -e "Api Bot & Chat ID Not Found, So Cannot To Change"
    exit 1
fi
;;
3)
    cekwaktu=$(grep -c -E "^## BEGIN_Backup" /etc/crontab)
    if [[ "$cekwaktu" = "0" ]]; then
        echo -e "Start Backup Data And Choose Yes First !"
        exit 1
    fi
    Current_Time=$(cat /etc/crontab | grep -w "bckp-bot" | sed 's/root bckp-bot//g' | sed '${s/ *$//}')
    if [[ "$Current_Time" = "5 0 * * *" ]]; then
        Current_TimeX="Every 1 Days at 00.05 am"
    fi
    if [[ "$Current_Time" = "0 * * * *" ]]; then
        Current_TimeX="Every 1 Hour"
    fi
    if [[ "$Current_Time" = "0 */3 * * *" ]]; then
        Current_TimeX="Every 3 Hour"
    fi
    if [[ "$Current_Time" = "0 */5 * * *" ]]; then
        Current_TimeX="Every 5 Hour"
    fi
echo -e "What Time Do You Want To Backup Data?"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo -e " Current Backup Time : ${green}$Current_TimeX${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  [1] Every 1 Hour"
echo -e "  [2] Every 3 Hour"
echo -e "  [3] Every 5 Hour"
echo -e "  [4] Every 1 Days at 00.05 am"
echo -e "━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -rp "  Select From Options [1-4]:  " -e waktu
echo -e ""
if [[ "$waktu" = "1" ]]; then
    if [[ "$Current_Time" = "0 * * * *" ]]; then
    echo -e "Already Used, Please Choose Another one !"
    exit 1
    fi
    sed -i "/## BEGIN_Backup/,/## END_Backup/d" /etc/crontab
    cat << EOF >> /etc/crontab
## BEGIN_Backup
0 * * * * root bckp-bot
## END_Backup
EOF
    service cron restart
    clear
    echo -e " Succesfully Change Time To ${green}Backup Every 1 Hour${NC}"
elif [[ "$waktu" = "2" ]]; then
    if [[ "$Current_Time" = "0 */3 * * *" ]]; then
    echo -e "Already Used, Please Choose Another one !"
    exit 1
    fi
    sed -i "/## BEGIN_Backup/,/## END_Backup/d" /etc/crontab
    cat << EOF >> /etc/crontab
## BEGIN_Backup
0 */3 * * * root bckp-bot
## END_Backup
EOF
    service cron restart
    clear
    echo -e " Succesfully Change Time Backup To ${green}Every 3 Hour${NC}"
elif [[ "$waktu" = "3" ]]; then
    if [[ "$Current_Time" = "0 */5 * * *" ]]; then
    echo -e "Already Used, Please Choose Another one !"
    exit 1
    fi
    sed -i "/## BEGIN_Backup/,/## END_Backup/d" /etc/crontab
    cat << EOF >> /etc/crontab
## BEGIN_Backup
0 */5 * * * root bckp-bot
## END_Backup
EOF
    service cron restart
    clear
    echo -e " Succesfully Change Time Backup To ${green}Every 5 Hour${NC}"
elif [[ "$waktu" = "4" ]]; then
    if [[ "$Current_Time" = "5 0 * * *" ]]; then
    echo -e "Already Used, Please Choose Another one !"
    exit 1
    fi
    sed -i "/## BEGIN_Backup/,/## END_Backup/d" /etc/crontab
    cat << EOF >> /etc/crontab
## BEGIN_Backup
5 0 * * * root bckp-bot
## END_Backup
EOF
    service cron restart
    clear
    echo -e " Succesfully Change Time Backup To ${green}Every 1 Days at 00.05 am${NC}"
else
    clear
    echo -e " You Entered The Wrong Number"
fi
;;
4)
sed -i "/^## BEGIN_Backup/,/^## END_Backup/d" /etc/crontab
clear
echo -e "Succesfully Stop Autobackup Data"
;;
x)
clear
menu
;;
*)
echo -e "Please enter an correct number"
;;
esac
