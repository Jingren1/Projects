#!/bin/bash

#CFC011023 Group 2, S15 Ng Jing Ren, Trainer: Ryan Tan

#Please run the application on sudo. "sudo bash NR.sh"
#Inform user to enter password if program is not installed.
#Check if required application is installed.
#Command -v with if statement to check program installed in Kali.

echo '# Disclaimer: Please enter password if required during installation'

if [[ $(command -v geoiplookup) ]] 
then
	echo '# geoip-bin is already installed.'
else
	sudo apt-get update
	sudo updatedb
	sudo apt-get install -y geoip-bin
	echo '# geoip-bin is installed.'
fi

if [[ $(command -v tor) ]] 
then
	echo '# tor is already installed.'
else
	sudo apt-get update
	sudo updatedb
	sudo apt-get install -y tor
	echo '# tor is installed.'
fi

if [[ $(command -v sshpass) ]] 
then
	echo '# sshpass is already installed.'
else
	sudo apt-get update
	sudo updatedb
	sudo apt-get install -y sshpass
	echo '# sshpass is installed.'
fi

#To ensure that nipe.pl is in the database

sudo updatedb

if [[ $(locate nipe.pl) ]] 
then
	echo '# Nipe is already installed.'
else
	git clone https://github.com/htrgouvea/nipe && cd nipe/
	cpanm --installdeps .
	echo '# Type y to continue.'
	echo '# Type yes to configure automatically.'
	sudo cpan install Switch JSON LWP::UserAgent Config::Simple
	sudo perl nipe.pl install
	echo '# Nipe is installed.'
fi

#Check if network connection is anonymous, if it is not, exit the application immediately.
#STATUS variable is to print out the current status of Nipe

cd nipe/
echo kali | sudo -S perl nipe.pl start > /dev/null
STATUS=$(sudo perl nipe.pl status | grep Status | awk '{print $3}')

if [[ "$STATUS" == 'true' ]]
then
	echo '# You are Anonymous.'
else
	echo '# You are not Anonymous'
	exit
fi

#Display spoofed IP address and country.
#By using geoiplookup to lookup for the country of spoofed IP address.

echo " "

IPADD=$(sudo perl nipe.pl status | grep Ip | awk '{print $3}')
Country=$(geoiplookup "$IPADD" | awk '{print $5, $6, $7, $8}')

echo "Your Spoofed IP address is $IPADD, Spoofed country: $Country"

echo " "

#Allow user to specify a domain/IP address to scan.
#By using read command, it allows the user input to be store in a variable.

echo 'Please specify a domain/IP address to scan:'
read target

echo " "

#Inform the user to input password on connecting to remote server.
#Using sshpass to connect SSH on a remote server 192.168.214.132.
#StrictHostKeyChecking=no means that it will skip checking of host key during SSH connection.
#In order to execute command on remote server, every command needs to begin with sshpass information.

echo '# Connecting to a remote server.'
echo '# Please input a password for remote server.'
read PASSWORD

sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "echo Uptime:"
UPT=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "uptime")
echo "$UPT"

echo " "

#In order for remote server to execute nipe.pl, input of cd nipe/ && 'command' would work.
#Using of --prompt= "" so that it will not prompt user to ask password while using sudo.
#When using awk in remote server, it needs to be in '{print\$1}'.

sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "cd nipe/ && echo "$PASSWORD" | sudo -S --prompt= "" perl nipe.pl start" 
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "echo IP Address:"
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "cd nipe/ && echo "$PASSWORD" | sudo -S --prompt= "" perl nipe.pl status | grep Ip | awk '{print \$3}'"
IPR=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "cd nipe/ && echo "$PASSWORD" | sudo -S --prompt= "" perl nipe.pl status | grep Ip | awk '{print \$3}'")

echo " "

#Storing remote server IP address as IPR so that when using geoiplookup would be conveient.
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "echo Country:"
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "geoiplookup $IPR | awk '{print\$5,\$6,\$7,\$8}'"

echo " "

#For retrieving of whois data based on user input, I have put in whois $target so that it will display the data.
#For saving the data of the result, I have opt to use nipe folder.


echo "# Who is Victim address:"; sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "whois $target > /dev/null"
echo "# Whois data was saved into: "/home/kali/nipe/whois_$target""; sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "whois $target > "nipe/whois_$target.txt""
echo " "

#For retrieving of files from remote server
#Using of * so that any .txt file will be downloaded from nipe folder in remote server.

sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no kali@192.168.214.132 "echo "$PASSWORD" | sudo -S service --prompt= "" vsftpd start"
wget ftp://$PASSWORD:kali@192.168.214.132/nipe/*.txt

#Once the file is downloaded into main machine, added a date as to log the timing of download.
#Compiled the file into NRlog.txt so that it audits the data collection.
#Please refer to NRlog.txt for data log.

TDATE=$(date)

echo ""$TDATE"- #whois_$target scan completed, file saved in as nipe/whois_$target" >> NRlog.txt
echo ""$TDATE"- #whois_$target scan completed, file saved in as nipe/whois_$target"
