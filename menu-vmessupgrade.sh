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
echo -e " ${red}           ⇱ MENU VMESS HTTPUPGRADE ⇲           ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vmess UPGRADE Account [${green}add-vmessupgrade${NC}]"
echo -e "$green [•2] $NC Trial Vmess UPGRADE Account [${green}trial-vmessupgrade${NC}]"
echo -e "$green [•3] $NC Delete Vmess UPGRADE Account [${green}del-vmessupgrade${NC}]"
echo -e "$green [•4] $NC Detail Vmess UPGRADE Account [${green}detail-vmessupgrade${NC}]"
echo -e "$green [•5] $NC Renew Vmess UPGRADE Account [${green}renew-vmessupgrade${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-6 or x]: " menuvmessupgrade
echo -e ""
case $menuvmessupgrade in
1)
add-vmessupgrade
;;
2)
trial-vmessupgrade
;;
3)
del-vmessupgrade
;;
4)
detail-vmessupgrade
;;
5)
renew-vmessupgrade
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
menu-vmessupgrade
;;
esac