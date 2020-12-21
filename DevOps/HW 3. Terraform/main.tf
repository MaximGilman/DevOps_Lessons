provider "aws" {
  access_key = ""
  secret_key = ""
  region = "eu-west-2"
}


resource "aws_eip" "static_ip" {
  instance = aws_instance.My_Ubuntu.id
}

resource "aws_instance" "My_Ubuntu" {
  ami = "ami-0a91cd140a1fc148a (64-bit x86)" #Ubuntu linux
  instance_type = "t3.micro"
  vpc_security_group_ids = [ aws_security_group.my_webserver.id ]
  key_name = "my_precreated_ssh_key" #for ssh
  user_data = file("user_script.sh")

  tags = {
    "Name" = "DevOps AWS",
    "Owner" = "Gilman Maxim"
  }
}



resource "aws_security_group" "my_webserver" {
  name = "WS SG"
  
 dynamic "ingress"{
    for_each = ["80","443","8080","1541","9092"]

    content {
        description = "ingressDesc"
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = ingress.value
        protocol = "tcp"
        to_port = ingress.value
        ipv6_cidr_blocks = [ "0.0.0.0/0" ]
        prefix_list_ids = []
        self = false
        security_groups = []
}
}

 
egress = [ {
    description = "desc"
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    ipv6_cidr_blocks = [ "0.0.0.0/0" ]
    prefix_list_ids = []
    self = false
    security_groups = []
    protocol = "-1"
    to_port = 0
  } ]  
  
  tags = {
    "Name" = "DevOps AWS",
    "Owner" = "Gilman Maxim"
  }
}

