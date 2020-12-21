#!/bin/bash
sudo apt-get update
sudo apt-get install apache2
myip='curl hhtp://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>WebServer with IP : $myip</h2><bd>By Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on