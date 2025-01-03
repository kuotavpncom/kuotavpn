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
echo -e " ${red}                   ⇱ MENU TROJAN ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Trojan Account [${green}add-tr${NC}]"
echo -e "$green [•2] $NC Trial Trojan Account [${green}trial-tr${NC}]"
echo -e "$green [•3] $NC Delete Trojan Account [${green}del-tr${NC}]"
echo -e "$green [•4] $NC Detail Trojan Account [${green}detail-tr${NC}]"
echo -e "$green [•5] $NC Renew Trojan Account [${green}renew-tr${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-6 or x]: " menutrojan
echo -e ""
case $menutrojan in
1)
add-tr
;;
2)
trial-tr
;;
3)
del-tr
;;
4)
detail-tr
;;
5)
renew-tr
;;
6)
cek-xray
;;
x)
clear
menu
;;
*)
echo " Please enter an correct number!!"
sleep 2
menu-tr
;;
esac