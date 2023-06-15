output "prod_instanc_public_ip" {
  value = aws_instance.ubuntu_dvir.public_ip
}

output "prod_instanc_id" {
  value = aws_instance.ubuntu_dvir.id
}