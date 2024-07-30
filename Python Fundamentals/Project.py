#!/usr/bin/python3

import platform #Import platform to get platform module commands
import socket #Import socket to get socket module commands
import os #Import os to get os module commands
import netifaces #Import netifaces to get netifaces module commands
import psutil #Import psutil to get psutil module commands
import subprocess #Import subprocess to get subprocess module commands
import time #Import time to get time module commands

def OperatingSystem():
	print('Your OS is:' ,platform.system()) #To obtain the OS name
	print('Your OS version is:' ,platform.platform()) #To obtain the OS version
	
OperatingSystem()

hostname = socket.gethostname() #Getting the hostname by socket.gethostname() method
INT_IP = socket.gethostbyname(hostname) #Using hostname as parameters to get Private IP
def PRIVATEIP():
	print('Your Private IP is:' , INT_IP)

PRIVATEIP()

EXT_IP  = os.popen('curl -s ifconfig.me').readline() #Grab the Public IP via ifconfig.me
def PUBLICIP():
	print('Your Public IP is:' ,EXT_IP)

PUBLICIP()

gateways = netifaces.gateways() #Portable way to get access to network interface of a machine
default_gateway = gateways['default'][netifaces.AF_INET][0] #Gets default gateway
def DEFAULT():
	print('Your Default Gateway is:' ,default_gateway)

DEFAULT()

def HARDDISKINFO():
	try:
		disk_info = psutil.disk_usage("/") #Help to determine the amount of storage that has been used from "/" directory
		print('Hard Disk information:')	#You can turn one to GB just by dividing it by 1024 * 1024 * 1024.
		print(f"Total: {disk_info.total / 1024 / 1024 / 1024:.2f} GB")
		print(f"Used: {disk_info.used / 1024 / 1024 / 1024:.2f} GB")
		print(f"Free: {disk_info.free / 1024 / 1024 / 1024:.2f} GB")

	except FileNotFoundError:			#Shows disk info is not available if the stated directory is not found
		print("Disk info not available on this system")
    
HARDDISKINFO()

def TOP5DIR():
	cmd = "du -h / | sort -rh | head -n5" 				#Input linux command of get file directories in cmd
	top = subprocess.getoutput(cmd)						#Using subprocess to get the output
	lines = top.split("\n")								#Split the lines
	top5 = lines[-5:]									#Only display the top 5 largest directories using index
	clean_text = [elem.split('\t') for elem in top5]	#Using \t to remove \t
	print('The top 5 file directories are: [Size], [File Directory]')
	print(clean_text)									#Print the final result in a list

TOP5DIR()

def CPUUSAGE():
	for x in range(0,100):
		print('CPU Usage is:' , psutil.cpu_percent(),'%')	#Display CPU Usage
		time.sleep(10)										#Command run every 10 seconds

CPUUSAGE()
