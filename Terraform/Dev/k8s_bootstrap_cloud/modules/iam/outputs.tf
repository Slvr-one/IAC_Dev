output "k8s_iam_profile" {
  value       = aws_iam_instance_profile.k8s.id
  description = "All Machine details"
}