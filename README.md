# hole-punching

## Network
In this demo, we have the below topology.

![Network topology](/docs/network.png)

All these components (except Network C - because this is your home network) will be created using Terraform. For setting up the hosts we will use Ansible.

It's composed of three networks:
- Network A: This is a network with a strict firewall. It contains a host (EC2) running a simple HelloWorld web app on port 8000. The firewall rules allow the following ports:
    - Ingress: 22 (This is only necessary because we need to setup the instance using Ansible that uses SSH connection to setup remote instances)
    - Egress: 80, 443

- Network B: This is a third-party server used to allow "create a hole in the firewall". It has a single host that uses SSH (running on port 80 - because this is one of the ports allowed by host A firewall). Its firewall is more opened and for this example, it allow the following ports:
    - Ingress: 22 (Used by Ansible), 80, 443
    - Egress: 80, 443, 7000 (This is the port we'll use to access host A web app!)

- Network C: This could also be another AWS VPC or any other network. For making it easier to check the hole punching technique this will be our home network. So we will use your computer (bash or browser) to access Network B IP (on port 7000) to be able to see the web app running!

## Punching a hole!
How can we access the local web app running host A port 8000 if its firewall does not allow ingress traffic on port 8000? Well, that's the point of hole punching and we will check that!

Ports are just numbers. By convention there are default ports for popular services, for example: 22 (SSH), MySQL (3306), HTTP (80), HTTPS (443), 465 (SMTP) and so on. So it means that we can connect to another host using SSH if the other host is running SSH on a port that Host A firewall allows egress traffic (80 and 443 in our demo).

If we use that and allow remote port forwarding we can forward traffic from a remote port (for our demo it will be port 7000) to any other port on the local machine (or even any host reachable in its network). In this demo, the traffic will be forwarded to the local machine port 8000 (that runs our web app!).

## Network package flow
This is a simplified version of how the package flows on the internet, but it's good enough to understand what is happening.

1) Host 3 (our computer) sends an HTTP request (on port 8000) for an IP that is outside its network (Network C). This IP is the third-party server used 
2) Since this IP is outside its network the gateway must send the package through the internet. This firewall allows HTTP egress on port 8000.
3) Package reaches gateway of Network B.
4) Gateway allows ingress on port 7000 and forward package to the third party server (host 2). Host 2 receives the package. Nothing runs on this port on host 2, but host 1 created a SSH remote forward that listens to port 7000 of host 2 and forward it to host 1 port 8000.
5) Package must be sent to host 1 port 8000. Since its IP is outside Network B CIDR, this package must be sent by the Gateway.
6) Gateway forward package to the internet's infrastructure.
7) Package is sent to Host 1 network (Network A).
8) Network A gateway allows the package and forwards it to Host 1. Please keep in mind that this connection was established before using port 80! So this is NOT a package received on port 22!!!
9) Package reaches local port 8000. The web app must return an HTTP response with an HTML saying "Hello World".
10) Gateway forwards package back to Host 2.
11) Package reaches Network B
12) Gateway from Network B forwards package to Host 2.
13) Host 2 must give a response to Host 3.
14) Gateway sends the response back to the internet to reach Host 3.
15) Packet reaches Network C.
16) Response is received by Host 3.

## How to run this demo?

### Pre-requirements
To run this demo, make sure you have the following installed and properly setup:
- AWS CLI 
- Terraform
- Ansible

### Running this demo
1) **Create the infrastructure**
Run the following commands:
```sh
terraform init
terraform apply
```

This will create:
- 2 VPCs
- 2 EC2s
- 2 Security Groups
- Ansible Inventory

Please note that this will output the IP of the third party server that will be used to allow us to connect to the host with a stricted firewall. Copy this IP because we will use it later.

2) **Setup the EC2 with Ansible**
Run the command:
```sh
ansible-playbook -i ansible/inventory ansible/playbook.yaml 
```

3) **Test if the host is reachable**
Access your browser with the following URL:
```
<<server_ip>>:7000
```
or you can curl using the terminal
```
curl <<server_ip>>:7000
```

The `<<server_ip>>` is the IP that you copied before (step 1).

4) **Destroy all the infrastructure**
Run the command:
```sh
terraform destroy
```