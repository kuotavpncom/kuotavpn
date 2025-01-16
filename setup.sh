#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

if [ "$(whoami)" != "root" ]; then
    echo "Only user root can use this script!"
    echo "Read : https://t.me/autoscript_willstore69/109"
    exit 0
fi

source /etc/os-release
release=$ID
ubuntu_version=$(lsb_release -a 2>/dev/null | awk '/Description/ {print $2, $3}' | cut -d. -f1 | awk {'print $2'} | cut -d. -f1)
debian_version=$(lsb_release -a 2>/dev/null | grep -w "Release" | awk {'print $2'})

if [[ "${release}" == "ubuntu" ]]; then
if [[ "$ubuntu_version" -ge 22 ]]; then
export DEBIAN_FRONTEND=noninteractive
fi
fi

if [[ "${release}" == "debian" ]]; then
if [[ "$debian_version" -ge 11 ]]; then
export DEBIAN_FRONTEND=noninteractive
fi
fi

apt update -y && apt upgrade -y && sleep 1 && apt install curl -y && apt install figlet -y && apt install lolcat -y && apt install dnsutils -y && apt install bind9-dnsutils -y && apt install socat -y && apt install jq -y

bold='\033[1m'
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
source /etc/os-release
OS=$ID
if [[ $OS == 'debian' ]]; then
cp /usr/games/lolcat /usr/bin
fi
sleep 1
IP=$(curl -sS ipinfo.io/ip > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
if [ -z "$MYIP" ]; then
IP=$(curl -sS http://ip-api.com/json | jq .query | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi
if [ -z "$MYIP" ]; then
IP=$(curl -sS ipinfo.io | jq .ip | tr -d '"' > /tmp/ipaddress.txt)
MYIP=$(cat /tmp/ipaddress.txt)
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
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
clear

# data server
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
cekcloudflare=$(curl -sS http://ip-api.com/json | jq .as | grep -o "Cloudflare")
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
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
rm -rf /root/setup.sh
exit 1
else
echo -e "${green}Script Active !${NC}"
clear
fi
done

# cek ip address
checkipaddres=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $4}' | sort | uniq` )
if [[ "$MYIP" = "$checkipaddres" ]]; then
echo -e "${green}IP Address Accepted${NC}"
clear
else
echo -e "${red}IP Address Not Found In Our Database${NC}"
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
rm -rf /root/setup.sh
exit 1
fi

clear
# validasi client name ada/engga
valid_client="/usr/local/etc/clientname"
if [ -s "$valid_client" ]; then
  echo "Client name file already exists and has content. Skipping client name input."
else
  echo ""
  echo "Please Enter Your Client name"
  read -p "Client Name : " clientname
  if [[ $clientname == "" ]]; then
    echo -e "${red}Please Input Your Client Name !${NC}"
    rm -rf setup.sh
    exit 0
  fi
  mkdir -p /usr/local/etc/
  touch /usr/local/etc/clientname
  echo $clientname > /usr/local/etc/clientname
  echo -e "Checking Client Name Please Wait...."
  sleep 1
fi

# cek client name
clientname=$(cat /usr/local/etc/clientname)
checkclient=( `grep -E "^### $data" "/tmp/logs.txt" | awk '{print $2}' | sort | uniq` )
if [[ "$clientname" = "$checkclient" ]]; then
echo -e "${green}Client Name Accepted${NC}"
clear
else
echo -e "${red}Client Name Not Compatible !${NC}"
echo -e "Contact Admin : t.me/kuotavpn"
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
rm -rf /root/setup.sh
rm -rf /usr/local/etc/clientname
exit 1
fi
clear

echo -e "                 ${green}AUTOSCRIPT INSTALLER v1${NC}  -  ${bold}©2020-2025${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "     $red TELEGRAM $NC : t.me/kuotavpn"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
while [[ ! "$opsi" =~ ^[1-2]$ ]]
do
echo ""
echo -e "${bold}Silahkan Pilih !:"
echo -e "1. Menggunakan Domain Sendiri [using your own domain]"
echo -e "2. Menggunakan Domain Dari Script [using domain from script]${NC}"
echo ""
read -p "Masukkan angka opsi: " -n 1 -r opsi
if [[ $opsi == "1" ]]; then
echo ""
sleep 3
echo "Opsi 1 terpilih ✓"
read -p "Input Your Domain  : " domen
echo ""
sleep 1
echo -e "Tutorial How to Pointing NS Domain"
echo -e "Readme : https://t.me/kuotavpn_info/5"
echo ""
read -p "Input Your NS Domain : " domens
echo "Proses... Mohon Menunggu"
sleep 2
mkdir /var/lib/premium-script;
mkdir -p /etc/xray/
mkdir -p /etc/v2ray/
mkdir -p /etc/ns/
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/ns/domain
echo "IP=$domen" > /var/lib/premium-script/ipvps.conf
echo $domen > /etc/xray/domain
echo $domen > /etc/v2ray/domain
echo $domens > /etc/ns/domain
sleep 1
elif [[ $opsi == "2" ]]; then
echo ""
echo "Opsi 2 terpilih ✓"
sleep 2
echo -e "Anda Akan Menggunakan Domain ${bold}scriptwill.web.id${NC}"
sleep 2
echo -e "Dengan Random Subdomain Yang Dipilih Oleh Script"
sleep 2
echo -e "Tetapi Jika IP Anda Telah Terdeteksi Pernah Menggunakan Domain Dari Script."
sleep 1
echo -e "${bold}System Akan Memprioritaskan Itu.${NC}"
sleep 4
  echo "Check Domain...."
  sleep 3
MYIP=$(curl ipinfo.io/ip)
AUTH_EMAIL="dgixtc@gmail.com"
AUTH_KEY="f44847be3b4ca679147d6ee0b984fc215b6a3"
DOMAIN="scriptwill.web.id"

ZONE_ID=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${AUTH_EMAIL}" \
     -H "X-Auth-Key: ${AUTH_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

DNS_RECORDS=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?per_page=1000" \
-H "X-Auth-Email: $AUTH_EMAIL" \
-H "X-Auth-Key: $AUTH_KEY" \
-H "Content-Type: application/json")

echo "${DNS_RECORDS}" | jq -r '.result[] | @base64' > /tmp/hasil-enc.txt
base64 -d /tmp/hasil-enc.txt > /tmp/decoded_file.txt
dns_record_json=$(cat /tmp/decoded_file.txt)
id=$(echo "${dns_record_json}" | jq -r '.id')
type=$(echo "${dns_record_json}" | jq -r '.type')
name=$(echo "${dns_record_json}" | jq -r '.name')
content=$(echo "${dns_record_json}" | jq -r '.content')
echo "$name" > /tmp/hasil-name.txt
echo "$content" > /tmp/hasil-content.txt
paste /tmp/hasil-name.txt /tmp/hasil-content.txt > /tmp/hasil-paste.txt
ip_hasil=$(cat /tmp/hasil-paste.txt | grep -w "$MYIP")
if [ -z "$ip_hasil" ]; then
echo ""
echo "Tidak Ada IP Yang Terdaftar Di System..."
sleep 2
echo "Pointing IP Otomatis...."
sleep 3
wget --no-check-certificate -q https://raw.githubusercontent.com/$repogithub/cf.sh && chmod +x cf.sh && ./cf.sh && rm -rf cf.sh
else
cek_domain=$(cat /tmp/hasil-paste.txt | grep -w "$MYIP" | awk {'print $1'} | tr -d '*' | head -1 | sed 's/^\.//')
echo ""
echo "IP $MYIP Pernah Dipointing Dengan $cek_domain"
echo "System Akan Otomatis Melanjutkan Dengan Domain : $cek_domain"
sleep 3
mkdir /var/lib/premium-script;
mkdir -p /etc/xray/
mkdir -p /etc/v2ray/
mkdir -p /etc/ns/
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/ns/domain
echo "IP=$cek_domain" >> /var/lib/premium-script/ipvps.conf
echo $cek_domain > /etc/xray/domain
echo $cek_domain > /etc/v2ray/domain
echo dns.$cek_domain > /etc/ns/domain
fi
fi
done

sleep 3
source /etc/os-release
OS=$ID
if [[ $OS == 'debian' ]]; then
cp /usr/games/lolcat /usr/bin
fi
clear
sleep 1
domainku=$(cat /etc/xray/domain)
echo "Your Domain Is $domainku"
echo -e "$green Starting..... $NC"
sleep 2
LOOKUP=$(nslookup "$domainku" | awk -F':' '/^Address: / { matched = 1 } matched { print $2}' | grep "$MYIP" | cut -d " " -f 2);
echo -e "$green Check Domain Is valid and pointed To IP Address $NC"
sleep 2
if [[ $MYIP = $LOOKUP ]]; then
echo -e "$green Domain is Valid ! $NC"
else
echo -e "$red UPS ! looks like the domain you entered is not valid"
echo -e "$red please recheck the domain you entered is correct"
echo -e "$red please point the domain to ip and try again $NC"
exit 0
fi 

# added directory
mkdir -p /etc/xray/ && mkdir -p /etc/v2ray/ && mkdir -p /etc/xray/vmess/ && mkdir -p /etc/william/ && touch /etc/xray/domain && touch /etc/v2ray/domain && mkdir -p /var/lib/premium-script/ && touch /var/lib/premium-script/ipvps.conf && touch /etc/william/subscribe

hostnameku=$( cat /etc/xray/domain )
echo -e "Checking Certificate...."
mkdir -p /etc/ssl/private/
mkdir -p /etc/ssl/private/
touch /etc/ssl/private/fullchain.pem
touch /etc/ssl/private/privkey.pem
FILEEXX=/etc/ssl/private/fullchain.pem
if [[ -z $(grep '[^[:space:]]' $FILEEXX) ]] ; then
echo -e "${yellow}Certificate Not Found !${NC}"
echo -e "Starting Added Certificate Please wait..."
sleep 3
apt install -y socat
export ACME_USE_WGET=1
if ! [ -d /root/.acme.sh ];then curl https://get.acme.sh | sh;fi
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --upgrade --auto-upgrade  && /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d $hostnameku --standalone --keylength ec-384 --force && ~/.acme.sh/acme.sh --install-cert -d $hostnameku --ecc --fullchain-file /etc/ssl/private/fullchain.pem --key-file /etc/ssl/private/privkey.pem
sleep 1
chown -R nobody:nogroup /etc/ssl/private/
chmod 777 /etc/ssl/private/
chmod +x /etc/ssl/private/fullchain.pem
chmod +x /etc/ssl/private/privkey.pem
else
echo -e "${green}Certificate Found ! skipped.${NC}"
fi
sleep 1
clear
spinner_modern_unicode() {
  local pid=$1
  local spinner=( "🌑" "🌒" "🌓" "🌔" "🌕" "🌖" "🌗" "🌘" )
  while kill -0 $pid 2>/dev/null; do
    for symbol in "${spinner[@]}"; do
      printf "\rProcess Setup SC: %s" "$symbol"
      sleep 0.1
    done
  done
  printf "\rSetting up: Done\n"
}

random_text() {
  local texts=(
  "Jangan khawatir, kamu gagal hari ini, tapi masih ada besok untuk gagal lagi."
  "Kalau kamu merasa gagal, coba lihat orang lain, mereka juga nggak lebih baik."
  "Sukses itu seperti Wi-Fi, kadang susah didapat, tapi kamu nggak pernah berhenti mencari."
  "Kalau kamu nggak bisa sukses, at least jadi yang paling keren dalam kegagalan!"
  "Jangan khawatir, yang penting kamu masih ada, meskipun nggak sukses-sukses juga."
  "Sukses itu overrated, yang penting tetap bisa ketawa meski hidup gak adil."
  "Pekerjaan gak akan lari, tapi kamu juga gak akan jadi muda lagi."
  "Jangan terlalu serius, hidup ini juga nggak serius-serius amat kok."
  "Tugas numpuk? Tenang aja, dunia gak akan berakhir."
  "Kalau hidup cuma soal pilihan, kenapa ya banyak yang milih untuk ngeluh?"
  "Sukses itu mudah, asal kamu nggak bingung memilih antara tidur atau bekerja."
  "Mau sukses? Coba aja nanya ke orang yang udah sukses, mereka juga bingung kenapa mereka bisa."
  "Orang yang sukses biasanya cuma punya satu kebiasaan: berani gagal berkali-kali."
  "Jangan terlalu banyak rencana, kadang hidup nggak sesuai jadwal."
  "Hidup itu soal timing. Sayangnya, kamu nggak punya jam yang tepat."
  "Kesalahan? Bukan masalah, yang penting kamu tetap terlihat sibuk!"
  "Jangan khawatir, dunia nggak akan berhenti berputar hanya karena kamu malas."
  "Sukses itu datangnya pelan-pelan, tapi mundur jauh lebih cepat."
  "Jangan tanya kenapa kamu gagal, tanya kenapa kamu masih punya harapan."
  "Kamu gagal? Tenang, yang sukses juga sering gagal kok... cuma beda timing aja."
  "Setiap kegagalan adalah kesempatan untuk mencoba lebih buruk lagi."
  "Jangan buru-buru sukses, biar yang lain merasa lebih enak hidupnya."
  "Kadang hidup itu simpel: Cukup tidur, makan, dan cemas tentang masa depan."
  "Mimpi itu gratis, tapi kenyataannya bayar mahal, dan kadang kamu malah kena denda."
  "Kamu udah berusaha? Mungkin lebih baik kalau kamu cuma tidur, setidaknya itu lebih produktif."
  "Punya mimpi besar? Sayangnya, mimpi gak bayar tagihan listrik, kan?"
  "Kenapa takut gagal? Gagal itu cuma bukti kamu mencoba, meski sebenarnya kamu nggak punya pilihan lain."
  "Kamu selalu bilang 'nanti', padahal 'nanti' nggak akan pernah datang kalau kamu nggak bergerak sekarang."
  "Kamu mikir sukses itu gampang? Kalau gitu, kenapa hidupmu masih sama aja setiap tahun?"
  "Apa yang kamu lakukan selama ini benar-benar untuk dirimu, atau sekadar untuk memenuhi ekspektasi yang tak pernah kamu pilih?"
  "Hidupmu penuh dengan tujuan yang belum jelas, atau kamu hanya mengikuti arus tanpa tahu ke mana?"
  "Setiap hari kamu bangun untuk apa? Untuk melanjutkan rutinitas yang kamu benci, atau untuk menemukan alasan mengapa kamu harus bertahan?"
  "Kamu mengejar apa sebenarnya? Apakah itu kebahagiaan, atau hanya pelarian dari kenyataan?"
  "Ketika kamu melihat ke cermin, apakah kamu melihat dirimu yang sebenarnya, atau hanya bayangan dari apa yang orang lain inginkan?"
  "Apa yang kamu perjuangkan? Pencapaian yang membanggakan, atau sekadar pengakuan dari mereka yang tak pernah memahami dirimu?"
  "Apakah ada arti dari semua usaha ini, atau semuanya hanya akan dilupakan dalam ingatan orang lain?"
  "Kamu pernah bertanya pada diri sendiri, apakah hidup ini memang layak diperjuangkan, atau hanya sebuah permainan waktu yang sia-sia?"
  "Mungkin kamu sudah lelah mencoba, tapi pernahkah kamu bertanya, kenapa kamu merasa begitu kosong meski sudah berusaha keras?"
  "Kamu merasa terjebak dalam dunia ini, tapi apakah kamu pernah berpikir mungkin kamu hanya terjebak dalam ilusi yang kamu ciptakan sendiri?"
  "Jangan terlalu keras berusaha, hidup nggak akan pernah adil, kok."
  "Bekerja keras itu bagus, tapi terkadang lebih baik tidur dan biarkan dunia berjalan tanpa kamu."
  "Kamu pikir kamu sudah berusaha? Coba lihat lagi, mungkin kamu cuma berusaha terlihat sibuk."
  "Tugas menumpuk? Mungkin itu cara hidup bilang, 'Kamu nggak seharusnya sukses.'"
  "Berusaha keras itu overrated, apalagi kalau hasilnya cuma membuatmu lebih lelah."
  "Setiap kali kamu gagal, coba cek apakah kamu benar-benar mencoba, atau cuma mencari alasan untuk gagal lagi."
  "Mimpi itu murah, yang mahal adalah kenyataan yang harus kamu hadapi setiap hari."
  "Kamu pikir masalah hidupmu besar? Ada orang yang bahkan nggak tahu apa tujuan hidupnya."
  "Kamu mungkin merasa gagal, tapi setidaknya kamu lebih tahu apa yang nggak bisa kamu capai."
  "Kenapa kamu merasa gagal? Mungkin karena kamu terlalu sering mengukur diri dengan standar yang nggak pernah jelas."
  "Kadang hidup itu soal memilih jalan, tapi entah kenapa, jalan yang kamu pilih selalu penuh dengan rintangan."
  "Semua orang punya masalah, kecuali mereka yang memilih untuk tidur sepanjang hari dan pura-pura bahagia."
  "Hidupmu nggak akan berubah, kecuali kamu berhenti menunda."
  "Gagal itu biasa, tapi selalu merasa gagal itu pilihan."
  "Kamu cuma berusaha terlihat sibuk, bukan produktif."
  "Kenapa takut gagal? Kamu udah gagal dari awal."
  "Berhenti berharap, karena kenyataan nggak peduli."
  "Coba berhenti cari alasan, dan mulai cari solusi."
  "Mimpi itu indah, tapi kenyataan lebih pahit."
  "Kamu masih berharap? Padahal waktu nggak pernah nunggu."
  "Kamu mau sukses? Coba dulu keluar dari zona nyaman."
  "Bekerja keras? Mungkin lebih baik berhenti berharap."
  "Kamu kalah? Mungkin karena kamu terlalu lama ragu."
  "Bertahan itu nggak selalu berarti kuat, kadang itu cuma bodoh."
  "Jangan terlalu lama berlarut-larut dalam penyesalan."
  "Kamu bernapas, tapi apakah itu tanda hidup atau sekadar kebiasaan?"
  "Mencari arti hidup? Mungkin artinya adalah menerima bahwa itu tak pernah ada."
  "Kamu bertanya apa tujuan hidup, tapi kenapa tak pernah bertanya apa yang kamu korbankan?"
  "Apa yang lebih kosong dari ruang di hatimu? Mungkin hidup yang kamu jalani tanpa arah."
  "Setiap harapan yang kamu bangun, apakah benar-benar milikmu, atau sekadar ilusi yang dipinjam?"
  "Kamu ingin diakui, tapi apakah kamu sendiri tahu siapa dirimu?"
  "Berjuang setiap hari, tapi untuk apa, jika bahkan kamu tak tahu apa yang kamu cari?"
  "Apa gunanya bertahan jika akhirnya semua yang kamu lakukan tak meninggalkan jejak?"
  "Kamu mencari kebahagiaan, tapi apakah kebahagiaan itu nyata atau sekadar pelarian dari rasa sakit?"
  "Hidupmu mungkin berarti sesuatu, tapi apakah kamu yakin ada yang peduli?"
  "Kamu bilang mau berubah, tapi langkahmu cuma muter-muter di tempat."
  "Kamu selalu bilang ‘aku kuat’, tapi kenyataannya kamu cuma takut kelihatan lemah."
  "Hidup ini pilihan, tapi kenapa kamu terus memilih untuk menyesal?"
  "Kamu bilang 'belum waktunya', padahal kamu cuma nggak mau keluar dari zona nyaman."
  "Kamu sering nyalahin keadaan, tapi lupa bahwa kamu juga bagian dari masalahnya."
  "Mau dihargai orang lain? Coba dulu hargai dirimu yang terus kamu abaikan."
  "Kamu cari solusi atau alasan? Kadang jawabannya ada di tindakan, bukan di kata-kata."
  "Kamu bilang hidupmu sulit, padahal kamu sendiri yang bikin semuanya lebih rumit."
  "Kamu sibuk mengejar mimpi, tapi lupa bangun dari kenyataan."
  "Kamu benci hidup yang monoton, tapi nggak pernah punya nyali untuk berubah."
  "Kamu merasa spesial? Padahal kamu cuma satu dari jutaan yang nggak pernah benar-benar berarti."
  "Kamu berharap dihargai, tapi apa yang sudah kamu lakukan layak untuk itu?"
  "Semua orang punya masalah, tapi kenapa kamu selalu merasa masalahmu yang paling penting?"
  "Kamu bilang mau sukses, tapi tindakanmu cuma cocok untuk jadi pecundang."
  "Kamu berpikir semua orang peduli, padahal mereka bahkan nggak tahu kamu ada."
  "Jadilah versi yang lebih baik setiap harinya."
  "Pengen Hidupmu lebih baik ? Berhenti Coli."
)
  while true; do
    random_message=${texts[$RANDOM % ${#texts[@]}]}
    clear
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "autoscript developer: t.me/kuotavpn"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$random_message"
    echo ""
    echo -e "Setting up Process Step #$step..."
    if [ "$step" -eq 8 ]; then
    echo -e "Progress: 99%"
    else
    echo -e "Progress: $((step * 100 / 8))%"
    fi
    sleep 7
  done
}

run_script() {
  local script_url=$1
  local step=$2
  local script_name=$(basename "$script_url")
  random_text &
  local random_pid=$!
  wget --no-check-certificate -q "$script_url" -O "$script_name" &
  local download_pid=$!
  wait $download_pid
  clear
  echo -e "Setting up Process Step #$step..."
  if [ "$step" -eq 8 ]; then
    echo -e "Progress: 99%"
  else
    echo -e "Progress: $((step * 100 / 8))%"
  fi
  chmod +x "$script_name"
  ./"$script_name" > /dev/null 2>&1 &
  local setup_pid=$!
  spinner_modern_unicode $setup_pid
  wait $setup_pid
  kill $random_pid
  rm -rf "$script_name"
  echo "Process Step #$step complete!"
  sleep 1
  clear
}

run_script "https://raw.githubusercontent.com/$repogithub/setup-sshvpn.sh" 1
run_script "https://raw.githubusercontent.com/$repogithub/set-br.sh" 2
run_script "https://raw.githubusercontent.com/$repogithub/ssh-ws-ssl.sh" 3
run_script "https://raw.githubusercontent.com/$repogithub/sstp.sh" 4
run_script "https://raw.githubusercontent.com/$repogithub/wireguard.sh" 5
run_script "https://raw.githubusercontent.com/$repogithub/only-l2tp.sh" 6
run_script "https://raw.githubusercontent.com/$repogithub/requirement.sh" 7
run_script "https://raw.githubusercontent.com/$repogithub/higheros.sh" 8
echo "All steps completed successfully!"
cd
sleep 3
cd /usr/bin
git clone https://github.com/willstore69/subfinders
sleep 1
cd subfinders
pip3 install -r requirements.txt
mv knockpy /usr/bin
mv ingfo /usr/bin
cd /usr/bin
rm -rf /usr/bin/subfinders
chmod +x ingfo
cd
rm -rf log-install.txt
sleep 2
apt install dnsutils -y
apt install rsync -y
apt install gawk -y
sleep 2
chown -R nobody:nogroup /etc/ssl/private/
chmod 777 /etc/ssl/private/
chmod +x /etc/ssl/private/fullchain.pem
chmod +x /etc/ssl/private/privkey.pem
systemctl restart xray
FILEEXX=/etc/ssl/private/fullchain.pem
if [[ -z $(grep '[^[:space:]]' $FILEEXX) ]] ; then
echo -e "${yellow}Certificate Not Found !${NC}"
echo -e "Starting Added Certificate Please wait..."
sleep 3
apt install -y socat
export ACME_USE_WGET=1
if ! [ -d /root/.acme.sh ];then curl https://get.acme.sh | sh;fi
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --upgrade --auto-upgrade  && /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --issue -d $hostnameku --standalone --keylength ec-384 --force && ~/.acme.sh/acme.sh --install-cert -d $hostnameku --ecc --fullchain-file /etc/ssl/private/fullchain.pem --key-file /etc/ssl/private/privkey.pem
sleep 1
chown -R nobody:nogroup /etc/ssl/private/
chmod 777 /etc/ssl/private/
chmod +x /etc/ssl/private/fullchain.pem
chmod +x /etc/ssl/private/privkey.pem
else
echo -e "${green}Certificate Found ! skipped.${NC}"
fi
if ! grep -q -w "del-texp" /etc/crontab; then
echo -e "*/30 * * * * root del-texp" >> /etc/crontab
/etc/init.d/cron restart
fi
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "==========================- AUTOSCRIPT -============================="  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - Webmin                  : 10000"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN TCP             : 1194"  | tee -a log-install.txt
echo "   - OpenVPN UDP             : 2200"  | tee -a log-install.txt
echo "   - OpenVPN SSL             : 442"  | tee -a log-install.txt
echo "   - OpenVPN WS              : 2095"  | tee -a log-install.txt
echo "   - Stunnel5                : 443"  | tee -a log-install.txt
echo "   - SSHWS                   : 2052"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo "   - XRAY TLS                : 443"  | tee -a log-install.txt
echo "   - VMNONE                  : 80"  | tee -a log-install.txt
echo "   - VLNONE                  : 8880"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Sesuai tkp"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Clear Log On            : Every 6 Hours"  | tee -a log-install.txt
echo "   - Auto Delete Expired Acc : 00.00 wib"  | tee -a log-install.txt
echo "   - Autobackup Data Via GMAIL"  | tee -a log-install.txt
echo "   - Autobackup Data Via BOT Telegram"  | tee -a log-install.txt
echo "   - Restore Data"  | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""   | tee -a log-install.txt
echo "   - Dev/Main                : kuotavpn"  | tee -a log-install.txt
echo "   - Telegram                : t.me/kuotavpn"  | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "=================================================================="  | tee -a log-install.txt
echo " Reboot 15 Sec"
cd /root
rm -rf /root/setup*
rm -rf /root/PDirect*
rm -rf /root/cert.pe*
rm -rf /root/key.pe*
rm -rf ip
rm -rf wget-log
rm -rf /root/cf.s*
rm -rf /root/dnst*
rm -rf /root/go
rm -rf /root/stunnel-5*
rm -rf /root/vpn_server_pub_key.pe*
rm -rf /etc/william/Python-2.7.16*
history -c
repo_url="https://api.github.com/repos/kuotavpncom/update_v1/contents/"
files=$(curl -s "$repo_url" | jq -r '.[].name')
latest_file=$(echo "$files" | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+_sc.sh' | sort -V | tail -n 1)
remote_version=$(echo "$latest_file" | sed -E 's/v([0-9]+\.[0-9]+\.[0-9]+)_sc.sh/\1/')
echo "$remote_version" > /home/ver
sleep 15
reboot
