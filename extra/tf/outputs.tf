
output "region" {
  description = "AWS region"
  value       = var.region
}

output "host" {
  value = aws_eks_cluster.victor.endpoint
}

output "cluster_cert_auth" {
  value = aws_eks_cluster.victor.certificate_authority 
}

# output "eks_cluster_autoscaler_arn" {
#   value = aws_iam_role.eks_cluster_autoscaler.arn
# }
# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane."
#   value       = module.eks.cluster_security_group_id
# }

# output "kubectl_config" {
#   description = "kubectl config as generated by the module."
#   value       = module.eks.kubeconfig
# }

# output "config_map_aws_auth" {
#   description = "A kubernetes configuration to authenticate to this EKS cluster."
#   value       = module.eks.config_map_aws_auth
# }

# output "kubectl_config" {
#   description = "kubectl config as generated by the."
#   value       = aws_eks_cluster.victor.kubeconfig
# }

# output "config_map_aws_auth" {
#   description = "A kubernetes configuration to authenticate to this EKS cluster."
#   value       = aws_eks_cluster.victor.config_map_aws_auth

# # Display load balancer hostname (typically present in AWS)
# output "load_balancer_hostname" {
#   value = kubernetes_ingress.example.status.0.load_balancer.0.ingress.0.hostname
# }

# # Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
# output "load_balancer_ip" {
#   value = kubernetes_ingress.example.status.0.load_balancer.0.ingress.0.ip
# }

