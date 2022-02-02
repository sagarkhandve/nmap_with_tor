# [![License](https://img.shields.io/badge/License-MIT-blue)](#license "Go to license section")

##  Author:       Sagar Khandve (i.sagarkhandve@gmail.com)

### Name:	       Nmap With Tor.

### Description:  A script that lets users run full TCP port scans with NMap
###               anonymously through the TOR network. TOR and ProxyChains must be
###               installed and configured, and the TOR daemon must be running.

### Notes:        Please install the following packages:

####			      sudo apt install tor proxychains -y

###     		   Please make sure that your TOR configuration [/etc/tor/torrc] file has the
###                following lines:

####                   SOCKSPort              9050
####                   AutomapHostsOnResolve  1
####                   DNSPort                53530
####                   TransPort              9040

###               And that your ProxyChains configuration [/etc/proxychains.conf] file has the following
###               lines:

####                   dynamic_chain
####                   proxy_dns
####                   tcp_read_time_out 15000
####                   tcp_connect_time_out 8000
####                   [ProxyList]
####                   socks5 127.0.0.1 9050



### Usage:        ./nmap_with_tor.sh <TARGET>

####               (<TARGET> can be an IP address or a FQDN; in the second case,
####                the domain name is securely resolved using tor-resolve)
