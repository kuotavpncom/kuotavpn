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
echo -e " ${red}                ⇱ MENU VLESS GRPC ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vless Grpc Account [${green}add-vlessgrpc${NC}]"
echo -e "$green [•2] $NC Trial Vless Grpc Account [${green}trial-vlessgrpc${NC}]"
echo -e "$green [•3] $NC Delete Vless Grpc Account [${green}del-vlessgrpc${NC}]"
echo -e "$green [•4] $NC Detail Vless Grpc Account [${green}detail-vlessgrpc${NC}]"
echo -e "$green [•5] $NC Renew Vless Grpc Account [${green}renew-vlessgrpc${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•7] $NC Change Path Vless GRPC [${green}path-vlessgrpc${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-7 or x]: " menuvlessgrpc
echo -e ""
case $menuvlessgrpc in
1)
add-vlessgrpc
;;
2)
trial-vlessgrpc
;;
3)
del-vlessgrpc
;;
4)
detail-vlessgrpc
;;
5)
renew-vlessgrpc
;;
6)
cek-xray
;;
7)
path-vlessgrpc
;;
x)
clear
menu
;;
*)
echo " Please enter an correct number!!"
sleep 2
menu-vlessgrpc
;;
esac