#!/bin/bash

# get admin privileges
sudo su

#installing apache2
apt-get update -y
apt-get upgrade -y
apt-get install apache2 -y
systemctl enable apacahe2
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
