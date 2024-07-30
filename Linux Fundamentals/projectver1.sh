#!/bin/bash

echo 'Hello user!'
echo ' '
#~ 1. Display Linux version while accessing the folder /etc/os-release to find out the information

echo 'Your Linux Version is:'
cat /etc/os-release | grep -w VERSION | awk -F= '{print $2}'
echo ' '
sleep 2

#~ 2.1 Display the user private IP Address
echo 'Your Private IP Address is: '
ifconfig | grep broadcast | awk '{print $2}'
echo ' '
sleep 2

#~ 2.2 Display the user public IP Address
echo 'Your Public IP Address is: '
curl ifconfig.io
echo ' '
sleep 2

#~ 2.3 Display the user default gateway
echo 'Your default gateway is: '
route | grep default | awk '{print $2}'
echo ' '
sleep 2

#~ 3.1 Display the total hard disk size
echo 'Your total hard disk size is: '
df -h | grep /dev/sda | awk '{print $2}'
echo ' '
sleep 2

#~ 3.2 Display the free space in hard disk
echo 'Your free space in hard disk is: '
df -h | grep /dev/sda | awk '{print $4}'
echo ' '
sleep 2

#~ 3.3 Display the used up space in hard disk
echo 'Your used up space in hard disk is: '
df -h | grep /dev/sda | awk '{print $3}'
echo ' '
sleep 2

#~ 4. Display the top 5 file directories and size in /home
echo 'Your top 5 file directories in /home is as followed: '
du -h /home | sort -rh | head -n5
echo ' '
sleep 2

#~ 5.1 Display a message telling the user to press Ctrl + C to exit the script
echo 'The script will proceed to display CPU Usage every 10 seconds, press Ctrl + C to exit the script.'
read -n 1 -s -r -p "Press any key to continue"
echo ' '

#~ 5.21 Display the CPU Usage (Using watch command)
#watch -n10 echo "CPU Usage: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"

#~ 5.22 Display the CPU Usage (Using while true command)
while true
do
    # Display CPU usage
    echo ""$(date)" CPU Usage: "$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
    
    # Sleep for 10 seconds (Using 9 instead of 10 because it matches the exact result)
    sleep 9
done
