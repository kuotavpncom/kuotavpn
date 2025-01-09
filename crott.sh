#!/usr/bin/bash

domain=$(cat /etc/xray/domain)
uuid=$(cat /proc/sys/kernel/random/uuid)
trojan_ws_path=$(cat /etc/xray/path/trojan_ws_path)
trojan_grpc_path=$(cat /etc/xray/path/trojan_grpc_path)
trojan_upgrade_path=$(cat /etc/xray/path/trojan_upgrade_path)
vless_ws_path=$(cat /etc/xray/path/vless_ws_path)
vless_grpc_path=$(cat /etc/xray/path/vless_ws_path)
vless_upgrade_path=$(cat /etc/xray/path/vless_upgrade_path)
vmess_tcp_path=$(cat /etc/xray/path/vmess_tcp_path)
vmess_ws_path=$(cat /etc/xray/path/vmess_ws_path)
vmess_grpc_path=$(cat /etc/xray/path/vmess_grpc_path)
vmess_upgrade_path=$(cat /etc/xray/path/vmess_upgrade_path)

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
      "tag": "api",
      "sniffing": null
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
      "tag": "api",
      "sniffing": null
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
END

cat > /usr/local/etc/xray/config.json << END 
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
      "tag": "api",
      "sniffing": null
    },
      {
          "tag": "trojan-ws",
          "port": 1320,
          "listen": "127.0.0.1",
          "protocol": "trojan",
          "settings": {
           "clients": [
       {
           "password": "$uuid",
           "level": 0,
           "email": "user"
       }
#trojanws
     ]
  },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "$trojan_ws_path"
         }
      }
    },
        {
            "tag": "vless-ws",
            "port": 1234,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "level": 0,
                        "email": "user"
                    }
#vlessws
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$vless_ws_path"
                }
            }
        },
        {
            "tag": "vmess-tcp",
            "port": 2345,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "level": 0,
                        "email": "user"
                    }
#vmesstcp
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "none",
                "tcpSettings": {
                    "acceptProxyProtocol": true,
                    "header": {
                        "type": "http",
                        "request": {
                            "path": [
                                "$vmess_tcp_path"
                            ]
                        }
                    }
                }
            }
        },
        {
            "tag": "vmess-ws",
            "port": 3456,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "level": 0,
                        "email": "user"
                     }
#vmessws
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$vmess_ws_path"
                }
        }
  },
        {
            "tag": "vmess-upgrade",
            "port": 4567,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "security": "auto"
                    }
#vmessupgrade
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "httpUpgrade",
                "httpUpgradeSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$vmess_upgrade_path"
                }
            }
        },
        {
            "tag": "vless-upgrade",
            "port": 5678,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$uuid",
                        "security": "auto"
                    }
#vlessupgrade
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "httpUpgrade",
                "httpUpgradeSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$vless_upgrade_path"
                }
            }
        },
        {
            "tag": "trojan-upgrade",
            "port": 6789,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "$uuid",
                        "add": "www.cloudflare.com",
                        "email": "user"
                    }
#trojanupgrade
                ]
            },
            "streamSettings": {
                "network": "httpUpgrade",
                "httpUpgradeSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$trojan_upgrade_path"
                }
            }
        },
{
            "tag": "trojan-grpc",
            "port": 31501,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "$uuid",
                        "add": "www.cloudflare.com",
                        "email": "user"
                    }
#trojanGRPCX
                ]
            },
            "streamSettings": {
                "network": "grpc",
                "grpcSettings": {
                    "serviceName": "trojangrpc"
                }
            }
       },
       {
        "tag": "vless-grpc",
        "port": 31502,
        "listen": "127.0.0.1",
        "protocol": "vless",
        "settings": {
            "clients": [
                {
                    "id": "$uuid",
                    "add": "www.cloudflare.com",
                    "email": "user"
                }
#vlessGRPCX
            ],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "vlessgrpc"
            }
        }
    },
       {
        "tag": "vmess-grpc",
        "port": 31503,
        "listen": "127.0.0.1",
        "protocol": "vmess",
        "settings": {
            "clients": [
                {
                    "id": "$uuid",
                    "add": "www.cloudflare.com",
                    "email": "user"
                }
#vmessGRPCX
            ],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmessgrpc"
            }
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
END

cat > /usr/local/etc/xray/none.json << END 
{
  "log": {
    "access": "/var/log/xray/access2.log",
    "error": "/var/log/xray/error2.log",
    "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10086,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api",
      "sniffing": null
    },
    {
      "tag": "vmess-ws",
      "listen": "127.0.0.1",
      "port": 5210,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
#vmessWS
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$vmess_ws_path"
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    },
      {
      "tag": "vless-ws",
      "listen": "127.0.0.1",
      "port": 5211,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${uuid}"
#vlessWS
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$vless_ws_path"
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    },
{
      "tag": "vmess-upgrade",
      "listen": "127.0.0.1",
      "port": 5212,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "alterId": 0
#vmessUPGRADE
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "httpUpgrade",
        "httpUpgradeSettings": {
          "path": "$vmess_upgrade_path"
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
    },
{
      "tag": "vless-upgrade",
      "listen": "127.0.0.1",
      "port": 5213,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "alterId": 0
#vlessUPGRADE
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "httpUpgrade",
        "httpUpgradeSettings": {
          "path": "$vless_upgrade_path"
         },
        "quicSettings": {},
        "sockopt": {
          "mark": 0,
          "tcpFastOpen": true
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      },
      "domain": "$domain"
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
END