export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common --assume-yes --force-yes
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce --assume-yes --force-yes

ip addr add 172.16.1.1/30 dev enp0s8
ip link set dev enp0s8 up

ip route add 192.168.0.0/16 via 172.16.1.2
ip route add 10.0.0.0/8 via 172.16.1.2

docker kill $(docker ps -q)
docker rm $(docker ps -aq)

docker pull nginx

mkdir -p ~/docker-webserver/html
echo "<html>
<head><title>DNCS Assignment A.Y. 2018/2019</title></head>
<body>
  <p>
    <h1>
      Page created just to test infrastructure worked properly.
    </h1>
  <p>
</body>
</html>" > ~/docker-webserver/html/index.html

docker run --name docker-nginx -p 80:80 -d -v ~/docker-webserver/html:/usr/share/nginx/html nginx
