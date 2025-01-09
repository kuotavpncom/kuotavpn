#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

show_info_server_menu() {
clear
tokens=("06f54274ad91b8" "37a7dbff879d08" "5f81cab82564f8" "0ab90e27edf963" "2af339e752777a")
index=$((RANDOM % ${#tokens[@]}))
token="${tokens[$index]}"
SCVERSION=$(cat /home/ver)
get_data() {
  local field=$1
  local data=$(curl -sL ipinfo.io?token=${token} | jq .$field | tr -d "\"" | tr -d ",")
  if [[ "$data" == "null" || -z "$data" ]]; then
    data=$(curl -sL ipinfo.io | jq .$field | tr -d "\"" | tr -d ",")
  fi
  echo "$data"
}
ISP=$(get_data "org" | cut -d " " -f 2-15)
CITY=$(get_data "city")
WKT=$(get_data "timezone")
REGION=$(get_data "region")
IPVPS=$(curl -sS ipinfo.io/ip )
if [ -z "$IPVPS" ]; then
IPVPS=$(curl -sS http://ip-api.com/ | grep -w "query" | awk {'print $3'} | tr -d '"')
fi
DOMAIN=$(cat /etc/xray/domain)
NSDOMAIN=$(cat /etc/ns/domain)
calc_size() {
    local raw=$1
    local total_size=0
    local num=1
    local unit="KB"
    if ! [[ ${raw} =~ ^[0-9]+$ ]] ; then
        echo ""
        return
    fi
    if [ "${raw}" -ge 1073741824 ]; then
        num=1073741824
        unit="TB"
    elif [ "${raw}" -ge 1048576 ]; then
        num=1048576
        unit="GB"
    elif [ "${raw}" -ge 1024 ]; then
        num=1024
        unit="MB"
    elif [ "${raw}" -eq 0 ]; then
        echo "${total_size}"
        return
    fi
    total_size=$( awk 'BEGIN{printf "%.1f", '$raw' / '$num'}' )
    echo "${total_size} ${unit}"
}
_exists() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}
    arch=$( uname -m )
    if _exists "getconf"; then
        lbit=$( getconf LONG_BIT )
    else
        echo ${arch} | grep -q "64" && lbit="64" || lbit="32"
    fi
        cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
        cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
        freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
    disk_total_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total| grep total | awk '{ print $2 }' )
    disk_total_size=$( calc_size $disk_total_size )
    disk_used_size=$( LANG=C; df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total| grep total | awk '{ print $3 }' )
    disk_used_size=$( calc_size $disk_used_size )
    tram=$( LANG=C; free | awk '/Mem/ {print $2}' )
    tram=$( calc_size $tram )
    uram=$( LANG=C; free | awk '/Mem/ {print $3}' )
    uram=$( calc_size $uram )
    swap=$( LANG=C; free | awk '/Swap/ {print $2}' )
    swap=$( calc_size $swap )
    uswap=$( LANG=C; free | awk '/Swap/ {print $3}' )
    uswap=$( calc_size $uswap )
    up=$(awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60} {printf("%d days, %d hour %d min\n",a,b,c)}' /proc/uptime)
    kernel=$(uname -ar | cut -d " " -f 3-3)
    clientname=$(cat /usr/local/etc/clientname)
    source /etc/os-release
echo -e "\e[1;36m      ╔════════════════════════╗\e[0m"
echo -e "\e[1;36m      ║ sc by t.me/emdevika ║\e[0m"
echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
echo -e "\e[1;36m║              SYS INFO              ║\e[0m"
echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
echo -e " \e[032;1mOS SYSTEM:\e[0m $PRETTY_NAME"
echo -e " \e[032;1mARCH:\e[0m $arch ($lbit Bit)"
echo -e " \e[032;1mKERNEL TYPE:\e[0m $kernel"
echo -e " \e[032;1mCPU MODEL:\e[0m $cname"
echo -e " \e[032;1mNUMBER OF CORES:\e[0m $cores"
echo -e " \e[032;1mCPU FREQUENCY:\e[0m $freq MHz"
echo -e " \e[032;1mTOTAL RAM:\e[0m $tram Total / $uram Used"
echo -e " \e[032;1mTOTAL STORAGE:\e[0m $disk_total_size Total / $disk_used_size Used"
if [ "$swap" != "0" ]; then
echo -e " \e[032;1mTOTAL SWAP:\e[0m $swap Total / $uswap Used"
fi
echo -e " \e[032;1mDOMAIN:\e[0m $(cat /etc/xray/domain)"
echo -e " \e[032;1mSLOWDNS DOMAIN:\e[0m $NSDOMAIN"
echo -e " \e[032;1mIP ADDRESS:\e[0m $IPVPS"
echo -e " \e[032;1mISP:\e[0m $ISP"
echo -e " \e[032;1mREGION:\e[0m $REGION [$WKT]"
echo -e " \e[032;1mCLIENTNAME:\e[0m $clientname"
echo -e " \e[032;1mSCRIPT VERSION:\e[0m $SCVERSION"
echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
listssh=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
listxray=$(
    (
        grep -E -w "VmessWS-TLS " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "vmessGRPCX " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "vmessupgrade " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "VlessWS-TLS " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "VlessGRPC " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "VlessUPGRADE-TLS " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "VlessXTLS" "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "Trojan " "/usr/local/etc/xray/will69.json" || true &&
        grep -E -w "TrojanWS " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "TrojanGRPC " "/usr/local/etc/xray/config.json" || true &&
        grep -E -w "TrojanUPGRADE-TLS " "/usr/local/etc/xray/config.json" || true
    ) | wc -l
)
listl2tp=$(grep -c -E "^### " "/var/lib/premium-script/data-user-l2tp")
echo -e "\e[1;36m        SSH & OVPN ACCOUNT ➠\e[0m $listssh"
echo -e "\e[1;36m ————————————————————————————————————\e[0m"
echo -e "\e[1;36m          XRAY ACCOUNT ➠\e[0m $listxray"
echo -e "\e[1;36m ————————————————————————————————————\e[0m"
echo -e "\e[1;36m          L2TP ACCOUNT ➠\e[0m $listl2tp"
}

show_main_menu() {
random=$(mktemp /tmp/XXXXXX)
cekdomen=$(cat /etc/xray/domain)
response=$(curl -s -f -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt > $random)
if [ $? -ne 0 ]; then
response=$(curl -s -f -H 'Cache-Control: no-cache, no-store' https://www.berkahost.com/permission.txt > $random)
if [ $? -ne 0 ]; then
response=$(curl -s -f -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt > $random)
fi
fi
time_sc=$(cat $random | grep -w "$clientname" | awk {'print $3'} | head -1 | sort -u)
id_regist=$(cat $random | grep -w "$clientname" | awk {'print $5'} | head -1 | sort -u)
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║             MAIN MENU              ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1. MENU SSH & OVPN\e[0m"
    echo -e "\e[1;32m2. MENU XRAY\e[0m"
    echo -e "\e[1;32m3. MENU L2TP\e[0m"
    echo -e "\e[1;32m4. SETTINGS\e[0m"
    echo -e "\e[1;32m5. STATUS SERVICES\e[0m"
    echo -e "\e[1;32m6. UPDATE SCRIPT\e[0m"
    echo -e "\e[1;32m7. REBUILD OS\e[0m"
    echo -e "\e[1;31m0. Exit\e[0m"
    echo -e "\e[1;36m══════════════════════════════════════\e[0m"
    echo -e "\e[1;32mEXP SC: $time_sc \e[1;36m║\e[0m \e[1;32mREGIST BY: $id_regist\e[0m"
    echo -e "\e[1;36m══════════════════════════════════════\e[0m"
    rm -rf $random
    read -p "Please select an option [0-7]: " main_option
    case $main_option in
        1) show_ssh_menu ;;
        2) show_xray_menu ;;
        3) show_l2tp_menu ;;
        4) show_settings ;;
        5) status_services ;;
        6) update_script ;;
        7) rebuild_os ;;
        0) exit 0 ;;
        *) echo "Invalid option!"; sleep 2; show_info_server_menu; show_main_menu ;;
    esac
}

show_ssh_menu() {
    clear
    dropbearver=$(dropbear -V 2>&1)
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║            MENU SSH OVPN           ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32mDropbear Version: ${dropbearver}\e[0m"
    echo -e "\e[1;36m══════════════════════════════════════\e[0m"
    echo -e "\e[1;32m1. Create SSH & OVPN\e[0m"
    echo -e "\e[1;32m2. Trial SSH & OVPN\e[0m"
    echo -e "\e[1;32m3. Renew SSH & OVPN\e[0m"
    echo -e "\e[1;32m4. Detail SSH & OVPN\e[0m"
    echo -e "\e[1;32m5. Delete SSH & OVPN\e[0m"
    echo -e "\e[1;32m6. Check SSH & OVPN Login\e[0m"
    echo -e "\e[1;32m7. Change Limit or Add Limit IP\e[0m"
    echo -e "\e[1;32m8. Unban SSH\e[0m"
    echo -e "\e[1;31m0. Back to Main Menu\e[0m"
    echo -e "\e[1;36m══════════════════════════════════════\e[0m"
    read -p "Please select an option [0-7]: " ssh_option
    case $ssh_option in
        1) add-ssh;;
        2) trial-ssh;;
        3) renew;;
        4) detail-ssh;;
        5) del-ssh;;
        6) cek;;
        7) change-limit;;
        8) unban-ssh;;
        0) show_info_server_menu; show_main_menu ;;
        *) echo "Invalid option!"; sleep 2; show_ssh_menu ;;
    esac
}

show_xray_menu() {
    clear
    xrayver=$(xray --version | awk {'print $1, $2'} | head -1)
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║             MENU XRAY              ║  \e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32mXray Version: $xrayver\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    echo -e "\e[1;32m1. Create XRAY\e[0m"
    echo -e "\e[1;32m2. Trial XRAY\e[0m"
    echo -e "\e[1;32m3. Renew XRAY\e[0m"
    echo -e "\e[1;32m4. Detail XRAY\e[0m"
    echo -e "\e[1;32m5. Delete XRAY\e[0m"
    echo -e "\e[1;32m6. Check XRAY Login\e[0m"
    echo -e "\e[1;32m7. Change XRAY Path\e[0m"
    echo -e "\e[1;32m8. Change Limit or Add Limit IP\e[0m"
    echo -e "\e[1;32m9. Change Limit or Add Limit Quota\e[0m"
    echo -e "\e[1;32m10. Unban XRAY\e[0m"
    echo -e "\e[1;31m0. Back to Main Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-10]: " xray_option
    case $xray_option in
        1) show_create_xray_menu ;;
        2) show_trial_xray_menu ;;
        3) show_renew_xray_menu ;;
        4) show_detail_xray_menu ;;
        5) show_del_xray_menu ;;
        6) cek-xray;;
        7) show_path_xray_menu;;
        8) change-limit;;
        9) change-limitbw;;
        10) unban-xray;;
        0) show_info_server_menu; show_main_menu ;;
        *) echo "Invalid option!"; sleep 2; show_xray_menu ;;
    esac
}

show_create_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║             CREATE XRAY            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  VMESS WS\e[0m"
    echo -e "\e[1;32m2.  VMESS GRPC\e[0m"
    echo -e "\e[1;32m3.  VMESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m4.  VLESS WS\e[0m"
    echo -e "\e[1;32m5.  VLESS GRPC\e[0m"
    echo -e "\e[1;32m6.  VLESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;32m7.  VLESS XTLS\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m8.  TROJAN\e[0m"
    echo -e "\e[1;32m9.  TROJAN WS\e[0m"
    echo -e "\e[1;32m10. TROJAN GRPC\e[0m"
    echo -e "\e[1;32m11. TROJAN HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-11]: " create_xray_option
    case $create_xray_option in
        1) add-vmess;;
        2) add-vmessgrpc;;
        3) add-vmessupgrade;;
        4) add-vless;;
        5) add-vlessgrpc;;
        6) add-vlessupgrade;;
        7) add-vlessxtls;;
        8) add-tr;;
        9) add-trws;;
        10) add-trgrpc;;
        11) add-trojanupgrade;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_create_xray_menu ;;
    esac
}

show_trial_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║              TRIAL XRAY            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  VMESS WS\e[0m"
    echo -e "\e[1;32m2.  VMESS GRPC\e[0m"
    echo -e "\e[1;32m3.  VMESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m4.  VLESS WS\e[0m"
    echo -e "\e[1;32m5.  VLESS GRPC\e[0m"
    echo -e "\e[1;32m6.  VLESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;32m7.  VLESS XTLS\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m8.  TROJAN\e[0m"
    echo -e "\e[1;32m9.  TROJAN WS\e[0m"
    echo -e "\e[1;32m10. TROJAN GRPC\e[0m"
    echo -e "\e[1;32m11. TROJAN HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-11]: " trial_xray_option
    case $trial_xray_option in
        1) trial-vmess;;
        2) trial-vmessgrpc;;
        3) trial-vmessupgrade;;
        4) trial-vless;;
        5) trial-vlessgrpc;;
        6) trial-vlessupgrade;;
        7) trial-vlessxtls;;
        8) trial-tr;;
        9) trial-trws;;
        10) trial-trgrpc;;
        11) trial-trojanupgrade;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_trial_xray_menu ;;
    esac
}

show_renew_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║              RENEW XRAY            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  VMESS WS\e[0m"
    echo -e "\e[1;32m2.  VMESS GRPC\e[0m"
    echo -e "\e[1;32m3.  VMESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m4.  VLESS WS\e[0m"
    echo -e "\e[1;32m5.  VLESS GRPC\e[0m"
    echo -e "\e[1;32m6.  VLESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;32m7.  VLESS XTLS\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m8.  TROJAN\e[0m"
    echo -e "\e[1;32m9.  TROJAN WS\e[0m"
    echo -e "\e[1;32m10. TROJAN GRPC\e[0m"
    echo -e "\e[1;32m11. TROJAN HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-11]: " renew_xray_option
    case $renew_xray_option in
        1) renew-vmess;;
        2) renew-vmessgrpc;;
        3) renew-vmessupgrade;;
        4) renew-vless;;
        5) renew-vlessgrpc;;
        6) renew-vlessupgrade;;
        7) renew-vlessxtls;;
        8) renew-tr;;
        9) renew-trws;;
        10) renew-trgrpc;;
        11) renew-trojanupgrade;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_renew_xray_menu ;;
    esac
}

show_detail_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║          DETAIL XRAY ACCOUNT       ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  VMESS WS\e[0m"
    echo -e "\e[1;32m2.  VMESS GRPC\e[0m"
    echo -e "\e[1;32m3.  VMESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m4.  VLESS WS\e[0m"
    echo -e "\e[1;32m5.  VLESS GRPC\e[0m"
    echo -e "\e[1;32m6.  VLESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;32m7.  VLESS XTLS\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m8.  TROJAN\e[0m"
    echo -e "\e[1;32m9.  TROJAN WS\e[0m"
    echo -e "\e[1;32m10. TROJAN GRPC\e[0m"
    echo -e "\e[1;32m11. TROJAN HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-11]: " detail_xray_option
    case $detail_xray_option in
        1) detail-vmess;;
        2) detail-vmessgrpc;;
        3) detail-vmessupgrade;;
        4) detail-vless;;
        5) detail-vlessgrpc;;
        6) detail-vlessupgrade;;
        7) detail-vlessxtls;;
        8) detail-tr;;
        9) detail-trws;;
        10) detail-trgrpc;;
        11) detail-trojanupgrade;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_detail_xray_menu ;;
    esac
}

show_del_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║             DELETE XRAY            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  VMESS WS\e[0m"
    echo -e "\e[1;32m2.  VMESS GRPC\e[0m"
    echo -e "\e[1;32m3.  VMESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m4.  VLESS WS\e[0m"
    echo -e "\e[1;32m5.  VLESS GRPC\e[0m"
    echo -e "\e[1;32m6.  VLESS HTTPUPGRADE\e[0m"
    echo -e "\e[1;32m7.  VLESS XTLS\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m8.  TROJAN\e[0m"
    echo -e "\e[1;32m9.  TROJAN WS\e[0m"
    echo -e "\e[1;32m10. TROJAN GRPC\e[0m"
    echo -e "\e[1;32m11. TROJAN HTTPUPGRADE\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-11]: " del_xray_option
    case $del_xray_option in
        1) del-vmess;;
        2) del-vmessgrpc;;
        3) del-vmessupgrade;;
        4) del-vless;;
        5) del-vlessgrpc;;
        6) del-vlessupgrade;;
        7) del-vlessxtls;;
        8) del-tr;;
        9) del-trws;;
        10) del-trgrpc;;
        11) del-trojanupgrade;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_del_xray_menu ;;
    esac
}

show_path_xray_menu() {
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║               PATH XRAY            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m1.  CHANGE PATH VMESS WS\e[0m"
    echo -e "\e[1;32m2.  CHANGE PATH VMESS GRPC\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m3.  CHANGE PATH VLESS WS\e[0m"
    echo -e "\e[1;32m4.  CHANGE PATH VLESS GRPC\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;32m5.  CHANGE PATH TROJAN WS\e[0m"
    echo -e "\e[1;32m6.  CHANGE PATH TROJAN GRPC\e[0m"
    echo -e "\e[1;36m ————————————————————————————————————\e[0m"
    echo -e "\e[1;31m0. Back to XRAY Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-6]: " create_xray_option
    case $create_xray_option in
        1) path-vmess;;
        2) path-vmessgrpc;;
        3) path-vless;;
        4) path-vlessgrpc;;
        5) path-trws;;
        6) path-trgrpc;;
        0) show_xray_menu ;;
        *) echo "Invalid option!"; sleep 2; show_create_xray_menu ;;
    esac
}

show_l2tp_menu() {
    clear
    l2tpver=$(xl2tpd --version | tail -n 1)
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║               MENU L2TP            ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m${l2tpver}\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    echo -e "\e[1;32m1. Create L2TP\e[0m"
    echo -e "\e[1;32m2. Renew L2TP\e[0m"
    echo -e "\e[1;32m3. del L2TP\e[0m"
    echo -e "\e[1;31m0. Back to Main Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-3]: " l2tp_option
    case $l2tp_option in
        1) add-l2tp;;
        2) renew-l2tp;;
        3) del-l2tp;;
        0) show_info_server_menu; show_main_menu ;;
        *) echo "Invalid option!"; sleep 2; show_l2tp_menu ;;
    esac
}

show_settings() {
    clear
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║               SETTINGS             ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;32m [1]  ARGO SETUP FOR SSH & XRAY\e[0m"
    echo -e "\e[1;32m [2]  ACTIVATE LIMIT IP SSH & XRAY\e[0m"
    echo -e "\e[1;32m [3]  CONFIGURE BOT MANAGEMENT\e[0m"
    echo -e "\e[1;32m [4]  CONFIGURE API DEVELOPMENT\e[0m"
    echo -e "\e[1;32m [5]  CHANGE DOMAIN OR FORCE DOMAIN\e[0m"
    echo -e "\e[1;32m [6]  CHANGE SLOWDNS MODE\e[0m"
    echo -e "\e[1;32m [7]  CHANGE PORT\e[0m"
    echo -e "\e[1;32m [8]  CHANGE UUID OR PASSWORD ACCOUNT VPN [XRAY]\e[0m"
    echo -e "\e[1;32m [9]  CHANGE ALTERNATIF PORT\e[0m"
    echo -e "\e[1;32m [10] AUTOBACKUP VIA BOT TELEGRAM\e[0m"
    echo -e "\e[1;32m [11] AUTOSEND CREATED VPN VIA BOT TELEGRAM\e[0m"
    echo -e "\e[1;32m [12] AUTOSEND TRIAL VPN VIA BOT TELEGRAM\e[0m"
    echo -e "\e[1;32m [13] BACKUP VIA BOT TELEGRAM\e[0m"
    echo -e "\e[1;32m [14] MONITORING CPU USAGE\e[0m"
    echo -e "\e[1;32m [15] LIMIT BANDWIDTH SPEED SERVER\e[0m"
    echo -e "\e[1;32m [16] CHECK USAGE OF RAM\e[0m"
    echo -e "\e[1;32m [17] RESTART ALL SERVICES\e[0m"
    echo -e "\e[1;32m [18] RESTORE DATA VPS\e[0m"
    echo -e "\e[1;32m [19] UPDATE KERNEL TO LATEST VERSION\e[0m"
    echo -e "\e[1;32m [20] CHANGE KERNEL TYPE 'CLOUD' TO ANOTHER VERSION\e[0m"
    echo -e "\e[1;32m [21] INSTALL WEBMIN\e[0m"
    echo -e "\e[1;32m [22] SPEEDTEST SERVER\e[0m"
    echo -e "\e[1;32m [23] WARP CLOUDFLARE\e[0m"
    echo -e "\e[1;32m [24] WARP ADVANCED\e[0m"
    echo -e "\e[1;32m [25] VIEW SERVER'S TOTAL BANDWIDTH\e[0m"
    echo -e "\e[1;32m [26] VIEW PROTOCOL & PORT INFORMATION\e[0m"
    echo -e "\e[1;32m [27] REBOOT SERVER\e[0m"
    echo -e "\e[1;31m [0]  Back to Main Menu\e[0m"
    echo -e "\e[1;36m======================================\e[0m"
    read -p "Please select an option [0-27]: " settings_option
    case $settings_option in
        1) argo-setup ;;
        2) add-limit ;;
        3) config-bot ;;
        4) config-api ;;
        5) force-host ;;
        6) change-slowdns ;;
        7) change-port ;;
        8) change-uuid ;;
        9) change-alt-port ;;
        10) backup-bot ;;
        11) auto-sendcreated ;;
        12) auto-sendtrial ;;
        13) bckp-bot ;;
        14) htop ;;
        15) limit-speed ;;
        16) ram ;;
        17) restart ;;
        18) restore ;;
        19) update-kernel ;;
        20) fix-kernel-cloud ;;
        21) wbmn ;;
        22) speedtest ;;
        23) warp ;;
        24) warp-advanced ;;
        25) vnstat ;;
        26) info ;;
        27) reboot ;;
        0) show_info_server_menu; show_main_menu ;;
        *) echo -e "\e[1;31mInvalid option!\e[0m"; sleep 2; show_settings ;;
    esac
}

status_services() {
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
    clear
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║            STATUS SERVICES         ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
status="$(systemctl show ssh.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SSH               : SSH Service is "$green"Running"$NC""
else
echo -e " SSH               : SSH Service is "$red"Not Running"$NC""
fi
status="$(systemctl show udp-custom.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SSH UDP           : SSH UDP Service is "$green"Running"$NC""
else
echo -e " SSH UDP           : SSH UDP Service is "$red"Not Running"$NC""
fi
status="$(systemctl show cdn.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SSH WEBSOCKET     : SSH Websocket Service is "$green"Running"$NC""
else
echo -e " SSH WEBSOCKET     : SSH Websocket Service is "$red"Not Running"$NC""
fi
status="$(systemctl show openvpn.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " OVPN              : OVPN Service is "$green"Running"$NC""
else
echo -e " OVPN              : OVPN  Service is "$red"Not Running"$NC""
fi
status="$(systemctl show cdn-ovpn.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " OVPN WEBSOCKET    : OVPN Websocket Service is "$green"Running"$NC""
else
echo -e " OVPN WEBSOCKET    : OVPN Websocket Service is "$red"Not Running"$NC""
fi
status="$(systemctl show stunnel5.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " STUNNEL5          : Stunnel5 Service is "$green"Running"$NC""
else
echo -e " STUNNEL5          : Stunnel5 Service is "$red"Not Running"$NC""
fi
status="$(systemctl show slowdns.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SLOWDNS           : Slowdns Service is "$green"Running"$NC""
else
echo -e " SLOWDNS           : Slowdns Service is "$red"Not Running"$NC""
fi
status="$(systemctl show squid.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " SQUID             : Squid Service is "$green"Running"$NC""
else
echo -e " SQUID             : Squid Service is "$red"Not Running"$NC""
fi
status="$(systemctl show dropbear.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " DROPBEAR          : DropBear Service is "$green"Running"$NC""
else
echo -e " DROPBEAR          : DropBear Service is "$red"Not Running"$NC""
fi
status="$(systemctl show xray.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " XRAY TLS          : XRAY TLS Service is "$green"Running"$NC""
else
echo -e " XRAY TLS          : XRAY TLS Service is "$red"Not Running"$NC""
fi
status="$(systemctl show xray@none.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " XRAY NTLS         : XRAY NTLS Service is "$green"Running"$NC""
else
echo -e " XRAY NTLS         : XRAY NTLS Service is "$red"Not Running"$NC""
fi
status="$(systemctl show xl2tpd.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " L2TP              : L2TP Service is "$green"Running"$NC""
else
echo -e " L2TP              : L2TP Service is "$red"Not Running"$NC""
fi
status="$(systemctl show nginx.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " NGINX             : Nginx Service is "$green"Running"$NC""
else
echo -e " NGINX             : Nginx Service is "$red"Not Running"$NC""
fi
status="$(systemctl show cron.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " CRON              : Cron Service is "$green"Running"$NC""
else
echo -e " CRON              : Cron Service is "$red"Not Running"$NC""
fi
status="$(systemctl show cron.service --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
echo -e " FAIL2BAN          : Fail2ban Service is "$green"Running"$NC""
else
echo -e " FAIL2BAN          : Fail2ban Service is "$red"Not Running"$NC""
fi
echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
echo ""
echo -e "Press Enter to return to the main menu..."
read -r
show_info_server_menu
show_main_menu
}

update_script() {
    red='\e[1;31m'
    green='\e[0;32m'
    NC='\e[0m'
    clear
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║            UPDATE SCRIPT           ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
local_version=$(cat /home/ver)
echo ""
echo -e "current version: $local_version"
repo_url="https://api.github.com/repos/kuotavpncom/update_v1/contents/"
files=$(curl -s "$repo_url" | jq -r '.[].name')
all_versions=$(echo "$files" | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+_sc.sh' | sort -V)
local_version_no_v=$(echo "$local_version" | sed -E 's/^v//; s/_sc.sh$//')
next_version=""
for version in $all_versions; do
    remote_version=$(echo "$version" | sed -E 's/v([0-9]+\.[0-9]+\.[0-9]+)_sc.sh/\1/')
    if [[ "$(echo -e "$remote_version\n$local_version_no_v" | sort -V | head -n 1)" != "$remote_version" && "$remote_version" > "$local_version_no_v" ]]; then
        next_version=$remote_version
        break
    fi
done
if [[ -n "$next_version" ]]; then
    echo -e "update version found: $next_version"
    echo ""
    echo "please read this !"
    echo -e "if connection close or disconnected during process update"
    echo -e "just paste -> tmux attach-session -t update"
    echo -e "then you will back to process, output 'no sessions' = update complete."
    echo ""
    echo -e "Press Enter to update..."
    read -r
    rm -rf /root/require*
    latest_file="v${next_version}_sc.sh"
    download_url="https://raw.githubusercontent.com/kuotavpncom/update_v1/main/$latest_file"
    curl -s -o "/tmp/$latest_file" "$download_url"
    chmod +x "/tmp/$latest_file"
    tmux new-session -s update "/tmp/./$latest_file"
    echo "$next_version" > /home/ver
    rm -rf /tmp/$latest_file
    clear
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║          UPDATE COMPLETE           ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m   DEV SCRIPT ➠ t.me/emdevika\e[0m"
    echo -e "\e[1;36m   GROUP DISCUSS ➠ t.me/kuotavpn\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e ""
    echo -e "type menu for back to main menu"
    exit
else
    echo -e "your script is latest version \u2764\uFE0F"
    echo ""
    echo -e "Press Enter to return to the main menu..."
    read -r
    show_info_server_menu
    show_main_menu
fi
}

rebuild_os() {
    red='\e[1;31m'
    green='\e[0;32m'
    NC='\e[0m'
    echo ""
    echo "Reminder: Backup your data before rebuilding the OS."
    echo ""
    echo -e "Press Enter if you understand"
    read -r
    clear
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║            REBUILD OS              ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "Please choose your new OS:"
    echo -e "1. UBUNTU"
    echo -e "2. DEBIAN"
    read -p "Enter your choice (1-2): " os_choice  
    if [[ "$os_choice" -eq 1 ]]; then
        os_selected="ubuntu"
        echo -e "\nYou selected Ubuntu. Please choose your version:"
        echo -e "1. Ubuntu 16.04 LTS - Xenial Xerus"
        echo -e "2. Ubuntu 18.04 LTS - Bionic Beaver"
        echo -e "3. Ubuntu 20.04 LTS - Focal Fossa"
        echo -e "4. Ubuntu 22.04 LTS - Jammy Jellyfish"
        echo -e "5. Ubuntu 24.04 LTS - Noble Numbat"
        read -p "Enter your choice (1-5): " ubuntu_version
        case "$ubuntu_version" in
            1) os_version="16.04" ;;
            2) os_version="18.04" ;;
            3) os_version="20.04" ;;
            4) os_version="22.04" ;;
            5) os_version="24.04" ;;
            *) echo -e "${red}Invalid choice!${NC}"; exit 1 ;;
        esac
    elif [[ "$os_choice" -eq 2 ]]; then
        os_selected="debian"
        echo -e "\nYou selected Debian. Please choose your version:"
        echo -e "1. Debian 9 - Stretch"
        echo -e "2. Debian 10 - Buster"
        echo -e "3. Debian 11 - Bullseye"
        echo -e "4. Debian 12 - Bookworm"
        read -p "Enter your choice (1-4): " debian_version
        case "$debian_version" in
            1) os_version="9" ;;
            2) os_version="10" ;;
            3) os_version="11" ;;
            4) os_version="12" ;;
            *) echo -e "${red}Invalid choice!${NC}"; exit 1 ;;
        esac
    else
        echo -e "${red}Invalid OS choice!${NC}"
        exit 1
    fi    
    echo -e "\n${green}You have selected OS: $os_selected, Version: $os_version${NC}"
    echo ""
    echo -e "Process installation Please Wait....."
    sleep 3
    wget --no-check-certificate -q -O /usr/bin/reinstall "https://raw.githubusercontent.com/$repogithub/reinstall.sh" && chmod +x /usr/bin/reinstall
    sleep 1
    reinstall $os_selected $os_version > /dev/null 2>&1
    echo -e "\e[1;36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[1;36m║          REBUILD COMPLETE          ║\e[0m"
    echo -e "\e[1;36m╚════════════════════════════════════╝\e[0m"
    echo -e "OS SELECTED: $os_selected"
    echo -e "OS VERSION: $os_version"
    echo -e "NEW DEFAULT PASSWORD: kuotavpn"
    echo -e "\e[1;36m======================================\e[0m"
    echo ""
    echo -e "Press Enter to reboot and start the configuration."
    read -r
    reboot 
}
show_info_server_menu
show_main_menu
