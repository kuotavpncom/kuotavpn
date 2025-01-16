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

chatid=$(cat /home/chatid3 2>/dev/null)
apibot=$(cat /home/apibot3 2>/dev/null)
chatidv2=$(cat /home/apibot3 2>/dev/null)
apibotv2=$(cat /home/apibot3 2>/dev/null)
# VMESS WS
data_vmess=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vmess-ws" | awk {'print $2'} | sort -u)
if [[ -z "$data_vmess" ]]; then
  data_vmess=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vmess-ws" | awk {'print $2'} | sort -u)
fi
for user in $data_vmess; do
  #tls
  user_quota_uplink_tls=$(cat /etc/xray/usage-uplink-tls/$user 2>/dev/null)
  user_quota_downlink_tls=$(cat /etc/xray/usage-downlink-tls/$user 2>/dev/null)
  total_quota_tls=$((user_quota_uplink_tls + user_quota_downlink_tls))
  #ntls
  user_quota_uplink_ntls=$(cat /etc/xray/usage-uplink-ntls/$user 2>/dev/null)
  user_quota_downlink_ntls=$(cat /etc/xray/usage-downlink-ntls/$user 2>/dev/null)
  total_quota_ntls=$((user_quota_uplink_ntls + user_quota_downlink_ntls))
  #sum
  total_quota=$((total_quota_tls + total_quota_ntls))
  size_total_quota=$(echo "scale=2; $total_quota/1024/1024/1024" | bc)
  limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
  if [[ "$limit_quota" -eq 0 ]]; then
    continue
  fi
  size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
  ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$user" | awk '{print $1}' | grep -w "#banned_vmessws" | wc -l)
  if [[ "$ngecek_banned" = "1" ]]; then
  echo -e "user already banned"
  else
if [[ "$total_quota" -gt "$limit_quota" ]]; then
sed -i '/"email": "'"$user"'"/s/,/#banned_vmessws ,/' /usr/local/etc/xray/config.json
sed -i '/"email": "'"$user"'"/s/},/#banned_vmessws },/' /usr/local/etc/xray/none.json
sed -i '/"email": "'"$user"'"/s/,/#banned_vmessws ,/' /etc/cf-argo/config.json
#
echo "❗ Pengingat Limit Quota ❗"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Username: $user"
echo "Protocol: Vmess-WS"
echo "Limit Quota: $size_limit_quota GB"
echo "Quota Usage: $size_total_quota GB"
echo "Action: Banned"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Segera Hubungi Admin @emdevika"
#
curl -s -X POST https://api.telegram.org/bot$apibot/sendMessage \
 -F chat_id="$chatid" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Vmess-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika\`\`\`"
#
curl -s -X POST https://api.telegram.org/bot$apibotv2/sendMessage \
 -F chat_id="$chatidv2" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Vmess-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika\`\`\`"
systemctl restart xray
systemctl restart xray@none
systemctl restart argo-xray
fi
  fi
done

# VLESS WS
data_vless=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vless-ws" | awk {'print $2'} | sort -u)
if [[ -z "$data_vless" ]]; then
  data_vless=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "vless-ws" | awk {'print $2'} | sort -u)
fi
for user in $data_vless; do
  #tls
  user_quota_uplink_tls=$(cat /etc/xray/usage-uplink-tls/$user 2>/dev/null)
  user_quota_downlink_tls=$(cat /etc/xray/usage-downlink-tls/$user 2>/dev/null)
  total_quota_tls=$((user_quota_uplink_tls + user_quota_downlink_tls))
  #ntls
  user_quota_uplink_ntls=$(cat /etc/xray/usage-uplink-ntls/$user 2>/dev/null)
  user_quota_downlink_ntls=$(cat /etc/xray/usage-downlink-ntls/$user 2>/dev/null)
  total_quota_ntls=$((user_quota_uplink_ntls + user_quota_downlink_ntls))
  #sum
  total_quota=$((total_quota_tls + total_quota_ntls))
  size_total_quota=$(echo "scale=2; $total_quota/1024/1024/1024" | bc)
  limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
  if [[ "$limit_quota" -eq 0 ]]; then
    continue
  fi
  ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$user" | awk '{print $1}' | grep -w "#banned_vlessws" | wc -l)
  if [[ "$ngecek_banned" = "1" ]]; then
  echo -e "user already banned"
  else
if [[ "$total_quota" -gt "$limit_quota" ]]; then
sed -i '/"email": "'"$user"'"/s/,/#banned_vlessws ,/' /usr/local/etc/xray/config.json
sed -i '/"email": "'"$user"'"/s/},/#banned_vlessws },/' /usr/local/etc/xray/none.json
#
echo "❗ Pengingat Limit Quota ❗"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Username: $user"
echo "Protocol: Vless-WS"
echo "Limit Quota: $size_limit_quota GB"
echo "Quota Usage: $size_total_quota GB"
echo "Action: Banned"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Segera Hubungi Admin @emdevika"
#
curl -s -X POST https://api.telegram.org/bot$apibot/sendMessage \
 -F chat_id="$chatid" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Vless-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika\`\`\`"
#
curl -s -X POST https://api.telegram.org/bot$apibotv2/sendMessage \
 -F chat_id="$chatidv2" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Vless-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika\`\`\`"
systemctl restart xray
systemctl restart xray@none
fi
  fi
done

# TROJAN WS
data_trojan=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "trojan-ws" | awk {'print $2'} | sort -u)
if [[ -z "$data_trojan" ]]; then
  data_trojan=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $7, $11'} | grep -w "trojan-ws" | awk {'print $2'} | sort -u)
fi
for user in $data_trojan; do
  #tls
  user_quota_uplink_tls=$(cat /etc/xray/usage-uplink-tls/$user 2>/dev/null)
  user_quota_downlink_tls=$(cat /etc/xray/usage-downlink-tls/$user 2>/dev/null)
  total_quota_tls=$((user_quota_uplink_tls + user_quota_downlink_tls))
  #ntls
  user_quota_uplink_ntls=$(cat /etc/xray/usage-uplink-ntls/$user 2>/dev/null)
  user_quota_downlink_ntls=$(cat /etc/xray/usage-downlink-ntls/$user 2>/dev/null)
  total_quota_ntls=$((user_quota_uplink_ntls + user_quota_downlink_ntls))
  #sum
  total_quota=$((total_quota_tls + total_quota_ntls))
  size_total_quota=$(echo "scale=2; $total_quota/1024/1024/1024" | bc)
  limit_quota=$(cat /etc/william/limit-quota/$user 2>/dev/null)
  if [[ "$limit_quota" -eq 0 ]]; then
    continue
  fi
  size_limit_quota=$(echo "scale=2; $limit_quota/1024/1024/1024" | bc)
  ngecek_banned=$(cat /usr/local/etc/xray/config.json | grep -w "$user" | awk '{print $1}' | grep -w "#banned_trojanws" | wc -l)
  if [[ "$ngecek_banned" = "1" ]]; then
  echo -e "user already banned"
  else
if [[ "$total_quota" -gt "$limit_quota" ]]; then
sed -i '/"email": "'"$user"'"/s/,/#banned_trojanws ,/' /usr/local/etc/xray/config.json
sed -i '/"email": "'"$user"'"/s/},/#banned_trojanws },/' /usr/local/etc/xray/none.json
#
echo "❗ Pengingat Limit Quota ❗"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Username: $user"
echo "Protocol: Trojan-WS"
echo "Limit Quota: $size_limit_quota GB"
echo "Quota Usage: $size_total_quota GB"
echo "Action: Banned"
echo "━━━━━━━━━━━━━━━━━━━"
echo "Segera Hubungi Admin @emdevika\`\`\`"
#
curl -s -X POST https://api.telegram.org/bot$apibot/sendMessage \
 -F chat_id="$chatid" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Trojan-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika"
#
curl -s -X POST https://api.telegram.org/bot$apibotv2/sendMessage \
 -F chat_id="$chatidv2" -F parse_mode="MarkdownV2" -F text="\`\`\`yaml
❗ Pengingat Limit Quota ❗
━━━━━━━━━━━━━━━━━━━
Username: $user
Protocol: Trojan-WS
Limit Quota: $size_limit_quota GB
Quota Usage: $size_total_quota GB
Action: Banned
━━━━━━━━━━━━━━━━━━━
Segera Hubungi Admin @emdevika\`\`\`"
systemctl restart xray
fi
  fi
done

sleep 15