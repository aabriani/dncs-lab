export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes

ip link set dev eth1 up
ip addr add 192.168.2.97/27 dev eth1
ip route add 192.168.1.0/24 via 192.168.2.126
