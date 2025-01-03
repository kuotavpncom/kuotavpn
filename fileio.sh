#!/usr/bin/env bash
if [[ $(ulimit -c) != "0" ]]; then
  echo "Im Watching You..."
  echo "- @kuotavpn"
  exit 1
fi

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
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
if ! which rsync > /dev/null; then
apt install rsync -y
fi
rm -rf /tmp/logs.txt
rm -rf /tmp/ipaddress.txt
clear

# Author:       Giovanni Giglio
# Email:        giovannimaria.giglio@gmail.com
# Description:  file.io utility for uploading and downloading files
# Usage:        fileio -u [args] | -d [args] | -h

function print_help {
    cat << EOF

Usage: fileio -u [args] | -d [args] | -h
file.io utility for uploading and downloading files.

    -u, --upload     uploads \$1 to https://file.io/
    -d, --download   downloads \$1 and saves it into \$2, or into stdout if not provided
    -e, --expires    set expiration period to \$1 (use only with -u)
    -h, --help       prints this help and exit

Expiration period argument accepts this type of pattern: n[d(ays),w(eeks),m(onths),y(ears)]
where 'n' has to be an integer greater than 0, followed by one letter in [dwmy].
If the expiration period is not provided it will be the default value of 14 days set by https://file.io/.

Please report any bug to https://github.com/GioGiglio/fileio-client/issues/
EOF
}


function error_exit {
    >&2 echo "${progname}: ${1:-"Unknown error"}" 1>&2
    exit 1
}

function error_usage {
    >&2 echo "${1:- }"
    >&2 echo "${progname}: usage: $progname -u [args] | -d [args] | -h"
    >&2 echo "$progname --help for further info"
    exit 1
}


# Perform checks to arguments provided by user
# 
# Globals:   arg_upload, arg_download, arg_expires, file, output, expiration
# Arguments: None
# Returns:   None

function checks {
    # parse args #
    while [[ $# -gt 0 ]]; do
    	case $1 in
    	    -u | --upload )
                arg_upload=1
                file=$2
                shift
                shift
                ;;
            -d | --download )
                arg_download=1
                file=$2
                output=${3:-/dev/stdout}
                shift
                shift
                shift
                ;;
            -e | --expires )
                arg_expires=1
                expiration=$2
                shift
                shift
                ;;
            -h | --help )
                print_help
                exit 0
                ;;
            *)
                error_usage "Invalid option $1"
                ;;
        esac
    done

    # check args validity #
    if ! [ -z ${arg_upload:+$arg_download} ]; then
        # both -u and -d are set
        error_usage "cannot upload and download"
    fi

    if [ -z ${arg_upload:-$arg_download} ]; then
        # both -u and -d are not set
        error_usage
    fi

    # check $file validity #
    # check if $file exists, if $arg_upload is set #
    if [ -z "$file" ] || ( ! [ -z ${arg_upload+x} ]  && ! [ -e "$file" ] ); then
        error_usage "file $file is not valid"
    fi

    # check $file size, if $arg_upload is set #
    if ! [ -z ${arg_upload+x} ] && [ "$(wc -c < "$file" )" -gt "$max_file_size" ]; then
        error_exit "$file does not respect the 5GB limit"
    fi

    # check expiration period #
    if ! [ -z ${arg_expires+x} ]; then
        if [ -z "$expiration" ]; then
            error_exit "please provide an expiration period"
        elif ! [[ "$expiration" =~ ^[1-9][0-9]*[dwmy]$ ]]; then
            error_exit "expiration period not valid"
        fi
    fi

    # check $output file variable, if $arg_download is set #
    if ! [ -z ${arg_download+x} ] && [ -z "$output" ]; then
        error_usage 'provide an output file'
    fi
}


# Parses curl's output for file's upload, and prints info to stdout.
# If xclip is installed, copies the download link to system clipboard
#
# Global:    None
# Arguments: curl_output
# Returns:   None

function parse_response {
    IFS=',' read -a tokens <<< $(echo "$1" | tr -d '"{}')

    # if success:false #
    if [ "${tokens[0]}" == 'success:false' ]; then
        >&2 echo '-- error from https://file.io'
        >&2 echo "${tokens[@]:1}"
        exit 1
    fi

    # print all tokens except first
    for token in "${tokens[@]:1}"; do
        tput 'bold'
        printf '[ %6s ] => ' "$(cut -d ':' -f 1 <<< "$token")"
        tput 'sgr0'
        cut -d ':' -f 2- <<< "$token"
    done

    # if xclip is installed, copy link to clipboard
    if command -v xclip &> /dev/null; then
        grep -E -o 'https://file.io/\w+' <<< "${tokens[@]}" | xclip -selection clipboard
        echo '-- link copied to clipboard'
    fi
}


# Upload file to file.io using curl
#
# Global:    arg_expires, url, expiration, file
# Arguments: None
# Returns:   None

function upload {
    # if expires is set #
    if ! [ -z ${arg_expires+x} ]; then
        # add expiration token to url
        url="${url}/?expires=${expiration}"
    fi

    >&2 echo "-- uploading $file to https://file.io/"
    response=$(curl -F "file=@${file}" "$url" 2> /dev/null)

    if [ $? -gt 0 ]; then
        # error while uploading
        error_exit "error while uploading $file"
    else
        parse_response "$response"
    fi
}


# Download a file from file.io using curl
#
# Global:    url, file
# Arguments: None
# Returns:   None

function download {
    # $file refers to the file to be downloaded #

    # add base url to $file, if it is not already contained #
    if ! [[ "$file" =~ ^http ]]; then
        file="${url}/$file"
    fi
    
    >&2 echo "-- downloading $file"
    curl -f -o "$output" "$file" 2> /dev/null

    if [ $? -gt 0 ]; then
        # error
        error_exit "error while downloading $file"
    else
        >&2 echo "-- $file downloaded"
    fi
}

function main {
    progname=$(basename "$0")
    max_file_size=5000000000 # 5GB
    url='https://file.io'

    checks "$@"

    if ! [ -z ${arg_upload+x} ]; then
        upload
    elif ! [ -z ${arg_download+x} ]; then
        download
    fi
}

main "$@"
