# VPC for EKS
module "vpc_for_eks" {
  source = "./modules/vpc"

  region           = var.region
  tags             = var.tags
  az       = data.aws_availability_zones.available.names

  eks_cluster_name = var.cluster_name
  vpc_name     = "${var.cluster_name}-vpc"
  vpc_cidr_block = var.vpc_cidr_block
  route_table_name = "main"
  
}

# EKS Cluster
module "eks" {
  source = "./modules/eks"

  # Cluster
  eks_cluster_name       = var.cluster_name
  vpc_id                 = module.vpc_for_eks.vpc_id
  cluster_sg_name        = "${var.cluster_name}-cluster-sg"
  nodes_sg_name          = "${var.cluster_name}-node-sg"
  eks_cluster_subnet_ids = flatten([module.vpc_for_eks.public_subnet_ids, module.vpc_for_eks.private_subnet_ids])

  # Node group configuration (including autoscaling configurations)
  pvt_desired_size = 3
  pvt_max_size     = 8
  pvt_min_size     = 2

  pblc_desired_size = 1
  pblc_max_size     = 2
  pblc_min_size     = 1

  endpoint_private_access = true
  endpoint_public_access  = true

  node_group_name    = "${var.cluster_name}-node-group"
  private_subnet_ids = module.vpc_for_eks.private_subnet_ids
  public_subnet_ids  = module.vpc_for_eks.public_subnet_ids
}

# #cluster & nodes iam roles
# module "iam" {
#   source = "./modules/iam"

#   fingerprint = module.tls.cert_fingerprint
#   oidc_issuer = module.eks.oidc_issuer
# }