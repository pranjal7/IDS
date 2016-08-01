#IDS - Intrusion Detection System 

## Introduction
This system allows users to block any intrusion by blocking the IP Addresses of the intruders. This also adds the IP Address to the blacklist which ensures that the IP address is never used again to access the system

##Configuration and Linux Commands

* The Pi was updated with all the latest updated
  Command: <pre><code> sudo apt-get update </code></pre>
 
* The Pi was upgraded to install any new upgrades to it.
  Command: <pre><code>sudo apt-get upgrade </code></pre>
* Installed arp-scan on the Pi.  
Command: <pre><code>sudo apt-get install arp-scan </code></pre>
arp-scan sends  ARP packets to hosts on the local network and displays any responses that are received. The network interface to use can be specified with the --interface option. If this option is not present, arp-scan will search the system interface list for the lowest numbered, configured up interface (excluding loopback).
* Installed ufw on the Pi.
Command: <pre><code>sudo apt-get install ufw </code></pre>
This is a default firewall configuration tool for linux is ufw. This was Developed to ease IP tables firewall configuration, ufw provides a user friendly way to create an IPv4 or IPv6 host-based firewall and this is disabled by default.
Command: <pre><code>sudo ufw enable </code></pre>
* Installed original-awk on the Pi.
Command: <pre><code>sudo apt-get install original-awk </code></pre>
Awk (original-awk) scans each input file for lines that match any of a set of patterns specified literally in prog or in one or more files specified as -f progfile. With each pattern there can be an associated action that will be performed when a line of a file matches the pattern. Each line is matched against the pattern portion of every pattern-action statement; the associated action is performed for each matched pattern.
* Installed ccrypt on the Pi.
Command: <pre><code>sudo apt-get install ccrypt </code></pre>
ccrypt is a utility for encrypting and decrypting files and streams. It was designed to replace the standard unix crypt utility, which is notorious for using a very weak encryption algorithm. ccrypt is based on the Rijndael block cipher, which was also chosen by the U.S. government as the Advanced Encryption Standard. This cipher is believed to provide very strong cryptographic security.

* Setting up the network interface to received internet access through the lab pc.
Command: <pre><code>sudo nano /etc/network/interfaces
Address 192.168.137.2
Netmask 255.255.255.0
Gateway 192.168.137.1
Network 192.168.137.0
Broadcast 192.168.137.255
Dns-nameservers 8.8.8.8
</code></pre>
* To change the dns server
Command: <pre><code>sudo nano /etc/resolv.conf
Nameserver 8.8.8.8 </code></pre>
* To restart network services
Command: <pre><code>sudo service networking restart</code></pre>
* To ssh into Pi
Command: <pre><code>ssh pi@192.167.137.2</code></pre>
* To create a file.
Command: <pre><code>nano ids.sh</code></pre>
* To create the bash script within the file.
syntax: 
<pre><code>"#!/bin/bash"
#NOW is the variable, $ is used to start the variable & the rest is the function”
NOW=$(date +”%T”) </code></pre>
* This command is to give arp-can root privileges to scan the local network and save the scan
sudo arp-scan –interface=eth0 –localnet>test.$NOW.txt
To save the bash script
ctrl o 
* To give the file executable and remain a text file.
Command: <pre><code>chmod 755 ids.sh</code></pre>
* To run a scheduler on this job using CRON.
* To open & edit CRON
Command: <pre><code>crontab –e </code></pre>
* This is the file path along with the name to save the output from the scan.
<pre><code>* * * * * /home/pi/ids.sh</code></pre>
* To drop all established TCP connection using IPtable.
Command: <pre><code>sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j DROP</code></pre>
* To show the line numbers within the IPtable.
Command: <pre><code>sudo iptables –L –line-numbers</code></pre>
* To delete a rule from within the IPtable.
Command: <pre><code>sudo iptables –D INPUT 1</code></pre>
* To open the file name test.txt and pull out the ip address and then have awk extract the connected IP and compare it to a whitelist that was created and then place in a file called CMP.txt.
Command: <pre><code>cat test.txt | grep 192.168.137.* | awk ‘{print $1}’ >connectedip</code></pre>
Command: <pre><code>CMP connectedip whitelist > CMP.txt</code></pre>
* To create the IF and ELSE statement.
Command: <pre><code>if grep –q differ “CMP.txt”;
	      then 
	     sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j DROP
	    else
 	   sleep 1
	  fi
	 sleep 5
sudo iptables –flush
sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j ACCEPT</code></pre>
* This is to clean up the files the script creates.
Command: <pre><code>rm CMP.txt
      rm connectedip
      rm test.txt</code></pre>

<!--#PHASE TEST & IDS/IPS

As mention and shown with all the commands in phase 2 how I have configured the IDS and IPS into phases as I learnt each bit of information and complied to make it successful.
<li> I first learnt how to write a basic bash script and make it executable. </li>
2. How to use arp-scan to scan my local network and save the results to a file.
3. How to use CRON to automate and schedule this script.
4. How to create a white list to have IP address or MAC address for later use.
5. How to use CAT to open the save scan and then use GREP to pull IP address line with the use of AWK to pull the IPaddress which is then saved to a file named connectedip.
6. I then use CMP command to compare the connectedip to the whitelist and save the results to a file call CMP.txt
7. This is the final step where I used the IF and ELSE statement to allow all TCP connections IF the connectedip is in the whitelist ELSE drop the connectedip if DIFFER from the whitelist.
8. In this section I then use a command to FLUSH all iptable rules after 5 seconds to allow TCP connections.
All these steps are automated and the actual commands are in PHASE 2 for verification. -->

#CONCLUSION
I was able to successfully achieved creating an Intrusion Detection system “IDS” and also an Intrusion Detection Prevention system “IDPS” using a single Raspberry Pi.  
