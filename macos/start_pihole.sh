#!/bin/bash

#This will determine if the device has just booted
#If the device just booted, sleep and wait for docker to autostart

boottime=`sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//g'`
unixtime=`date +%s`
timeago=$(($unixtime - $boottime))
bootwarmtime=120

if [ "$timeago" -le "$bootwarmtime" ]
then 
   sleep $dockerwarmtime
fi

if (! /usr/local/bin/docker stats --no-stream ); then
   # On Mac OS this would be the terminal command to launch Docker
   open /Applications/Docker.app

   #Wait until Docker daemon is running and has completed initialisation
   while (! /usr/local/bin/docker stats --no-stream ); do
  
   # Docker takes a few seconds to initialize
   echo "Waiting for Docker to launch..."
   sleep 10
   done
fi


#This sets the system IP to a variable
ip=$(ipconfig getifaddr en0)

#This sets the web console password on launch
password=$(openssl rand -base64 6)
touch ~/pihole/wordoftheday.txt
echo $password > ~/pihole/wordoftheday.txt

#This sets the DNS Server in case it's still set to pihole
networksetup -setdnsservers Wi-Fi 1.1.1.1

#This preserves the previous configuration if it exists
if [ -e ./containerdata/etc/pihole/setupVars.conf ]; then
    cp ./containerdata/etc/pihole/setupVars.conf ./containerdata/etc/pihole/setupVars.conf.orig
    configexists=1
fi

#Launch PiHole
#128m may be optimistic, tweak if sadness occurs
/usr/local/bin/docker stop pihole
/usr/local/bin/docker rm pihole
/usr/local/bin/docker pull pihole/pihole
/usr/local/bin/docker run -d --name pihole --memory=128m -e ServerIP=$ip -e WEBPASSWORD=$password -v ~/pihole/containerdata/etc/pihole/:/etc/pihole/ -p 80:80 -p 53:53/tcp -p 53:53/udp -p 443:443 pihole/pihole:latest

#This grabs the password generated in this script and applies it to the original config
if [ "$configexists" == "1" ]; then
    passwordhash=$(grep -i WEBPASSWORD ./containerdata/etc/pihole/setupVars.conf)
    echo $passwordhash
    sed -i "" "s/WEBPASSWORD=*/WEBPASSWORD=$passworehash/" ./containerdata/etc/pihole/setupVars.conf.orig
    cp ./containerdata/etc/pihole/setupVars.conf.orig ./containerdata/etc/pihole/setupVars.conf
    /usr/local/bin/docker stop pihole
    /usr/local/bin/docker start pihole
fi


#Set DNS to PiHole
networksetup -setdnsservers Wi-Fi 127.0.0.1
