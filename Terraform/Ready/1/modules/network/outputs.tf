output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}

output "main_sg_ids" {
  value = aws_security_group.main.id
}