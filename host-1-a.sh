export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes

ip link set eth1 up
ip addr add 192.168.1.1/24 eth1
ip route add 192.168.2.96/27 via 192.168.1.254
