# docker_vlan_openwrt
An example script that creates vlan linux bridges, and connects docker containers running openwrt.  Handy micro-segmentation for containers, yay.

# Pre-requisites
1.  Tested on virtual instances of Ubuntu14.04LTS (aws, vmware)
2.  Install docker - https://www.docker.com/
3.  Install openvswitch - http://openvswitch.org/
4.  Install pipework - https://github.com/jpetazzo/pipework

# Run the script
First time:  Uncomment the section that pulls the docker image and creates containers.
After the first time:  Leave that section commented.

$sudo ./network_wrt_containers.sh
