provider "aws" {
  access_key = ""
  secret_key = ""
  region = "eu-west-2"
}


resource "aws_eip" "static_ip" {
  instance = aws_instance.my_ubuntu.id
}

resource "aws_instance" "my_ubuntu" {
  ami = "ami-0e169fa5b2b2f88ae" #Ubuntu linux 64
  instance_type = "t3.micro"
  vpc_security_group_ids = [ aws_security_group.my_webserver.id ]
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

resource "aws_autoscaling_group" "load_bal_example1" {

    min_size = 2
    max_size = 4
    launch_configuration = aws_launch_configuration.lb_instance1.id

    load_balancers = [aws_elb.lb_example.name]
    health_check_type = "ELB"
    availability_zones = data.aws_availability_zones.any.names

    tag {
        key = "instanse_with_balancer_name1" 
        value = "load_bal_example1"
        propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "lb_instance1" {
  image_id = "ami-0e169fa5b2b2f88ae" 
  instance_type = "t3.micro"
  user_data = file("user_script.sh")
  security_groups = [ aws_security_group.my_webserver.id ]  
}
resource "aws_elb" "lb_example" {
    name = "mylbexample"
    availability_zones = data.aws_availability_zones.any.names
    security_groups = [aws_security_group.my_webserver.id]

    health_check{
        target = "HTTP:${var.server_port}/"
        interval = 60
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    listener {
        lb_port = 80
        lb_protocol = "http"
        instance_port = var.server_port
        instance_protocol = "http"
    }
}

variable "server_port" {
    description = "HTTP"
    type = number
    default = 8080
}
data "aws_availability_zones" "any" {
  
}