# DNCS-LAB | Assignment

**Student**: Andrea Abriani
**Mat**: 186066
**A.Y. 2018/19**

## Table of Contents

*   [Assignment](#assignment)
*   [Network Topology](#network-topology)
*   [Requirements](#requirements)
*   [Network Configuration](#network-configuration)
    *   [Subnets](#subnets)
    *   [VLANs](#vlans)
    *   [IP interface setup](#ip-interface-setup)
*   [Vagrant configuration](#vagrant-configuration)
    *   [Vagrantfile](#vagrantfile)
    *   [Devices](#devices)
        *   [router-1](#router-1)
            *   [router-1 provisioning script](#router-1-provisioning-script)
        *   [router-2](#router-2)
            *   [router-2 provisioning script](#router-2-provisioning-script)
        *   [switch](#switch)
            *   [switch provisioning script](#switch-provisioning-script)
        *   [host-1-a](#host-1-a)
            *   [host-1-a provisioning script](#host-1-a-provisioning-script)
        *   [host-1-b](#host-1-b)
            *   [host-1-b provisioning script](#host-1-b-provisioning-script)
        *   [host-2-c](#host-2-c)
            *   [host-2-c provisioning script](#host-2-c-provisioning-script)
*   [Testing the infrastructure](#testing-the-infrastructure)

## Assignment

Based the Vagrantfile and the provisioning scripts available at: https://github.com/dustnic/dncs-lab the candidate is required to design a functioning network where any host configured and attached to router-1 (through switch) can browse a website hosted on host-2-c.

The subnetting needs to be designed to accommodate the following requirement (no need to create more hosts than the one described in the vagrantfile):
* Up to 130 hosts in the same subnet of host-1-a
* Up to 25 hosts in the same subnet of host-1-b
* Consume as few IP addresses as possible

The assignment needs to be delivered via code hosted on github.com (via a fork of the original repository).

The cloned code (from the master branch) produced by the candidate needs to run with vagrant up and contain all the changes to deploy the network and the desired configuration.

## Network Topology
```

        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |eth1
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           | host-2-c |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+ host-1-a |     | host-1-b |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

## Requirements
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

## Network configuration
### Subnets

To reach the assignment request, the network topology is composed by 4 different subnets:

| Subnet name |  Subnet address |        Netmask       |      Devices      |
|:-----------:|:---------------:|:--------------------:|:-----------------:|
|      A      |  192.168.1.0/24 |  255.255.255.0 = 24  | *host-1-a*, *router-1* |
|      B      | 192.168.2.96/27 | 255.255.255.224 = 27 | *host-1-b*, *router-1* |
|      C      |   10.1.1.0/30   | 255.255.255.252 = 30 | *router-1*, *router-2* |
|      D      |  172.16.1.0/30  | 255.255.255.252 = 30 | *host-2-c*, *router-2* |


* Subnet **A** includes *host-1-a* and *router-1*. It has a */24* subnet mask to allow up to 2<sup>32-24</sup>-2= 254 hosts (assignment request was 130 hosts)
* Subnet **B** includes *host-1-b* and *router-1*. It has a */27* subnet mask to allow up to 2<sup>32-27</sup>-2= 30 hosts (assignment request was 25 hosts)
* Subnet **C** includes *router-1* and *router-2*. It has a */30* subnet mask to allow up to 2<sup>32-30</sup>-2= 2 hosts (subnet used completely)
* Subnet **D** includes *router-2* and *host-2-c*. It has a */30* subnet mask to allow up to 2<sup>32-30</sup>-2= 2 hosts (subnet used completely)

### VLANs

Network topology requires configuration of 2 VLANs to allow *router-1* communicate with subnet **A** and **B** via unique port properly.

The VIDs set is the following:

| VID | Subnet |
|:---:|:------:|
|  10 |    A   |
|  20 |    B   |

### IP interface setup

The IP assegnation summary for every interface:

|  Device  | Interface |    IP address    | Subnet |
|:--------:|:---------:|:----------------:|:------:|
| host-1-a |    eth1   |  192.168.1.1/24  |    A   |
| router-1 |  eth1.10  | 192.168.1.254/24 |    A   |
| host-1-b |    eth1   |  192.168.2.97/27 |    B   |
| router-1 |  eth1.20  | 192.168.2.126/27 |    B   |
| router-1 |    eth2   |    10.1.1.1/30   |    C   |
| router-2 |    eth2   |    10.1.1.2/30   |    C   |
| router-2 |    eth1   |   172.16.1.2/30  |    D   |
| host-2-c |   enp0s8  |   172.16.1.1/30  |    D   |

## Vagrant configuration
### Vagrantfile

In the Vagrantfile each VM is created with the following example code:
```ruby
config.vm.define "router-1" do |router1|
  ...
  ...
end
```

Vagrant is set up so that every device has its specific provisioning shell.

All devices are created with *trusty64* Vagrant box, except for device *host-2-c* that is created with *xenial64* Vagrant box. This choice will be explained next...   

### Devices
#### router-1
VM for *router-1* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "router-1" do |router1|
  router1.vm.box = "minimal/trusty64"
  router1.vm.hostname = "router-1"
  router1.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-1", auto_config: false
  router1.vm.network "private_network", virtualbox__intnet: "broadcast_router-inter", auto_config: false
  router1.vm.provision "shell", path: "router-1.sh"
end
```
Interfaces created:
* *eth1* connected with *switch* device
* *eth2* connect with *router-2* device

After the creation of the VM, Vagrant will run *router-1.sh* provisioning shell.
##### *router-1* provisioning script

First, install FRRouting to provide dynamic routing as requested:
```ruby
apt-get install -y frr --assume-yes --force-yes
```
With the following code, 2 VLANs are created to trunk connect *router-1* and *switch*:
```ruby
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
```
Then assign desired IP addresses to *eth1.10*, *eth1.20*, *eth2*:
```ruby
ip addr add 192.168.1.254/24 dev eth1.10
ip addr add 192.168.2.126/27 dev eth1.20
ip addr add 10.1.1.1/30 dev eth2
```
Set the interfaces up:
```ruby
ip link set dev eth1 up
ip link set dev eth1.10 up
ip link set dev eth1.20 up
ip link set dev eth2 up
```
Using *sed* stream editor, enable *zebra* and *ospf* daemons in *frr* configuration file:
```ruby
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
```
Enable IP forwarding and restart *frr* service to actually start ospf daemon:
```ruby
sysctl net.ipv4.ip_forward=1
service frr restart
```
Lastly, using *vtysh* modal CLI configure *ospf* routing. Also, let static routes propagate in *ospf* routing protocol with `redistribute connected` command.
```ruby
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
```

#### router-2
VM for *router-2* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "router-2" do |router2|
  router2.vm.box = "minimal/trusty64"
  router2.vm.hostname = "router-2"
  router2.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-2", auto_config: false
  router2.vm.network "private_network", virtualbox__intnet: "broadcast_router-inter", auto_config: false
  router2.vm.provision "shell", path: "router-2.sh"
end
```
Interfaces created:
* *eth2* connected with *router-1* device
* *eth1* connect with *host-2-c* device

After the creation of the VM, Vagrant will run *router-2.sh* provisioning shell.
##### *router-2* provisioning script

First, install FRRouting to provide dynamic routing as requested:
```ruby
apt-get install -y frr --assume-yes --force-yes
```

Then assign desired IP addresses to *eth1.10*, *eth1.20*, *eth2*:
```ruby
ip addr add 10.1.1.2/30 dev eth2
ip addr add 172.16.1.2/30 dev eth1
```
Set the interfaces up:
```ruby
ip link set dev eth1 up
ip link set dev eth2 up
```
Using *sed* stream editor, enable *zebra* and *ospf* daemons in *frr* configuration file:
```ruby
sed -i 's/zebra=no/zebra=yes/g' /etc/frr/daemons
sed -i 's/ospfd=no/ospfd=yes/g' /etc/frr/daemons
```
Enable IP forwarding and restart *frr* service to actually start ospf daemon:
```ruby
sysctl net.ipv4.ip_forward=1
service frr restart
```
Lastly, using *vtysh* modal CLI configure *ospf* routing. Also, let static routes propagate in *ospf* routing protocol with `redistribute connected` command.
```ruby
vtysh -c 'configure terminal' -c 'interface eth2' -c 'ip ospf area 0.0.0.0'
vtysh -c 'configure terminal' -c 'router ospf' -c 'redistribute connected'
```

#### switch
VM for *switch* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "switch" do |switch|
  switch.vm.box = "minimal/trusty64"
  switch.vm.hostname = "switch"
  switch.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-1", auto_config: false
  switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
  switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
  switch.vm.provision "shell", path: "switch.sh"
end
```
Interfaces created:
* *eth1* connected with *router-1* device
* *eth2* connected with *host-1-a* device
* *eth3* connected with *host-1-b* device  

After the creation of the VM, Vagrant will run *switch.sh* provisioning shell.

##### *switch* provisioning script

The following code creates a new bridge called "*switch*" and its interfaces:
* *eth1* as a trunk port
* *eth2* as an access port for VLAN 10
* *eth3* as an access port for VLAN 20
```ruby
ovs-vsctl add-br switch
ovs-vsctl add-port switch eth1
ovs-vsctl add-port switch eth2 tag=10
ovs-vsctl add-port switch eth3 tag=20
```

And finally set all interfaces created and ovs-system up:
```ruby
ip link set dev eth1 up
ip link set dev eth2 up
ip link set dev eth3 up
ip link set dev ovs-system up
```

#### host-1-a
VM for *host-1-a* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "host-1-a" do |hosta|
  hosta.vm.box = "minimal/trusty64"
  hosta.vm.hostname = "host-1-a"
  hosta.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
  hosta.vm.provision "shell", path: "host-1-a.sh"
end
```
Interfaces created:
* *eth1* connected with *switch* device

After the creation of the VM, Vagrant will run *host-1-a.sh* provisioning shell.

##### *host-1-a* provisioning script

First, install *curl* package to later browse a website hosted on *host-2-c* :
```ruby
apt-get install -y curl
```
Then assign IP address to its interface and set it up:
```ruby
ip addr add 192.168.1.1/24 dev eth1
ip link set dev eth1 up
```

Lastly, add the following routes to the device routing table:
```ruby
ip route add 192.168.2.96/27 via 192.168.1.254
ip route add 172.16.1.0/30 via 192.168.1.254
ip route add 10.0.0.0/8 via 192.168.1.254
```
#### host-1-b
VM for *host-1-b* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "host-1-b" do |hostb|
  hostb.vm.box = "minimal/trusty64"
  hostb.vm.hostname = "host-1-b"
  hostb.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
  hostb.vm.provision "shell", path: "host-1-b.sh"
end
```
Interfaces created:
* *eth1* connected with *switch* device

After the creation of the VM, Vagrant will run *host-1-b.sh* provisioning shell.

##### *host-1-b* provisioning script
First, install *curl* package to later browse a website hosted on *host-2-c* :
```ruby
apt-get install -y curl
```
Then assign IP address to its interface and set it up:
```ruby
ip addr add 192.168.2.97/27 dev eth1
ip link set dev eth1 up
```

Lastly, add the following routes to the device routing table:
```ruby
ip route add 192.168.1.0/24 via 192.168.2.126
ip route add 10.0.0.0/8 via 192.168.2.126
ip route add 172.16.1.0/30 via 192.168.2.126
```

#### host-2-c
VM for *host-2-c* is created with the following code in the Vagrantfile:
```ruby
config.vm.define "host-2-c" do |hostc|
  hostc.vm.box = "minimal/xenial64"
  hostc.vm.hostname = "host-2-c"
  hostc.vm.network "private_network", virtualbox__intnet: "broadcast_router-south-2", auto_config: false
  hostc.vm.provision "shell", path: "host-2-c.sh"
end
```
Interfaces created:
* *eth1* connected with *router-2* device

As previously said, *host-2-c* VM is using *xenial64* Vagrant box instead of *trusty64* one. What has led to this choice is compatibility issue with docker: as stated in docker 18.09.2 security fix [release notes](https://docs.docker.com/engine/release-notes/#18092)
> * Update runc to address a critical vulnerability that allows specially-crafted containers to gain administrative privileges on the host.
> * Ubuntu 14.04 customers using a 3.13 kernel will need to upgrade to a supported Ubuntu 4.x kernel

Thus, the best solution was to update Ubuntu to *xenial64* as it has 4.4 Linux kernel.

After the creation of the VM, Vagrant will run *host-2-c.sh* provisioning shell.

##### *host-2-c* provisioning script

First, install docker:
```ruby
apt-get install -y docker-ce --assume-yes --force-yes
```

Then assign IP address to its interface and set it up:
```ruby
ip addr add 172.16.1.1/30 dev enp0s8
ip link set dev enp0s8 up
```
Add the following routes to the device routing table:
```ruby
ip route add 192.168.0.0/16 via 172.16.1.2
ip route add 10.0.0.0/8 via 172.16.1.2
```
Just to be sure, and to multiple provision *host-2-c* without errors, stop and remove possible containers created:
```ruby
docker kill $(docker ps -q)
docker rm $(docker ps -aq)
```
Download nginx image:
```ruby
docker pull nginx
```

Then let's create a directory and put a custom index html page in it:
```ruby
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
```

Lastly, create a docker container named "*docker-nginx*" with *nginx* image on it to host a website:
```ruby
docker run --name docker-nginx -p 80:80 -d -v ~/docker-webserver/html:/usr/share/nginx/html nginx
```
Note that the `-v ~/docker-webserver/html:/usr/share/nginx/html` option is used to bind mount nginx default directory with the one containing the custom html index page.


## Testing the infrastructure
Clone this repo with `git` command:
```bash
git clone https://github.com/aabriani/dncs-lab
```
Launch the lab from within the cloned repo folder.
```bash
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once launched the vagrant script and all the VMs are running, you can log into all of them with the command `vagrant ssh VM_NAME` (VM_NAME is the VM name you want to log into).

For example, log into *host-1-a* :
```bash
vagrant ssh host-1-a
```
Logged into *host-1-a*, to test the reachability of the web server hosted on *host-2-c* do:
```bash
ping 172.16.1.1
```
Now that the webserver results reachable, to browse the website hosted on *host-2-c* do:
```bash
curl 172.16.1.1
```
The `curl` command prompted will return the custom html index page, thus the assignment request results completed.

The same procedure can be done as well from *host-1-b*.
