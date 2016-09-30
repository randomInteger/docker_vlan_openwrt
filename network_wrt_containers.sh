#!/bin/bash
#Author:  Christopher Gleeson, 09/2016

#Color output shenanigans
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

#Cleanup ovs bridges
ovs-vsctl del-br br0.100
ovs-vsctl del-br br0.101
ovs-vsctl del-br br0

#Cleanup docker, stop containers
printf "Stopping any running containers...\\n"
docker stop openwrt1
docker stop openwrt2
docker stop openwrt3
docker stop openwrt4
read -p "Press any key to continue..." -n1 -s
printf "\\n"

#RUN this section only the first time you run this script,
#leave commented otherwise.
printf "\\n"
printf "Creating openwrt[1-4] from openwrt-x86-generic-rootfs:latest\n"
#Create docker containers from a base openwrt 14.04 imaage
#docker import http://downloads.openwrt.org/attitude_adjustment/12.09/x86/generic/openwrt-x86-generic-rootfs.tar.gz openwrt-x86-generic-rootfs
#docker create -it --name openwrt1 openwrt-x86-generic-rootfs:latest /bin/ash
#docker create -it --name openwrt2 openwrt-x86-generic-rootfs:latest /bin/ash
#docker create -it --name openwrt3 openwrt-x86-generic-rootfs:latest /bin/ash
#docker create -it --name openwrt4 openwrt-x86-generic-rootfs:latest /bin/ash
#docker ps
#read -p "Press any key to continue... " -n1 -s

#Create bridge and vlans
printf "\\n"
printf "Creating bridge and bridge vlans...\\n"
printf "\\n"
printf "Running: ovs-vsctl add-br br0\\n"
ovs-vsctl add-br br0
printf "\\n"
printf "Running:ovs-vsctl add-br br0.100 br0 100\\n"
ovs-vsctl add-br br0.100 br0 100
printf "\\n"
printf "Running:ovs-vsctl add-br br0.101 br0 101\\n"
ovs-vsctl add-br br0.101 br0 101
printf "\\n"
read -p "Press any key to continue..." -n1 -s
printf "Running: ifconfig\\n"
ifconfig
read -p "Press any key to continue..." -n1 -s
printf "\\n"

#Start the containers
printf "\\n"
printf "Starting docker containers...\\n"
docker start openwrt1
docker start openwrt2
docker start openwrt3
docker start openwrt4
docker ps
read -p "Press any key to continue..." -n1 -s
printf "\\n"

#Connect the containers to the bridges via pipework
printf "\\n"
printf "Running: pipework br0.100 openwrt1 192.168.0.1/24\\n"
pipework br0.100 openwrt1 192.168.0.1/24
printf "Running: pipework br0.100 openwrt2 192.168.0.2/24\\n"
pipework br0.100 openwrt2 192.168.0.2/24
printf "Running: pipework br0.101 openwrt3 192.168.0.3/24\\n"
pipework br0.101 openwrt3 192.168.0.3/24
printf "Running: pipework br0.101 openwrt4 192.168.0.4/24\\n"
pipework br0.101 openwrt4 192.168.0.4/24
read -p "Press any key to continue..." -n1 -s
printf "\\n"

#Checking ping
printf "\\n"
printf "openwrt1 should be able to ping only openwrt2 at 192.168.0.2\\n"
printf "\\n"
printf "${GREEN}Running: docker exec openwrt1 ping -c 1 -W 1 192.168.0.2\\n"
docker exec openwrt1 ping -c 1 -W 1 192.168.0.2
printf "\\n"
printf "${RED}Running: docker exec openwrt1 ping -c 1 -W 1 192.168.0.3\\n"
docker exec openwrt1 ping -c 1 -W 1 192.168.0.3
printf "\\n"
printf "Running: docker exec openwrt1 ping -c 1 -W 1 192.168.0.4\\n"
docker exec openwrt1 ping -c 1 -W 1 192.168.0.4
printf "${NC}"
read -p "Press any key to continue..." -n1 -s
printf "\\n"

printf "\\n"
printf "openwrt4 should be able to ping only openwrt3 at 192.168.0.3\\n"
printf "\\n"
printf "${RED}Running: docker exec openwrt4 ping -c 1 -W 1 192.168.0.1\\n"
docker exec openwrt4 ping -c 1 -W 1 192.168.0.1
printf "\\n"
printf "Running: docker exec openwrt4 ping -c 1 -W 1 192.168.0.2\\n"
docker exec openwrt4 ping -c 1 -W 1 192.168.0.2
printf "\\n"
printf "${GREEN}Running: docker exec openwrt4 ping -c 1 -W 1 192.168.0.3\\n"
docker exec openwrt4 ping -c 1 -W 1 192.168.0.3
printf "${NC}"
read -p "Press any key to continue..." -n1 -s
printf "\\n"
