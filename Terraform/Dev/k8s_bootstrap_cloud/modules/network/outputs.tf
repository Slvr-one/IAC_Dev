output "api-sg" {
  value       = aws_security_group.k8s_api
  description = "All Machine details"
}

output "k-sg" {
  value       = aws_security_group.k8s
  description = "All Machine details"
}

output "k-subnet" {
  value = aws_subnet.k8s #aws_subnet.k8s.id

  description = "All Machine details"
}