GET_LINE=$(cat /var/log/syslog | grep -w "kita" | awk {'print $5'} | tr -d "pppd[" | tr -d "]:" | tail -n 1)
SENT=$(cat /var/log/syslog | grep -w "$GET_LINE" | grep -w "bytes" | awk {'print $7'} | tail -n 1)
RECEIVED=$(cat /var/log/syslog | grep -w "$GET_LINE" | grep -w "bytes" | awk {'print $10'} | tail -n 1)
DATE=$(cat /var/log/syslog | grep -w "$GET_LINE" | grep -w "bytes" | awk {'print $1, $2, $3'} | tail -n 1)
echo "=================="
echo "CEK USER LOGIN L2TP"
echo "=================="
echo "User : Kita"
echo "RX : ${SENT} | TX : ${RECEIVED}"
echo "DATE : ${DATE}
echo "=================="