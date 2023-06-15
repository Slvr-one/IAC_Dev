output "host" {
  description = "kubernetes endpoint - main service"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_id" {
  description = "main cluster id"
  value       = aws_eks_cluster.main.id
}

output "cluster" {
  description = "main cluster oidc issuer"
  value       = aws_eks_cluster.main
  # name = aws_eks_cluster.main.name
}

output "main_node_group" {
  value = aws_eks_node_group.main
}

output "public_node_group" {
  value = aws_eks_node_group.public
}

# output "cluster_cert_auth" {
#   description = "eks cluster certificate authority (long)"
#   value       = aws_eks_cluster.main.certificate_authority
# }

output "oidc_issuer" {
  description = "main cluster oidc issuer"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}