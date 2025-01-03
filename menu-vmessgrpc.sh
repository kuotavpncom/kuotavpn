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
echo -e " ${red}                 ⇱ MENU VMESS GRPC ⇲               ${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$green [•1] $NC Create Vmess Grpc Account [${green}add-vmessgrpc${NC}]"
echo -e "$green [•2] $NC Trial Vmess Grpc Account [${green}trial-vmessgrpc${NC}]"
echo -e "$green [•3] $NC Delete Vmess Grpc Account [${green}del-vmessgrpc${NC}]"
echo -e "$green [•4] $NC Detail Vmess Grpc Account [${green}detail-vmessgrpc${NC}]"
echo -e "$green [•5] $NC Renew Vmess Grpc Account [${green}renew-vmessgrpc${NC}]"
echo -e "$green [•6] $NC Check User Login Xray [${green}cek-xray${NC}]"
echo -e "$green [•7] $NC Change Path Vmess GRPC [${green}path-vmessgrpc${NC}]"
echo -e "$green [•x] $NC Kembali Ke Menu [${green}x${NC}]"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p "   Select From Options [1-7 or x]: " menuvmessgrpc
echo -e ""
case $menuvmessgrpc in
1)
add-vmessgrpc
;;
2)
trial-vmessgrpc
;;
3)
del-vmessgrpc
;;
4)
detail-vmessgrpc
;;
5)
renew-vmessgrpc
;;
6)
cek-xray
;;
7)
path-vmessgrpc
;;
x)
clear
menu
;;
*)
echo " Please enter an correct number!!"
sleep 2
menu-vmessgrpc
;;
esac