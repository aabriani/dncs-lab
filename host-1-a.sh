export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump --assume-yes
apt-get install -y curl

ip addr add 192.168.1.1/24 dev eth1
ip link set dev eth1 up

ip route add 192.168.2.96/27 via 192.168.1.254
ip route add 172.16.1.0/30 via 192.168.1.254
ip route add 10.0.0.0/8 via 192.168.1.254
