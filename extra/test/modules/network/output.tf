output "private_subnets" {
  value = [
    aws_subnet.private-1a.id,
    aws_subnet.private-1b.id
  ]
}

output "public_subnets" {
  value = [
    aws_subnet.public-1a.id,
    aws_subnet.public-1b.id
  ]
}

# output "sg_id" {
#   value = aws_security_group.sg.id
# }
