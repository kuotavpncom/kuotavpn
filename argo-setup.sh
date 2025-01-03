#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
IP=$(curl -s ipinfo.io/ip > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
if [ -z "$MYIP" ]; then
IP=$(curl -s http://ip-api.com/json | jq .query | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi
if [ -z "$MYIP" ]; then
IP=$(curl -s ipinfo.io | jq .ip | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi

# cek wget & curl
if ! which wget > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo "Wget is already installed"
fi

if ! which curl > /dev/null; then
clear
echo -e "${red}Wah Mau Belajar Nakal Yah !${NC}"
sleep 2
exit 0
clear
else
echo "curl is already installed"
fi

fileee=/usr/bin/wget
minimumsize=400000
actualsize=$(wc -c <"$fileee")
if [ $actualsize -ge $minimumsize ]; then
clear
echo -e "${green}Checking...${NC}"
else
clear
echo -e "${red}Permission Denied!${NC}";
echo "Reason : Modified Package To Bypass Sc"
exit 0
fi

fileeex=/usr/bin/curl
minimumsizex=15000
clear
actualsizex=$(wc -c <"$fileeex")
if [ $actualsizex -ge $minimumsizex ]; then
clear
echo -e "${green}Checking...${NC}"
else
clear
echo -e "${red}Permission Denied!${NC}";
echo "Reason : Modified Package To Bypass Sc"
exit 0
fi

# data server
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
cekcloudflare=$(curl -s http://ip-api.com/json | jq .as | grep -o "Cloudflare")
if [[ "$cekcloudflare" = "Cloudflare" ]]; then
  cekdomen=$(cat /etc/xray/domain)
  MYIP=$(dig +short "$cekdomen" | head -n 1)
fi
repogithub='kuotavpncom/kuotavpn/main'
repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
if [ $? -ne 0 ]; then
  repopermission='https://www.berkahost.com/permission.txt'
  curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
  if [ $? -ne 0 ]; then
    repopermission='https://raw.githubusercontent.com/kuotavpncom/ip/main/permission.txt'
    curl -s -f -H 'Cache-Control: no-cache, no-store' $repopermission -o /tmp/permission.txt
    if [ $? -ne 0 ]; then
      echo -e "${red}Database Script Gagal Di Akses !${NC}"
      exit 1
    fi
  fi
fi
curl -s -H 'Cache-Control: no-cache, no-store' $repopermission | grep -w "$MYIP" > /tmp/logs.txt
# cek masa aktif
data=( `cat /tmp/logs.txt | grep -E "^### " | awk '{print $2}'` )
for user in "${data[@]}"
do
  exp=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $3}' | sort | uniq` )
  d1=(`date -d "$exp" +%s`)
  d2=(`date -d "$biji" +%s`)
  exp2=$(( (d1 - d2) / 86400 ))
  if [[ "$exp2" -le "0" ]]; then
    echo -e "${red}Script Expired !${NC}"
    echo -e "Contact Admin : t.me/emdevika"
    rm -rf /tmp/logs.txt
    rm -rf /tmp/ipaddress.txt
    exit 1
  else
    echo -e "${green}Script Active !${NC}"
    clear
  fi
done
checkipaddres=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $4}' | sort | uniq` )
if [[ "$MYIP" = "$checkipaddres" ]]; then
  echo -e "${green}IP Address Accepted${NC}"
  clear
else
  echo -e "${red}IP Address Not Found In Our Database${NC}"
  echo -e "Contact Admin : t.me/emdevika"
  rm -rf /tmp/logs.txt
  rm -rf /tmp/ipaddress.txt
  exit 1
fi
clientname=$(cat /usr/local/etc/clientname)
checkclient=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $2}' | sort | uniq` )
if [[ "$clientname" = "$checkclient" ]]; then
  echo -e "${green}Client Name Accepted${NC}"
  clear
else
  echo -e "${red}Client Name Not Compatible !${NC}"
  echo -e "Contact Admin : t.me/emdevika"
  rm -rf /tmp/logs.txt
  rm -rf /tmp/ipaddress.txt
  exit 1
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

mkdir -p /etc/cf-argo/
cekdolo=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
if [[ -z $cekdolo ]]; then
if [[ ! -s /etc/cf-argo/cloudflared-linux ]]; then
    curl -L -sS https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /etc/cf-argo/cloudflared-linux
fi
chmod +x /etc/cf-argo/cloudflared-linux 2>/dev/null
clear
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo "CLOUDFLARE ARGO SETUP"
echo -e "━━━━━━━━━━━━━━━━━━━━"
if [[ ! -s /root/.cloudflared/cert.pem ]]; then
    echo -e "step by step ?\n1. open link\n2. login to dash cloudflare\n3. select your domain\n4. click & authorized\n\n*NOTE: remember what you select"
    sleep 3
    /etc/cf-argo/cloudflared-linux tunnel login
    echo -e "━━━━━━━━━━━━━━━━━━━━"
    echo -e ""
fi
cekdolo=$(cat /root/.cloudflared/*.json 2>/dev/null)
if [[ -z $cekdolo ]]; then
tunnel=argo`</dev/urandom tr -dc X-Z0-9 | head -c5`
/etc/cf-argo/cloudflared-linux tunnel create $tunnel
fi
tunnelID=$(cat /root/.cloudflared/*.json | grep -w "TunnelID" | cut -d: -f4 | tr -d '"' | tr -d '}' 2>/dev/null)
CF_ID=$(cat /etc/cf-argo/cf_id 2>/dev/null)
CF_KEY=$(cat /etc/cf-argo/cf_key 2>/dev/null)
ARGO_DOMAIN=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "ARGO SETUP BY t.me/emdevika"
echo -e "━━━━━━━━━━━━━━━━━━━━"
read -p "CF ID (email cloudflare) : " CF_ID
echo ""
read -p "CF GLOBAL API KEY : " CF_KEY
echo ""
echo "*domain must be same as the chosen and authorized"
read -p "DOMAIN : " DOMAIN
echo "$DOMAIN" > /etc/cf-argo/domain_authorized
echo -e "━━━━━━━━━━━━━━━━━━━━"
main_sub=$(cat /etc/xray/domain | cut -d '.' -f 1)
ARGO_DOMAIN="argo-${main_sub}.${DOMAIN}"
ARGO_DOMAIN_SSH="argo2-${main_sub}.${DOMAIN}"
echo "$ARGO_DOMAIN" > /etc/cf-argo/argo_domain
echo "$ARGO_DOMAIN_SSH" > /etc/cf-argo/argo2_domain
echo "$CF_ID" > /etc/cf-argo/cf_id
echo "$CF_KEY" > /etc/cf-argo/cf_key
TYPE="CNAME"
CF_ID=$(cat /etc/cf-argo/cf_id)
CF_KEY=$(cat /etc/cf-argo/cf_key)
ARGO_DOMAIN=$(cat /etc/cf-argo/argo_domain)
ARGO_DOMAIN_SSH=$(cat /etc/cf-argo/argo2_domain)
DESTINATION="$tunnelID.cfargotunnel.com"
set -euo pipefail
sleep 2
#==============#

# Get Zone ID
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

#==============#

create_CNAME_record() {
  response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "'$TYPE'",
      "name": "'$ARGO_DOMAIN'",
      "content": "'$DESTINATION'",
      "ttl": 0,
      "proxied": true
    }')
}
create_CNAME_record
create_CNAME_record() {
  response=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json" \
    --data '{
      "type": "'$TYPE'",
      "name": "'$ARGO_DOMAIN_SSH'",
      "content": "'$DESTINATION'",
      "ttl": 0,
      "proxied": true
    }')
}
create_CNAME_record

#==============#
cat > "/etc/cf-argo/config.yml" << EOF
tunnel: $tunnelID
credentials-file: /root/.cloudflared/$tunnelID.json

ingress:
  - hostname: $ARGO_DOMAIN
    service: http://localhost:21407
  - hostname: $ARGO_DOMAIN_SSH
    service: http://localhost:21408
  - service: http_status:404
EOF
#
cat > /etc/systemd/system/named-argo.service << EOF
[Unit]
Description=Cloudflare Tunnel
After=network.target

[Service]
ExecStart=/etc/cf-argo/cloudflared-linux tunnel --edge-ip-version auto --config /etc/cf-argo/config.yml run
Restart=on-failure
User=root
Group=root
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
#
if ! grep -q "listen 127.0.0.1:21408" /etc/nginx/conf.d/vmnone.conf; then
    sed -i "/server {/a\    listen 127.0.0.1:21408 backlog=65535 reuseport default_server;" /etc/nginx/conf.d/vmnone.conf
    systemctl restart nginx
fi
#
systemctl daemon-reload
systemctl enable named-argo.service
systemctl start named-argo.service
systemctl restart named-argo.service
# ARGO FALLBACK
if [[ ! -s /etc/cf-argo/config.json ]]; then
uuid=$(cat /proc/sys/kernel/random/uuid)
pathmain="argo"
cat>/etc/cf-argo/config.json<<EOF
{
    "log":{
        "access":"/var/log/xray/access3.log",
        "error":"/var/log/xray/error3.log",
        "loglevel":"info"
    },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
      {
            "tag": "$pathmain-vlessxtls",
            "listen":"127.0.0.1",
            "port":21407,
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "flow":"xtls-rprx-vision"
                    }
                ],
                "decryption":"none",
                "fallbacks":[
                    {
                        "path":"/${pathmain}-vl",
                        "dest":3002
                    },
                    {
                        "path":"/${pathmain}-vm",
                        "dest":3003
                    },
                    {
                        "path":"/${pathmain}-tr",
                        "dest":3004
                    },
                    {
                        "path":"/${pathmain}-vlu",
                        "dest":3005
                    },
                    {
                        "path":"/${pathmain}-vmu",
                        "dest":3006
                    },
                    {
                        "path":"/${pathmain}-tru",
                        "dest":3007
                    }
                ]
            },
            "streamSettings":{
                "network":"tcp"
            }
        },
        {
            "tag": "$pathmain-vlessws",
            "port":3002,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "level":0
                    }
#vlessws
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"/${pathmain}-vl"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag": "$pathmain-vmessws",
            "port":3003,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "alterId":0
                    }
#vmessws
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"/${pathmain}-vm"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag": "$pathmain-trojanws",
            "port":3004,
            "listen":"127.0.0.1",
            "protocol":"trojan",
            "settings":{
                "clients":[
                    {
                        "password":"${uuid}"
                    }
#trojanws
                ]
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"/${pathmain}-tr"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag": "$pathmain-vlessupgrade",
            "port":3005,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "level":0
                    }
#vlessupgrade
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"httpUpgrade",
                "security":"none",
                "httpUpgradeSettings":{
                    "path":"/${pathmain}-vlu"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag": "$pathmain-vmessupgrade",
            "port":3006,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "level":0
                    }
#vmessupgrade
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"httpUpgrade",
                "security":"none",
                "httpUpgradeSettings":{
                    "path":"/${pathmain}-vmu"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag": "$pathmain-trojanupgrade",
            "port":3007,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${uuid}",
                        "level":0
                    }
#vmessupgrade
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"httpUpgrade",
                "security":"none",
                "httpUpgradeSettings":{
                    "path":"/${pathmain}-tru"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls",
                    "quic"
                ],
                "metadataOnly":false
            }
        }
],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "tag": "IPv4-out"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      },
      "tag": "IPv6-out"
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "streamSettings": {
        "sockopt": {
          "tcpFastOpen": true
        }
      },
      "type": "field",
      "tag": "api"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "domain": [
          "geosite:category-ads-all",
          "geosite:category-ads-ir",
          "geosite:google-ads",
          "geosite:spotify-ads",
          "geosite:adobe-ads",
          "geosite:apple-ads"
        ]
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService",
      "HandlerService",
      "ReflectionService",
      "LoggerService"
    ],
    "tag": "api"
  },
  "sniffing": {
    "enabled": true,
    "destOverride": [
      "http",
      "tls",
      "quic"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  }
}
EOF
fi
# Create systemd service for Xray
cat > "/etc/systemd/system/argo-xray.service" << EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=nobody
Group=nogroup
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/cf-argo/config.json
RestartSec=5
Restart=always
SyslogIdentifier=xray
LimitNOFILE=infinity
OOMScoreAdjust=100

[Install]
WantedBy=multi-user.target
EOF

systemctl enable argo-xray.service 2>/dev/null
systemctl start argo-xray.service 2>/dev/null
systemctl restart argo-xray.service 2>/dev/null
sleep 2
echo ""
echo -e "ALL COMPLETE !"
else
CF_ID=$(cat /etc/cf-argo/cf_id)
CF_KEY=$(cat /etc/cf-argo/cf_key)
ARGO_DOMAIN=$(cat /etc/cf-argo/argo_domain 2>/dev/null)
ARGO_DOMAIN_SSH=$(cat /etc/cf-argo/argo2_domain 2>/dev/null)
DOMAIN=$(cat /etc/cf-argo/domain_authorized 2>/dev/null)
clear
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "ARGO is Succesfully Activate !"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e "ARGO XRAY DOMAIN: $ARGO_DOMAIN"
echo -e "ARGO SSH DOMAIN: $ARGO_DOMAIN_SSH"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e " [1]  Restart ARGO"
echo -e " [2]  Disable & Remove ARGO"
echo -e " [x]  Exit"
echo -e "━━━━━━━━━━━━━━━━━━━━"
echo -e ""
read -p " Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
sleep 2
systemctl restart argo-xray.service 2>/dev/null
systemctl restart named-argo.service 2>/dev/null
echo ""
echo "Restart Success !"
;;
2)
echo "Process...."
systemctl stop argo-xray.service 2>/dev/null
systemctl disable argo-xray.service 2>/dev/null
systemctl stop named-argo.service 2>/dev/null
systemctl disable named-argo.service 2>/dev/null
find /etc/cf-argo/ -type f ! -name "*.json" -delete
rm -rf /root/.cloudflared/*
#===============
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
#===============
get_record_id() {
  RECORD_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?name=$ARGO_DOMAIN&type=$TYPE" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')
}
delete_CNAME_record() {
  get_record_id
  response=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$RECORD_ID" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json")
}
delete_CNAME_record
#===============
get_record_idssh() {
  RECORD_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records?name=$ARGO_DOMAIN_SSH&type=$TYPE" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')
}
delete_CNAME_recordssh() {
  get_record_idssh
  response=$(curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$RECORD_ID" \
    -H "X-Auth-Email: $CF_ID" \
    -H "X-Auth-Key: $CF_KEY" \
    -H "Content-Type: application/json")
}
delete_CNAME_recordssh
#===============
sleep 2
echo "Disable & Remove Success !"
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac
fi