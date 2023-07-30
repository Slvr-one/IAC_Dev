output "ansible_master_cidr" {
  value       = aws_instance.ansible_master[0].public_ip
  description = "cidr block of the ansible master instance"
}