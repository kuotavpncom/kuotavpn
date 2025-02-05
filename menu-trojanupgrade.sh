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

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e " ${red}           ⇱ MENU TROJAN HTTPUPGRADE ⇲           ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Trojan UPGRADE Account [${green}add-trojanupgrade${NC}]"
echo -e "$green [•2] $NC Trial Trojan UPGRADE Account [${green}trial-trojanupgrade${NC}]"
echo -e "$green [•3] $NC Delete Trojan UPGRADE Account [${green}del-trojanupgrade${NC}]"
echo -e "$green [•4] $NC Detail Trojan UPGRADE Account [${green}detail-trojanupgrade${NC}]"
echo -e "$green [•5] $NC Renew Trojan UPGRADE Account [${green}renew-trojanupgrade${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-6 or x]: " menuvmessupgrade
echo -e ""
case $menuvmessupgrade in
1)
add-trojanupgrade
;;
2)
trial-trojanupgrade
;;
3)
del-trojanupgrade
;;
4)
detail-trojanupgrade
;;
5)
renew-trojanupgrade
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
menu-trojanupgrade
;;
esac