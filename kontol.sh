#!/usr/bin/env bash

domain=$(cat /etc/xray/domain)
uuid=$(cat /proc/sys/kernel/random/uuid)
# custom path
trojan_ws_path="/trojanws"
vless_ws_path="/vlessws"
vmess_tcp_path="/vmesstcp"
vmess_ws_path="/vmessws"
vmess_upgrade_path="/vmessupgrade"
vless_upgrade_path="/vlessupgrade"
trojan_upgrade_path="/trojanupgrade"
trojan_grpc_path="trojangrpc"
vless_grpc_path="vlessgrpc"
vmess_grpc_path="vmessgrpc"
mkdir -p /etc/xray/path/
touch /etc/xray/path/trojan_ws_path
touch /etc/xray/path/vless_ws_path
touch /etc/xray/path/vmess_tcp_path
touch /etc/xray/path/vmess_ws_path
touch /etc/xray/path/vmess_upgrade_path
touch /etc/xray/path/vless_upgrade_path
touch /etc/xray/path/trojan_upgrade_path
touch /etc/xray/path/trojan_grpc_path
touch /etc/xray/path/vless_grpc_path
touch /etc/xray/path/vmess_grpc_path
echo $trojan_ws_path > /etc/xray/path/trojan_ws_path
echo $vless_ws_path > /etc/xray/path/vless_ws_path
echo $vmess_tcp_path > /etc/xray/path/vmess_tcp_path
echo $vmess_ws_path > /etc/xray/path/vmess_ws_path
echo $vmess_upgrade_path > /etc/xray/path/vmess_upgrade_path
echo $vless_upgrade_path > /etc/xray/path/vless_upgrade_path
echo $trojan_upgrade_path > /etc/xray/path/trojan_upgrade_path
echo $trojan_grpc_path > /etc/xray/path/trojan_grpc_path
echo $vless_grpc_path > /etc/xray/path/vless_grpc_path
echo $vmess_grpc_path > /etc/xray/path/vmess_grpc_path

cat > /usr/local/etc/xray/will666.json << END 
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
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
            "tag": "vless-xtls",
            "port": 1369,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "flow": "xtls-rprx-vision",
                        "level": 0,
                        "email": "user"
                    }
#vlessxtls
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 1310,
                        "xver": 1
                    },
                    {
                        "alpn": "h2",
                        "dest": 31302,
                        "xver": 1
                    },
                    {
                        "path": "$trojan_ws_path",
                        "dest": 1320,
                        "xver": 1
                    },
                    {
                        "path": "$vless_ws_path",
                        "dest": 1234,
                        "xver": 1
                    },
                    {
                        "path": "$vmess_tcp_path",
                        "dest": 2345,
                        "xver": 1
                    },
                    {
                        "path": "$vmess_ws_path",
                        "dest": 3456,
                        "xver": 1
                    },
                    {
                        "path": "$vmess_upgrade_path",
                        "dest": 4567,
                        "xver": 1
                    },
                    {
                        "path": "$vless_upgrade_path",
                        "dest": 5678,
                        "xver": 1
                    },
                    {
                        "path": "$trojan_upgrade_path",
                        "dest": 6789,
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "tls",
                "tlsSettings": {
                    "alpn": [
                        "h2",
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "/etc/ssl/private/fullchain.pem",
                            "keyFile": "/etc/ssl/private/privkey.pem",
                            "ocspStapling": 3600,
                            "usage":"encipherment"
                        }
                    ]
                }
            }
        }
   ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
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
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
{
  "outbounds": [
    {
      "protocol": "dns",
      "tag": "dns-out"
    },
    {
      "streamSettings": {
        "sockopt": {
          "mark": 255
        }
      },
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "blackhole"
    },
    {
      "settings": {
        "servers": [
          {
            "port": 10085,
            "address": "127.0.0.1"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      },
      "protocol": "socks",
      "tag": "out"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "dns": {
    "hosts": {
      "dns.tiarap": "174.138.21.128",
      "dns.1host": "76.76.2.38",
      "geosite:category-ads-all": "127.0.0.1"
    },
    "servers": [
      {
        "address": "https://doh.tiarap.org/dns-query",
        "domains": ["geosite:geolocation-!cn"],
        "expectIPs": ["geoip:!cn"]
      },
      "174.138.21.128",
      {
        "address": "174.138.21.128",
        "port": 53,
        "domains": ["geosite:id", "geosite:category-games@id"],
        "expectIPs": ["geoip:id"],
        "skipFallback": true
      },
      {
        "address": "localhost",
        "skipFallback": true
      }
    ]
  },
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Reject",
        "domain": ["geosite:category-ads-all"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": [
          "geosite:private",
          "geosite:apple-id",
          "geosite:google-id",
          "geosite:tld-id",
          "geosite:category-games@id"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "domain": ["geosite:geolocation-!cn"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": ["geosite:id"]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "network": "tcp,udp"
      }
    ]
  },
  "inbounds": [
    {
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "port": 53,
        "network": "udp",
        "address": "174.138.21.128"
      },
      "tag": "dns-in",
      "listen": "127.0.0.1"
    }
  ]
}
END

cat > /usr/local/etc/xray/will69.json << END 
{
  "log": {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "info"
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
            "tag": "trojan-tcp",
            "port": 1310,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "$uuid",
                        "level": 0,
                        "email": "user"
                    }
#trojantcp
                ],
                "fallbacks": [
                    {
                        "dest": 2052
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true
                }
            }
        }
        ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
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
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
{
  "outbounds": [
    {
      "protocol": "dns",
      "tag": "dns-out"
    },
    {
      "streamSettings": {
        "sockopt": {
          "mark": 255
        }
      },
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "blackhole"
    },
    {
      "settings": {
        "servers": [
          {
            "port": 10085,
            "address": "127.0.0.1"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      },
      "protocol": "socks",
      "tag": "out"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "dns": {
    "hosts": {
      "dns.tiarap": "174.138.21.128",
      "dns.1host": "76.76.2.38",
      "geosite:category-ads-all": "127.0.0.1"
    },
    "servers": [
      {
        "address": "https://doh.tiarap.org/dns-query",
        "domains": ["geosite:geolocation-!cn"],
        "expectIPs": ["geoip:!cn"]
      },
      "174.138.21.128",
      {
        "address": "174.138.21.128",
        "port": 53,
        "domains": ["geosite:id", "geosite:category-games@id"],
        "expectIPs": ["geoip:id"],
        "skipFallback": true
      },
      {
        "address": "localhost",
        "skipFallback": true
      }
    ]
  },
  "routing": {
    "rules": [
      {
        "type": "field",
        "outboundTag": "Reject",
        "domain": ["geosite:category-ads-all"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": [
          "geosite:private",
          "geosite:apple-id",
          "geosite:google-id",
          "geosite:tld-id",
          "geosite:category-games@id"
        ]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "domain": ["geosite:geolocation-!cn"]
      },
      {
        "type": "field",
        "outboundTag": "Direct",
        "domain": ["geosite:id"]
      },
      {
        "type": "field",
        "outboundTag": "Proxy",
        "network": "tcp,udp"
      }
    ]
  },
  "inbounds": [
    {
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "port": 53,
        "network": "udp",
        "address": "174.138.21.128"
      },
      "tag": "dns-in",
      "listen": "127.0.0.1"
    }
  ]
}
END

systemctl enable will666
systemctl start will666
systemctl restart will666
systemctl enable will69
systemctl start will69
systemctl restart will69