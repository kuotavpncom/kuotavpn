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
echo -e " ${red}                  ⇱ MENU VLESS XTLS ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vless XTLS Account [${green}add-vlessxtls${NC}]"
echo -e "$green [•2] $NC Trial Vless XTLS Account [${green}trial-vlessxtls${NC}]"
echo -e "$green [•3] $NC Delete Vless XTLS Account [${green}del-vlessxtls${NC}]"
echo -e "$green [•4] $NC Detail Vless XTLS Account [${green}detail-vlessxtls${NC}]"
echo -e "$green [•5] $NC Renew Vless XTLS Account [${green}renew-vlessxtls${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-6 or x]: " menuvlessxtls
echo -e ""
case $menuvlessxtls in
1)
add-vlessxtls
;;
2)
trial-vlessxtls
;;
3)
del-vlessxtls
;;
4)
detail-vlessxtls
;;
5)
renew-vlessxtls
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
menu-vlessxtls
;;
esac