#!/bin/bash 

NOW=$(date +”%T”) 

sudo arp-scan –interface=eth0 –localnet > test.$NOW.txt

sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j DROP

cat test.txt | grep 192.168.137.* | awk ‘{print $1}’ > connectedip

CMP connectedip whitelist > CMP.txt

if grep –q differ “CMP.txt”;
	      then 
	     sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j DROP
	    else
 	   sleep 1
	  fi
	 sleep 5
sudo iptables –flush
sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j ACCEPT

rm CMP.txt
rm connectedip
rm test.txt
