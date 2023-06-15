# output "cluster_name" {
#   value = module.eks.cluster.name
# }

# output "cluster_endpoint" {
#   value = module.eks.host
# }

# output "cluster_security_group_id" {
#   value = module.eks.main_node_group.id
# }

# output "public_node_group_id" {
#   value = module.eks.public_node_group.id
# }

# output "eks_cluster_id" {
#   description = "The name of the EKS cluster."
#   value       = module.eks.cluster_id
# }

# output "cluster_name" {
#   description = "Kubernetes Cluster Name"
#   value       = module.eks.cluster_name
# }

# output "cluster_endpoint" {
#   description = "Endpoint for EKS control plane"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane"
#   value       = module.eks.cluster_security_group_id
# }

# output "configure_kubectl" {
#   description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
#   value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
# }