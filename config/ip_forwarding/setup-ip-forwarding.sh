#!/bin/sh

# If /etc/sysctl.conf contains net.ipv4.ip_forward edit in place, else add it
grep -q net.ipv4.ip_forward /etc/sysctl.conf 

if [ $? = "0" ]; then
	sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf 
else
	echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
fi

# Read newly edited sysctl.conf
sysctl -p /etc/sysctl.conf > /dev/null 2>&1

# Add iptables masquerade script to if-up.d and run it
cp iptables-masquerade /etc/network/if-up.d/
/etc/network/if-up.d/iptables-masquerade
