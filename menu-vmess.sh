#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " ${red}                 ⇱ MENU VMESS WS ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vmess WS Account [${green}add-vmess${NC}]"
echo -e "$green [•2] $NC Trial Vmess WS Account [${green}trial-vmess${NC}]"
echo -e "$green [•3] $NC Delete Vmess WS Account [${green}del-vmess${NC}]"
echo -e "$green [•4] $NC Detail Vmess WS Account [${green}detail-vmess${NC}]"
echo -e "$green [•5] $NC Renew Vmess WS Account [${green}renew-vmess${NC}]"
echo -e "$green [•6] $NC Activate Limit IP LOGIN [${green}add-limit${NC}]"
echo -e "$green [•7] $NC Change Limit IP LOGIN [${green}change-limit${NC}]"
echo -e "$green [•8] $NC Unbanned Xray Account [${green}unban-xray${NC}]"
echo -e "$green [•9] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•10] $NC Change Path Vmess WS [${green}path-vmess${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-10 or x]: " menuvmessws
echo -e ""
case $menuvmessws in
1)
add-vmess
;;
2)
trial-vmess
;;
3)
del-vmess
;;
4)
detail-vmess
;;
5)
renew-vmess
;;
6)
add-limit
;;
7)
change-limit
;;
8)
unban-xray
;;
9)
cek-xray
;;
10)
path-vmess
;;
x)
clear
menu
;;
*)
echo " Please enter an correct number!!"
sleep 2
menu-vmess
;;
esac