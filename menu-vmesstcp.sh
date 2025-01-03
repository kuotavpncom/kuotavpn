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
echo -e " ${red}               ⇱ MENU VMESS TCP HTTP ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vmess TCP HTTP Account [${green}add-vmesstcp${NC}]"
echo -e "$green [•2] $NC Trial Vmess TCP HTTP Account [${green}trial-vmesstcp${NC}]"
echo -e "$green [•3] $NC Delete Vmess TCP HTTP Account [${green}del-vmesstcp${NC}]"
echo -e "$green [•4] $NC Detail Vmess TCP HTTP Account [${green}detail-vmesstcp${NC}]"
echo -e "$green [•5] $NC Renew Vmess TCP HTTP Account [${green}renew-vmesstcp${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•7] $NC Change Path Vmess TCP HTTP [${green}path-vmesstcp${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-7 or x]: " menuvmesstcp
echo -e ""
case $menuvmesstcp in
1)
add-vmesstcp
;;
2)
trial-vmesstcp
;;
3)
del-vmesstcp
;;
4)
detail-vmesstcp
;;
5)
renew-vmesstcp
;;
6)
cek-xray
;;
7)
path-vmesstcp
;;
x)
clear
menu
;;
*)
echo " Please enter an correct number!!"
sleep 2
menu-vmesstcp
;;
esac