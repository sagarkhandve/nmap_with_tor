#!/usr/bin/env bash
#
# Author:       Sagar Khandve (i.sagarkhandve@gmail.com)
#
# Name:	        Nmap With Tor.
#
# Description:  A script that lets users run full TCP port scans with NMap
#               anonymously through the TOR network. TOR and ProxyChains must be
#               installed and configured, and the TOR daemon must be running.
#
# Notes:        
#				Install the given packages:
#
#					sudo apt install -y tor proxychains nmap
#					
#				Please make sure that your TOR configuration [/etc/tor/torrc] file has the
#               following lines:
#
#                   SOCKSPort              9050
#                   AutomapHostsOnResolve  1
#                   DNSPort                53530
#                   TransPort              9040
#
#               And that your ProxyChains configuration [/etc/proxychains.conf] file has the following
#               lines:
#
#                   dynamic_chain
#                   proxy_dns
#                   tcp_read_time_out 15000
#                   tcp_connect_time_out 8000
#                   [ProxyList]
#                   socks5 127.0.0.1 9050
#
#
#
# Usage:        ./nmap_with_tor.sh <TARGET>
#
#               (<TARGET> can be an IP address or a FQDN; in the second case,
#                the domain name is securely resolved using tor-resolve)
#
# --TODO--
# - ???
#
#
################################################################################

# FUNCTIONS --------------------------------------------------------------------

command_exists() {
    command -v "$1" >/dev/null 2>&1 || { echo "Command not found: $1" 1>&2 ; exit 1 ; }
}

valid_ip()
{
    local ip=$1
    local stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] ; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi

    return $stat
}


# CHECKS -----------------------------------------------------------------------

declare -a CMDS=(
"nmap"
"proxychains"
"tor"
"tor-resolve"
);

for CMD in ${CMDS[@]} ; do
    command_exists $CMD
done


# MAIN -------------------------------------------------------------------------

TARGET=$1
SOCKSPORT=9050
OUT="/tmp/${TARGET}.out"

if [[ ! -z ${TARGET} ]] ; then

    if valid_ip ${TARGET} ; then
        :
    else
        TARGET=$(tor-resolve ${TARGET} 127.0.0.1:${SOCKSPORT})
    fi

    #proxychains nmap -4 -sT -Pn -n -vv --open -oG ${OUT} ${TARGET}
    proxychains nmap -4 -F -sT -Pn -n -v --open -oG ${OUT} ${TARGET}
else
    >&2 echo "Error! <TARGET> not specified."
        echo "Usage: ./$(basename $BASH_SOURCE) <TARGET>"
fi
