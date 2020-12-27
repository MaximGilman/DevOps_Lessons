output "web_server_instance_id" {
  value =  aws_instance.my_ubuntu.id
}
output "web_public_ip" {
  value =  aws_eip.static_ip.public_ip
}