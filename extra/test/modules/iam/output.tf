output "cluster_iam_role" {
  value = aws_iam_role.cluster.arn
}

output "nodes_iam_role" {
  value = aws_iam_role.nodes.arn
}

output "autoscaler_iam_role" {
  value = aws_iam_role.eks_cluster_autoscaler
}

output "cluster_policy_attach" {
  value = aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy
}

output "nodes_policy_attach_worker" {
  value = aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy
}

output "nodes_policy_attach_cni" {
  value = aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy
}

output "nodes_policy_attach_ecr" {
  value = aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly
}

output "nodes_policy_attach_vpc" {
  value = aws_iam_role_policy_attachment.nodes-AmazonEKSVPCResourceController
}

