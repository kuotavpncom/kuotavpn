#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi
bold='\033[1m'
red='\e[1;31m'
green='\e[0;32m'
dark_blue='\e[0;34m'
NC='\e[0m'

output=$(curl -sS ipinfo.io/ip 2>&1)
if [[ "$output" == *"Could not resolve host"* ]]; then
warp-cli --accept-tos disconnect
echo -e "${green}Success Fix Issue${NC}: Could not resolved host"
echo -e "Try Again Getting IP Warp"
exit 1
fi

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

if ! which vnstat > /dev/null; then
clear
echo -e "${red}Abuse Script Detected !${NC}"
sleep 2
exit 0
clear
fi

cekvnstat=$(systemctl status vnstat | grep -o "active (running)")
if [[ "$cekvnstat" = "active (running)" ]]; then
echo -e "${green}OK${NC}"
clear
else
echo -e "${red}Abuse Script Detected !${NC}"
exit
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
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit 1
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
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
exit 1
fi

# cek client name
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

country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
if [[ $country == "ID" || $country == "SG" || $country == "EG" ]]; then
    echo "OKAY"
else
    echo ""
    echo "Im Sorry, Only Support Indonesian Or Egypt Server :("
    exit 1
fi

if ! which warp-cli > /dev/null; then
    echo -e "Install Packages..."
    sleep 2
    curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo -e "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
    apt-get update
    apt-get install cloudflare-warp -y
    echo -e "Install Package Done"
    sleep 3
    clear
fi

clear
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "━━━━━━[WARP ADVANCED]━━━━━━"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "Dev » t.me/kuotavpn"
echo -e "Telegram Channel » https://t.me/autoscript_willstore69"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
statusWarp=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
if [[ "$statusWarp" == "Connected" ]]; then
    StatusProfile=$(warp-cli --accept-tos registration show 2>/dev/null | grep -w "Account type:" | awk {'print $3'})
        if [[ "$StatusProfile" == "Team" ]]; then
        CekWarp="Connected To ${dark_blue}Warp Teams${NC}"
        elif [[ "$StatusProfile" == "Unlimited" ]]; then
        CekWarp="Connected To ${green}WARP Plus Unlimited${NC}"
        elif [[ "$StatusProfile" == "Limited" ]]; then
        CekWarp="Connected To ${green}WARP Plus Kuota${NC}"
        elif [[ "$StatusProfile" == "Free" ]]; then
        CekWarp="Connected To ${red}WARP Free${NC}"
        else
        CekWarp="Not Connected to WARP"
    fi
   echo -e "$CekWarp"
    warp-cli --accept-tos registration show
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " [1] Disconnect Warp"
    echo -e " [2] Disconnect Warp + Delete Previous Profile/Register License Or Teams"
    echo -e " [3] Excluded Routes IP [Advanced User]"
    echo -e " [4] Deleted Routes IP [Advanced User]"
    echo -e " [5] List Excluded Routes IP"
    echo -e " [6] Cloudflare Trace Endpoint Information"
    echo -e " [x] Exit"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e ""
    read -p " Select From Options [1-6 or x] :  " prot
    echo -e ""
    case $prot in
        1)
            warp-cli --accept-tos disconnect > /dev/null 2>&1
            echo -e "STOP WARP SUCCESS !"
            ;;
        2)
            warp-cli --accept-tos disconnect > /dev/null 2>&1
            warp-cli --accept-tos registration delete > /dev/null 2>&1
            echo -e "STOP WARP & DELETE PREVIOUS LICENSE/REGISTER SUCCESS !"
            ;;
        3)
            Check=$(warp-cli --accept-tos registration show | grep -o "Team")
            if [ -n "$Check" ]; then
                echo -e "Excluded Not Support From CLI for ${dark_blue}Warp Teams${NC} !"
            else
                read -p "Enter IP addresses to exclude (separated by spaces): " -a ip_addresses
                for ip in "${ip_addresses[@]}"; do
                    warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                    echo "IP address $ip excluded."
                done
            fi
            ;;
        4)
            Check=$(warp-cli --accept-tos registration show | grep -o "Team")
            if [ -n "$Check" ]; then
                echo -e "Excluded Not Support From CLI for ${dark_blue}Warp Teams${NC} !"
            else
                echo -e "${bold}${red}WARN !${NC} be careful or you will lose..."
                echo ""
                read -p "Enter IP addresses to remove from exclusion (separated by spaces): " -a ip_addresses
                for ip in "${ip_addresses[@]}"; do
                    warp-cli --accept-tos remove-excluded-route $ip > /dev/null 2>&1
                    echo "IP address $ip removed from exclusion."
                done
            fi
            ;;
        5)
            warp-cli --accept-tos tunnel ip list
            echo -e "\nPress Enter to back..."
            read -n 1 -s
            clear
            warp-advanced
            ;;
        6)
            curl -sS https://cloudflare.com/cdn-cgi/trace
            echo -e "\nPress Enter to back..."
            read -n 1 -s
            clear
            warp-advanced
            ;;
        x)
            exit
            ;;
        *)
            echo "Please enter a correct number"
            ;;
    esac
else
    echo -e "Not Connected"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e " [1] Connect To Warp"
    echo -e " [2] Excluded Routes IP [Advanced User]"
    echo -e " [3] Deleted Routes IP [Advanced User]"
    echo -e " [4] List Excluded Routes IP"
    echo -e " [5] Cloudflare Trace Endpoint Information"
    AdaWarpSebelumnya=$(warp-cli --accept-tos registration show | grep -o "Error")
    if [ -z "$AdaWarpSebelumnya" ]; then
    echo -e " [6] Delete Previous Profile/Register License Or Teams"
    fi
    echo -e " [x] Exit"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e ""
    AdaWarpSebelumnya=$(warp-cli --accept-tos registration show | grep -o "Error")
    if [ -z "$AdaWarpSebelumnya" ]; then
    read -p " Select From Options [1-6 or x] :  " prot
    else
    read -p " Select From Options [1-5 or x] :  " prot
    fi
    echo -e ""
    case $prot in
        1)
            echo "Choose Mode"
            echo "1. Warp"
            echo "2. Warp Teams (advanced user)"
            echo "3. Proxy Socks5"
            read -p "Enter your choice (1-3): " choice
            case $choice in
                1)
                    AdaWarpSebelumnya=$(warp-cli --accept-tos registration show | grep -o "Error")
                    if [ -z "$AdaWarpSebelumnya" ]; then
                    echo "Melanjutkan Dengan Profile Warp Yang Pernah Ada"
                    sleep 2
                        echo -e "Process Excluded ISP Operator Please Wait..."
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "ID" || $country == "SG" ]]; then
                        echo -e "${green}SERVER INDO or SG DETECTED [!]${NC}"
                        cek_routes_tsel=$(warp-cli --accept-tos tunnel ip list | grep -w "114.124.128.0/18" | awk {'print $1'})
                        if [ -z "$cek_routes_tsel" ]; then
                        data_tsel=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_tsel.txt` )
                        for ip in "${data_tsel[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Telkomsel Done ✓${NC}"
                        else
                        echo -e "found routes Tsel [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_xl=$(warp-cli --accept-tos tunnel ip list | grep -w "112.215.232.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_xl" ]; then
                        data_xl=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_xl.txt` )
                        for ip in "${data_xl[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}XL Done ✓${NC}"
                        else
                        echo -e "found routes XL [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_isat=$(warp-cli --accept-tos tunnel ip list | grep -w "114.10.12.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_isat" ]; then
                        data_isat=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_isat.txt` )
                        for ip in "${data_isat[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Indosat Done ✓${NC}"
                        else
                        echo -e "found routes Indosat [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_smartfren=$(warp-cli --accept-tos tunnel ip list | grep -w "158.140.188.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_smartfren" ]; then
                        data_smart=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_smart.txt` )
                        for ip in "${data_smart[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Smartfren Done ✓${NC}"
                        else
                        echo -e "found routes Smartfren [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "EG" ]]; then
                        echo -e "${green}SERVER EGYPT DETECTED [!]${NC}"
                        cek_routes_voda=$(warp-cli --accept-tos tunnel ip list | grep -w "196.221.60.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_voda" ]; then
                        data_voda=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_vodafone.txt` )
                        for ip in "${data_voda[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Vodafone Done ✓${NC}"
                        else
                        echo -e "found routes Vodafone [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_etisalat=$(warp-cli --accept-tos tunnel ip list | grep -w "217.52.247.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_etisalat" ]; then
                        data_eti=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_etisalat.txt` )
                        for ip in "${data_eti[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Etisalat Done ✓${NC}"
                        else
                        echo -e "found routes Etisalat [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        # CDN CF
                        warp-cli --accept-tos add-excluded-route 173.245.48.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.21.244.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.22.200.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.31.4.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 141.101.64.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 108.162.192.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 190.93.240.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 188.114.96.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 197.234.240.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 198.41.128.0/17 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 162.158.0.0/15 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 104.24.0.0/14 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 172.64.0.0/13 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 131.0.72.0/22 > /dev/null 2>&1
                        # BUAT JAGA JAGA JIKA TETAP TURU
                        warp-cli --accept-tos add-excluded-route 103.172.116.154/32 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.189.164.175/32 > /dev/null 2>&1
                        # IP VPS & SYSTEM NYA
                        needExcluded=$(ip addr show | grep inet | awk {'print $2'} | grep "/")
                        echo "$needExcluded" | while read -r ip; do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        needExcludedv2=$(ip addr show | grep inet | awk {'print $2'} | grep -v "/")
                        echo "$needExcludedv2" | while read -r ip; do
                        warp-cli --accept-tos tunnel ip add $ip > /dev/null 2>&1
                        done
                    warp-cli --accept-tos mode tunnel_only > /dev/null 2>&1
                    warp-cli --accept-tos connect > /dev/null 2>&1
                    while true; do
                    status=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
                    echo "Current status: $status"
                    if [ "$status" = "Unable" ]; then
                    echo -e "${red}Failed To Get IP Warp${NC}"
                    sleep 2
                    echo "Please Try Again Later...."
                    sleep 2
                    echo "Read: https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/?_gl=1*ri79ut*_ga*MTM1MDExOTQxMC4xNzA1OTg3MjI4*_ga_SQCRB0TXZW*MTcxNjU2MTgwMS45LjEuMTcxNjU2MjE3Mi4wLjAuMA..#warp-on-linux-shows-dns-connectivity-check-failed-with-reason-dnslookupfailed"
                    warp-cli --accept-tos disconnect > /dev/null 2>&1
                    exit 1
                    elif [ "$status" = "Connected" ] && [ "$previous_status" != "Connected" ]; then
                    echo -e "${green}Connected.${NC} Success Get Warp IP !"
                    exit 1
                    fi
                    previous_status="$status"
                    sleep 3
                    done
                    else
                    warp-cli --accept-tos mode tunnel_only
                    warp-cli --accept-tos registration new > /dev/null 2>&1
                    read -p "Please Enter License warp (leave blank if you don't have it): " license
                    if [ -n "$license" ]; then
                        license_pattern="^[A-Za-z0-9-]{26}$"
                        if [[ $license =~ $license_pattern ]]; then
                        echo -e "You entered a valid license: ${green}$license${NC}"
                        warp-cli --accept-tos registration license $license > /dev/null 2>&1
                        else
                        echo "Invalid license warp"
                        sleep 2
                        echo -e "\nPress Enter to back..."
                        read -n 1 -s
                        clear
                        warp-advanced
                        fi
                        echo "configuration... please wait"
                        sleep 3
                        echo -e "Process Excluded ISP Operator Please Wait..."
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "ID" || $country == "SG" ]]; then
                        echo -e "${green}SERVER INDO or SG DETECTED [!]${NC}"
                        cek_routes_tsel=$(warp-cli --accept-tos tunnel ip list | grep -w "114.124.128.0/18" | awk {'print $1'})
                        if [ -z "$cek_routes_tsel" ]; then
                        data_tsel=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_tsel.txt` )
                        for ip in "${data_tsel[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Telkomsel Done ✓${NC}"
                        else
                        echo -e "found routes Tsel [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_xl=$(warp-cli --accept-tos tunnel ip list | grep -w "112.215.232.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_xl" ]; then
                        data_xl=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_xl.txt` )
                        for ip in "${data_xl[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}XL Done ✓${NC}"
                        else
                        echo -e "found routes XL [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_isat=$(warp-cli --accept-tos tunnel ip list | grep -w "114.10.12.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_isat" ]; then
                        data_isat=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_isat.txt` )
                        for ip in "${data_isat[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Indosat Done ✓${NC}"
                        else
                        echo -e "found routes Indosat [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_smartfren=$(warp-cli --accept-tos tunnel ip list | grep -w "158.140.188.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_smartfren" ]; then
                        data_smart=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_smart.txt` )
                        for ip in "${data_smart[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Smartfren Done ✓${NC}"
                        else
                        echo -e "found routes Smartfren [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "EG" ]]; then
                        echo -e "${green}SERVER EGYPT DETECTED [!]${NC}"
                        cek_routes_voda=$(warp-cli --accept-tos tunnel ip list | grep -w "196.221.60.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_voda" ]; then
                        data_voda=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_vodafone.txt` )
                        for ip in "${data_voda[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Vodafone Done ✓${NC}"
                        else
                        echo -e "found routes Vodafone [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_etisalat=$(warp-cli --accept-tos tunnel ip list | grep -w "217.52.247.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_etisalat" ]; then
                        data_eti=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_etisalat.txt` )
                        for ip in "${data_eti[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Etisalat Done ✓${NC}"
                        else
                        echo -e "found routes Etisalat [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        # CDN CF
                        warp-cli --accept-tos add-excluded-route 173.245.48.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.21.244.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.22.200.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.31.4.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 141.101.64.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 108.162.192.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 190.93.240.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 188.114.96.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 197.234.240.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 198.41.128.0/17 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 162.158.0.0/15 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 104.24.0.0/14 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 172.64.0.0/13 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 131.0.72.0/22 > /dev/null 2>&1
                        # BUAT JAGA JAGA JIKA TETAP TURU
                        warp-cli --accept-tos add-excluded-route 103.172.116.154/32 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.189.164.175/32 > /dev/null 2>&1
                        # IP VPS & SYSTEM NYA
                        needExcluded=$(ip addr show | grep inet | awk {'print $2'} | grep "/")
                        echo "$needExcluded" | while read -r ip; do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        needExcludedv2=$(ip addr show | grep inet | awk {'print $2'} | grep -v "/")
                        echo "$needExcludedv2" | while read -r ip; do
                        warp-cli --accept-tos tunnel ip add $ip > /dev/null 2>&1
                        done
                        echo "configuration sukses! now getting ip cloudflare...."
                        sleep 2
                        warp-cli --accept-tos connect > /dev/null 2>&1
                        while true; do
                        status=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
                        echo "Current status: $status"
                        if [ "$status" = "Unable" ]; then
                        echo -e "${red}Failed To Get IP Warp${NC}"
                        sleep 2
                        echo "Please Try Again Later...."
                        sleep 2
                        echo "Read: https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/?_gl=1*ri79ut*_ga*MTM1MDExOTQxMC4xNzA1OTg3MjI4*_ga_SQCRB0TXZW*MTcxNjU2MTgwMS45LjEuMTcxNjU2MjE3Mi4wLjAuMA..#warp-on-linux-shows-dns-connectivity-check-failed-with-reason-dnslookupfailed"
                        warp-cli --accept-tos disconnect > /dev/null 2>&1
                        exit 1
                        elif [ "$status" = "Connected" ] && [ "$previous_status" != "Connected" ]; then
                        echo -e "${green}Connected.${NC} Success Get Warp IP !"
                        exit 1
                        fi
                        previous_status="$status"
                        sleep 5
                        done
                    else
                        echo "No license provided. Skipping license activation."
                        echo -e "Process Excluded ISP Operator Please Wait..."
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "ID" || $country == "SG" ]]; then
                        echo -e "${green}SERVER INDO or SG DETECTED [!]${NC}"
                        cek_routes_tsel=$(warp-cli --accept-tos tunnel ip list | grep -w "114.124.128.0/18" | awk {'print $1'})
                        if [ -z "$cek_routes_tsel" ]; then
                        data_tsel=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_tsel.txt` )
                        for ip in "${data_tsel[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Telkomsel Done ✓${NC}"
                        else
                        echo -e "found routes Tsel [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_xl=$(warp-cli --accept-tos tunnel ip list | grep -w "112.215.232.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_xl" ]; then
                        data_xl=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_xl.txt` )
                        for ip in "${data_xl[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}XL Done ✓${NC}"
                        else
                        echo -e "found routes XL [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_isat=$(warp-cli --accept-tos tunnel ip list | grep -w "114.10.12.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_isat" ]; then
                        data_isat=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_isat.txt` )
                        for ip in "${data_isat[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Indosat Done ✓${NC}"
                        else
                        echo -e "found routes Indosat [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_smartfren=$(warp-cli --accept-tos tunnel ip list | grep -w "158.140.188.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_smartfren" ]; then
                        data_smart=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_smart.txt` )
                        for ip in "${data_smart[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Smartfren Done ✓${NC}"
                        else
                        echo -e "found routes Smartfren [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        country=$(curl -sS ipinfo.io | jq .country | tr -d '"')
                        if [[ $country == "EG" ]]; then
                        echo -e "${green}SERVER EGYPT DETECTED [!]${NC}"
                        cek_routes_voda=$(warp-cli --accept-tos tunnel ip list | grep -w "196.221.60.0/22" | awk {'print $1'})
                        if [ -z "$cek_routes_voda" ]; then
                        data_voda=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_vodafone.txt` )
                        for ip in "${data_voda[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Vodafone Done ✓${NC}"
                        else
                        echo -e "found routes Vodafone [!]"
                        echo -e "no need to add"
                        fi
                        cek_routes_etisalat=$(warp-cli --accept-tos tunnel ip list | grep -w "217.52.247.0/24" | awk {'print $1'})
                        if [ -z "$cek_routes_etisalat" ]; then
                        data_eti=( `curl -sS https://raw.githubusercontent.com/scriptvpskita/x/main/crot/crot/crot/crot/crot/crot/ip_etisalat.txt` )
                        for ip in "${data_eti[@]}"
                        do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        echo -e "${green}Etisalat Done ✓${NC}"
                        else
                        echo -e "found routes Etisalat [!]"
                        echo -e "no need to add"
                        fi
                        fi
                        # CDN CF
                        warp-cli --accept-tos add-excluded-route 173.245.48.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.21.244.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.22.200.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.31.4.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 141.101.64.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 108.162.192.0/18 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 190.93.240.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 188.114.96.0/20 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 197.234.240.0/22 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 198.41.128.0/17 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 162.158.0.0/15 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 104.24.0.0/14 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 172.64.0.0/13 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 131.0.72.0/22 > /dev/null 2>&1
                        # BUAT JAGA JAGA JIKA TETAP TURU
                        warp-cli --accept-tos add-excluded-route 103.172.116.154/32 > /dev/null 2>&1
                        warp-cli --accept-tos add-excluded-route 103.189.164.175/32 > /dev/null 2>&1
                        # IP VPS & SYSTEM NYA
                        needExcluded=$(ip addr show | grep inet | awk {'print $2'} | grep "/")
                        echo "$needExcluded" | while read -r ip; do
                        warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                        done
                        needExcludedv2=$(ip addr show | grep inet | awk {'print $2'} | grep -v "/")
                        echo "$needExcludedv2" | while read -r ip; do
                        warp-cli --accept-tos tunnel ip add $ip > /dev/null 2>&1
                        done
                        echo "configuration sukses! now getting ip cloudflare...."
                        sleep 2
                        warp-cli --accept-tos connect > /dev/null 2>&1
                        while true; do
                        status=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
                        echo "Current status: $status"
                        if [ "$status" = "Unable" ]; then
                        echo -e "${red}Failed To Get IP Warp${NC}"
                        sleep 2
                        echo "Please Try Again Later...."
                        sleep 2
                        echo "Read: https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/?_gl=1*ri79ut*_ga*MTM1MDExOTQxMC4xNzA1OTg3MjI4*_ga_SQCRB0TXZW*MTcxNjU2MTgwMS45LjEuMTcxNjU2MjE3Mi4wLjAuMA..#warp-on-linux-shows-dns-connectivity-check-failed-with-reason-dnslookupfailed"
                        warp-cli --accept-tos disconnect > /dev/null 2>&1
                        exit 1
                        elif [ "$status" = "Connected" ] && [ "$previous_status" != "Connected" ]; then
                        echo -e "${green}Connected.${NC} Success Get Warp IP !"
                        exit 1
                        fi
                        previous_status="$status"
                        sleep 5
                        done
                    fi
                    fi
                    ;;
                2)
                    AdaWarpSebelumnya=$(warp-cli --accept-tos registration show | grep -o "Team")
                    if [ -n "$AdaWarpSebelumnya" ]; then
                    echo "Melanjutkan Dengan Profile Teams Yang Pernah Ada"
                    warp-cli --accept-tos connect
                    echo "configuration sukses! now getting ip cloudflare...."
                    sleep 2
                    warp-cli --accept-tos connect > /dev/null 2>&1
                    while true; do
                    status=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
                    echo "Current status: $status"
                    if [ "$status" = "Unable" ]; then
                    echo -e "${red}Failed To Get IP Warp${NC}"
                    sleep 2
                    echo "Please Try Again Later...."
                    sleep 2
                    echo "Read: https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/?_gl=1*ri79ut*_ga*MTM1MDExOTQxMC4xNzA1OTg3MjI4*_ga_SQCRB0TXZW*MTcxNjU2MTgwMS45LjEuMTcxNjU2MjE3Mi4wLjAuMA..#warp-on-linux-shows-dns-connectivity-check-failed-with-reason-dnslookupfailed"
                    warp-cli --accept-tos disconnect > /dev/null 2>&1
                    exit 1
                    elif [ "$status" = "Connected" ] && [ "$previous_status" != "Connected" ]; then
                    echo -e "${green}Connected.${NC} Success Get Warp IP !"
                    exit 1
                    fi
                    previous_status="$status"
                    sleep 5
                    done
                    else
                    warp-cli --accept-tos reset-settings > /dev/null 2>&1
                    warp-cli --accept-tos mode tunnel_only
                    warp-cli --accept-tos reset-settings > /dev/null 2>&1
                    warp-cli --accept-tos registration new > /dev/null 2>&1
                    warp-cli --accept-tos registration delete > /dev/null 2>&1
                    echo "Mode set to Warp Teams"
                    read -p "Please Enter Teams Token: " Token
                    output=$(warp-cli --accept-tos registration token https://$Token 2>&1)
                    if [[ "$output" == *"Error: Failed to contact the WARP API."* ]]; then
                    echo "Error: Token Invalid / Expired."
                    exit 1
                    fi
                    warp-cli --accept-tos connect
                    echo "configuration sukses! now getting ip cloudflare...."
                    sleep 2
                    warp-cli --accept-tos connect > /dev/null 2>&1
                    while true; do
                    status=$(warp-cli --accept-tos status 2>/dev/null | awk {'print $3'} | sed '/^$/d')
                    echo "Current status: $status"
                    if [ "$status" = "Unable" ]; then
                    echo -e "${red}Failed To Get IP Warp${NC}"
                    sleep 2
                    echo "Please Try Again Later...."
                    sleep 2
                    echo "Read: https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/?_gl=1*ri79ut*_ga*MTM1MDExOTQxMC4xNzA1OTg3MjI4*_ga_SQCRB0TXZW*MTcxNjU2MTgwMS45LjEuMTcxNjU2MjE3Mi4wLjAuMA..#warp-on-linux-shows-dns-connectivity-check-failed-with-reason-dnslookupfailed"
                    warp-cli --accept-tos disconnect > /dev/null 2>&1
                    exit 1
                    elif [ "$status" = "Connected" ] && [ "$previous_status" != "Connected" ]; then
                    echo -e "${green}Connected.${NC} Success Get Warp IP !"
                    exit 1
                    fi
                    previous_status="$status"
                    sleep 5
                    done
                    fi
                    ;;
                3)
                    echo "Under Maintenance !"
                    echo -e "\nPress Enter to back..."
                    read -n 1 -s
                    warp-advanced
                    ;;
                *)
                    echo "Invalid choice. Please enter a number between 1 and 3."
                    ;;
            esac
            ;;
        2)
            Check=$(warp-cli --accept-tos registration show | grep -o "Team")
            if [ -n "$Check" ]; then
                echo -e "Excluded Not Support From CLI for ${dark_blue}Warp Teams${NC} !"
            else
                read -p "Enter Routes IP Address to exclude (separated by spaces): " -a ip_addresses
                for ip in "${ip_addresses[@]}"; do
                    warp-cli --accept-tos add-excluded-route $ip > /dev/null 2>&1
                    echo "IP address $ip excluded."
                done
            fi
            ;;
        3)
            Check=$(warp-cli --accept-tos registration show | grep -o "Team")
            if [ -n "$Check" ]; then
                echo -e "Excluded Not Support From CLI for ${dark_blue}Warp Teams${NC} !"
            else
                echo -e "${bold}${red}WARN !${NC} be careful or you will lost..."
                echo ""
                read -p "Enter Routes IP Address to remove from exclusion (separated by spaces): " -a ip_addresses
                for ip in "${ip_addresses[@]}"; do
                    warp-cli --accept-tos remove-excluded-route $ip > /dev/null 2>&1
                    echo "IP address $ip removed from exclusion."
                done
            fi
            ;;
        4)
            warp-cli --accept-tos tunnel ip list
            echo -e "\nPress Enter to back..."
            read -n 1 -s
            clear
            warp-advanced
            ;;
        5)
            curl -sS https://cloudflare.com/cdn-cgi/trace
            echo -e "\nPress Enter to back..."
            read -n 1 -s
            clear
            warp-advanced
            ;;
        6)
            AdaWarpSebelumnya=$(warp-cli --accept-tos registration show | grep -o "Error")
            if [ -z "$AdaWarpSebelumnya" ]; then
            warp-cli --accept-tos registration delete > /dev/null 2>&1
            echo -e "DELETE PREVIOUS LICENSE/REGISTER SUCCESS !"
            else
            echo "Please enter a correct number"
            fi
            ;;
        x)
            exit
            ;;
        *)
            echo "Please enter a correct number"
            ;;
    esac
fi