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
echo -e " ${red}           ⇱ MENU VLESS HTTPUPGRADE ⇲           ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vless UPGRADE Account [${green}add-vmessupgrade${NC}]"
echo -e "$green [•2] $NC Trial Vless UPGRADE Account [${green}trial-vlessupgrade${NC}]"
echo -e "$green [•3] $NC Delete Vless UPGRADE Account [${green}del-vlessupgrade${NC}]"
echo -e "$green [•4] $NC Detail Vless UPGRADE Account [${green}detail-vlessupgrade${NC}]"
echo -e "$green [•5] $NC Renew Vless UPGRADE Account [${green}renew-vlessupgrade${NC}]"
echo -e "$green [•6] $NC Check User Login Xray-TLS [${green}cek-xray${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-6 or x]: " menuvmessupgrade
echo -e ""
case $menuvmessupgrade in
1)
add-vlessupgrade
;;
2)
trial-vlessupgrade
;;
3)
del-vlessupgrade
;;
4)
detail-vlessupgrade
;;
5)
renew-vlessupgrade
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
menu-vlessupgrade
;;
esac