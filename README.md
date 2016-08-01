#IDS - Intrusion Detection System 

## Introduction
This system allows users to block any intrusion by blocking the IP Addresses of the intruders. This also adds the IP Address to the blacklist which ensures that the IP address is never used again to access the system

###Device used in this project was a 
* Raspberry PI 3

##Configuration and Linux Commands

* The Pi was updated with all the latest updated
	Command: <pre><code> sudo apt-get update </code></pre>
 
* The Pi's firmware was upgraded.
	Command: <pre><code>sudo apt-get upgrade </code></pre>

* Installed arp-scan on the Pi.  
	Command: <pre><code>sudo apt-get install arp-scan </code></pre>
	arp-scan sends ARP packets to the hosts on the local network and displays any responses that has received. 
	The network interface can be selected by adding <pre><code>--interface option</code></pre> to the arp-scan command.
	By default arp-scan searches the system interface list and displays the lowest numbered interface but excludes the loopback interface.

* Installed ufw firewall on the Pi.
	Command: <pre><code>sudo apt-get install ufw </code></pre>
	This is a default firewall configuration tool for linux.
	Command: <pre><code>sudo ufw enable </code></pre>

* Installed original-awk on the Pi.
	Command: <pre><code>sudo apt-get install original-awk </code></pre>

* Installed ccrypt on the Pi.
	Command: <pre><code>sudo apt-get install ccrypt </code></pre>
	ccrypt is a utility for encrypting and decrypting files and streams.
	It was designed to replace the standard unix crypt utility, which is notorious for using a very weak encryption algorithm.
	ccrypt is based on the Rijndael block cipher, which was also chosen by the U.S. government as the Advanced Encryption Standard.
	This cipher is believed to provide very strong cryptographic security.

* Setting up the network interface to gain access to the internet. The interfaces file should be configured with the address, netmask, gateway, network, broadcast and the dns-nameserver details. 
 <!-- Address 192.168.137.2
	Netmask 255.255.255.0
	Gateway 192.168.137.1
	Network 192.168.137.0
	Broadcast 192.168.137.255
	Dns-nameservers 8.8.8.8 -->
	Command: <pre><code>sudo nano /etc/network/interfaces	</code></pre>

* To change the dns server, open resolv.conf file and add the nameserver. 
	Command: <pre><code>sudo nano /etc/resolv.conf</code></pre>

* To restart network services
	Command: <pre><code>sudo service networking restart</code></pre>

* To ssh into Pi
	Command: <pre><code>ssh pi@*pi's IP Address*</code></pre>

* To create a file.
	Command: <pre><code>nano ids.sh</code></pre>

* The script will be as follows.
	Script: 
	<pre><code>"#!/bin/bash"
	#NOW is the variable, $ is used to start the variable & the rest is the function to get the current date registered on the PI”
	NOW=$(date +”%T”) </code></pre>

* This command is to give arp-can root privileges to scan the local network and save the scan results with the local date set on the PI.
	Command: <pre><code>sudo arp-scan –interface=eth0 –localnet>test.$NOW.txt </code></pre>
	
* To save the script
	Command: <pre><code>ctrl o </code></pre>
	
* To give the file executable rights.
	Command: <pre><code>chmod 755 ids.sh or chmod +x ids.sh</code></pre>

* To run a scheduler on this job using CRON.
	Command: <pre><code>crontab –e </code></pre>

* This is the file path along with the name to save the output from the scan.
	<pre><code>* * * * * /home/pi/ids.sh</code></pre>

* To drop all established TCP connection using IPtables.
	Command: <pre><code>sudo iptables –A INPUT –m conntrack –ctstate ESTABLISHED,RELATED –j DROP</code></pre>

* To show the line numbers within the IPtables.
	Command: <pre><code>sudo iptables –L –line-numbers</code></pre>

* To delete a rule from within the IPtables.
	Command: <pre><code>sudo iptables –D INPUT 1</code></pre>

* To open the saved file that consists the arp-scan results and pull out the ip address and then have awk extract the connected IP and compare it to a whitelist that was created and then place in a file called CMP.txt.
	Command: <pre><code>cat test.txt | grep 192.168.137.* | awk ‘{print $1}’ >connectedip</code></pre>
	Command: <pre><code>CMP connectedip whitelist > CMP.txt</code></pre>

* IF statement to check for the presence of any rogue IP Addresses in the CMP.txt file.
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
	rm test.txt
	</code></pre>
