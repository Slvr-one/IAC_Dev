data "aws_eks_cluster_auth" "cluster" {
  # name = module.eks.cluster_id
  name = module.eks.cluster_id
}

