# locals {
#   cluster_name = "victor-12"
# }
#cluster
resource "aws_eks_cluster" "victor" {
  name     = var.cluster_name #local.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-1a.id,
      aws_subnet.private-1b.id,
      aws_subnet.public-1a.id,
      aws_subnet.public-1b.id
    ]
    # security_group_ids = [aws_security_group.node.id]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy]
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.victor.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private-1a.id,
    aws_subnet.private-1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = var.cluster[0].node_group.instance_types #["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint { #make a node repel sertain pods
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template { #for custom config of nodes
  #   name    = aws_launch_template.cluster_nodes.name
  #   version = aws_launch_template.cluster_nodes.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodes-AmazonEKSVPCResourceController
  ]
  # to ignore any changes to that count caused externally (e.g., Application Autoscaling).
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# resource "aws_launch_template" "cluster_nodes" {
#   # name_prefix   = "eks-example-"
#   instance_type = "t3.small"
#   name          = "cluster_nodes"
#   key_name      = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 20
#       volume_type = "gp2"
#     }
#   }
  # node_groups_defaults = {
  #   ami_release_version     = "1.20.4-20210519"
  #   instance_types          = []
  #   desired_capacity        = 1
  #   max_capacity            = 10
  #   min_capacity            = 1
  #   launch_template_id      = aws_launch_template.defode_groups = {
  # #   "first" = {
  # #     subnets = [module.vpc.public_subnets[0]]
  # #   },
  # #   "second" = {
  # #     subnets = [module.vpc.public_subnets[1]]
  # #   },
  # #   "third" = {
  # #     subnets = [module.vpc.public_subnets[2]]
  # #   }
  # }
    # launch_template_version = aws_launch_template.cluster_nodes.default_version
    # }

  # node_groups = {
  #   "first" = {
  #     subnets = [module.vpc.public_subnets[0]]
  #   },
  #   "second" = {
  #     subnets = [module.vpc.public_subnets[1]]
  #   },
  #   "third" = {
  #     subnets = [module.vpc.public_subnets[2]]
  #   }
  # }
# }



#oidc--   ##to manage permissions apps in Kubernetes
data "tls_certificate" "eks" {
  url = aws_eks_cluster.victor.identity[0].oidc[0].issuer
}

# allow granting iam premmissions based on the seviceAcount used by the pod
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.victor.identity[0].oidc[0].issuer
}
