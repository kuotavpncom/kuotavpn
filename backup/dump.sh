#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit
fi

# =========== TLS
if [[ ! -e /etc/xray/usage-uplink-tls ]]; then
  mkdir -p /etc/xray/usage-uplink-tls/
fi
if [[ ! -e /etc/xray/usage-downlink-tls ]]; then
  mkdir -p /etc/xray/usage-downlink-tls/
fi

DATA_USER=$(cat /var/log/xray/access.log | grep -w "accepted" | awk {'print $11'} | sort -u | sed '/^$/d')
for user in $DATA_USER; do
  DATA_FILE_UP="/etc/xray/usage-uplink-tls/${user}"
  DATA_FILE_DOWN="/etc/xray/usage-downlink-tls/${user}"
  SERVER="127.0.0.1:10085"
  STAT_NAME_UP="user>>>${user}>>>traffic>>>uplink"
  STAT_NAME_DOWN="user>>>${user}>>>traffic>>>downlink"

  get_stat_up() {
    xray api stats --server=$SERVER -name "$STAT_NAME_UP" | jq -r '.stat.value'
  }

  get_stat_down() {
    xray api stats --server=$SERVER -name "$STAT_NAME_DOWN" | jq -r '.stat.value'
  }

  reset_stat_up() {
    xray api stats --server=$SERVER -name "$STAT_NAME_UP" -reset > /dev/null 2>&1
  }

  reset_stat_down() {
    xray api stats --server=$SERVER -name "$STAT_NAME_DOWN" -reset > /dev/null 2>&1
  }

  load_stat_up() {
    if [ -f $DATA_FILE_UP ]; then
      cat $DATA_FILE_UP
    else
      echo "0"
    fi
  }

  load_stat_down() {
    if [ -f $DATA_FILE_DOWN ]; then
      cat $DATA_FILE_DOWN
    else
      echo "0"
    fi
  }

  save_stat_up() {
    local new_value=$1
    echo $new_value > $DATA_FILE_UP
  }

  save_stat_down() {
    local new_value=$1
    echo $new_value > $DATA_FILE_DOWN
  }

  #up
  current_value_up=$(get_stat_up)
  if [[ $current_value_up =~ ^[0-9]+$ ]]; then
    previous_value_up=$(load_stat_up)
    if [[ $previous_value_up =~ ^[0-9]+$ ]]; then
      total_value_up=$((current_value_up + previous_value_up))
      save_stat_up $total_value_up
      reset_stat_up
    else
      echo "Invalid previous value for uplink: $previous_value_up"
    fi
  else
    echo "Invalid current value for uplink: $current_value_up"
  fi

  #down
  current_value_down=$(get_stat_down)
  if [[ $current_value_down =~ ^[0-9]+$ ]]; then
    previous_value_down=$(load_stat_down)
    if [[ $previous_value_down =~ ^[0-9]+$ ]]; then
      total_value_down=$((current_value_down + previous_value_down))
      save_stat_down $total_value_down
      reset_stat_down
    else
      echo "Invalid previous value for downlink: $previous_value_down"
    fi
  else
    echo "Invalid current value for downlink: $current_value_down"
  fi
done
# =========== NTLS
if [[ ! -e /etc/xray/usage-uplink-ntls ]]; then
  mkdir -p /etc/xray/usage-uplink-ntls/
fi
if [[ ! -e /etc/xray/usage-downlink-ntls ]]; then
  mkdir -p /etc/xray/usage-downlink-ntls/
fi

DATA_USER=$(cat /var/log/xray/access2.log | grep -w "accepted" | awk {'print $11'} | sort -u | sed '/^$/d')

for user in $DATA_USER; do
  DATA_FILE_UP="/etc/xray/usage-uplink-ntls/${user}"
  DATA_FILE_DOWN="/etc/xray/usage-downlink-ntls/${user}"
  SERVER="127.0.0.1:10086"
  STAT_NAME_UP="user>>>${user}>>>traffic>>>uplink"
  STAT_NAME_DOWN="user>>>${user}>>>traffic>>>downlink"

  get_stat_up() {
    xray api stats --server=$SERVER -name "$STAT_NAME_UP" | jq -r '.stat.value'
  }

  get_stat_down() {
    xray api stats --server=$SERVER -name "$STAT_NAME_DOWN" | jq -r '.stat.value'
  }

  reset_stat_up() {
    xray api stats --server=$SERVER -name "$STAT_NAME_UP" -reset > /dev/null 2>&1
  }

  reset_stat_down() {
    xray api stats --server=$SERVER -name "$STAT_NAME_DOWN" -reset > /dev/null 2>&1
  }

  load_stat_up() {
    if [ -f $DATA_FILE_UP ]; then
      cat $DATA_FILE_UP
    else
      echo "0"
    fi
  }

  load_stat_down() {
    if [ -f $DATA_FILE_DOWN ]; then
      cat $DATA_FILE_DOWN
    else
      echo "0"
    fi
  }

  save_stat_up() {
    local new_value=$1
    echo $new_value > $DATA_FILE_UP
  }

  save_stat_down() {
    local new_value=$1
    echo $new_value > $DATA_FILE_DOWN
  }

  #up
  current_value_up=$(get_stat_up)
  if [[ $current_value_up =~ ^[0-9]+$ ]]; then
    previous_value_up=$(load_stat_up)
    if [[ $previous_value_up =~ ^[0-9]+$ ]]; then
      total_value_up=$((current_value_up + previous_value_up))
      save_stat_up $total_value_up
      reset_stat_up
    else
      echo "Invalid previous value for uplink: $previous_value_up"
    fi
  else
    echo "Invalid current value for uplink: $current_value_up"
  fi

  #down
  current_value_down=$(get_stat_down)
  if [[ $current_value_down =~ ^[0-9]+$ ]]; then
    previous_value_down=$(load_stat_down)
    if [[ $previous_value_down =~ ^[0-9]+$ ]]; then
      total_value_down=$((current_value_down + previous_value_down))
      save_stat_down $total_value_down
      reset_stat_down
    else
      echo "Invalid previous value for downlink: $previous_value_down"
    fi
  else
    echo "Invalid current value for downlink: $current_value_down"
  fi
done

sleep 7