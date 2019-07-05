export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

ip link set dev eth1 up

ip addr add 172.16.1.1/30 dev eth1

ip route add 192.168.0.0/16 via 172.16.1.2
ip route add 10.0.0.0/8 via 172.16.1.2
