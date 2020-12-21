provider "aws" {
    access_key = "ENTER_YOUR"
    secret_key = "ENTER_YOUR"
    region = "eu-west-2"
}

resource "aws_instance" "My_Ubuntu" {
  ami = "ami-0a91cd140a1fc148a (64-bit x86)" #Ubuntu linux
  instance_type = "t3.micro"
  vpc_security_group_ids = [ aws_security_group.my_webserver.id ]
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install apache2
myip='curl hhtp://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>WebServer with IP : $myip</h2><bd>By Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

  tags = {
    "Name" = "DevOps AWS",
    "Owner" = "Gilman Maxim"
  }
}

resource "aws_security_group" "my_webserver" {
  name = "WS SG"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    protocol = "tcp"
    to_port = 80
  } ,
  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 443
    protocol = "tcp"
    to_port = 443
  } ]

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } ]
}