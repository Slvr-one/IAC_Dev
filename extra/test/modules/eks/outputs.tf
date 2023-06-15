output "host" {
  description = "kubernetes endpoint - main service"
  value       = aws_eks_cluster.victor.endpoint
}

output "cluster_cert_auth" {
  description = "eks cluster certificate authority (long)"
  value       = aws_eks_cluster.victor.certificate_authority
}

output "cluster_id" {
  description = "main cluster id"
  value       = aws_eks_cluster.victor.id
}

output "oidc_issuer" {
  description = "main cluster oidc issuer"
  value       = aws_eks_cluster.victor.identity[0].oidc[0].issuer
}

output "cluster" {
  description = "main cluster oidc issuer"
  value       = aws_eks_cluster.victor
}
