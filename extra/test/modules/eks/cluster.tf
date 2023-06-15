
locals {
  cluster_name = "victor-12"
}
#cluster
resource "aws_eks_cluster" "victor" {
  name     = var.cluster_name #local.cluster_name
  role_arn = var.cluster_role

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

    security_group_ids      = [
      aws_security_group.eks_cluster.id, 
      aws_security_group.eks_nodes.id,
      module.network.aws_security_group.eks_nodes.id,
      module.network.aws_security_group.eks_cluster.id
    ]

    subnet_ids = [
      var.private_subnets[0],
      var.private_subnets[1],
      var.public_subnets[0],
      var.public_subnets[1]
    ]
  }
  # vpc_config {
  #   security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
  #   endpoint_private_access = var.endpoint_private_access
  #   endpoint_public_access  = var.endpoint_public_access
  #   subnet_ids = var.eks_cluster_subnet_ids
  # }

  depends_on = [var.cluster_policy_attach]
}

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.victor.name
  node_group_name = "private-nodes"
  node_role_arn   = var.nodes_role.arn

  subnet_ids = [
    var.private_subnets[0],
    var.private_subnets[1]
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
    var.nodes_policys_attach
  ]
  # depends_on = [
  #   aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
  #   aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
  #   aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  #   aws_iam_role_policy_attachment.nodes-AmazonEKSVPCResourceController
  # ]
  # to ignore any changes to that count caused externally (e.g., Application Autoscaling).
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

resource "aws_launch_template" "cluster_nodes" {
  # name_prefix   = "eks-example-"
  instance_type = "t3.small"
  name          = "cluster_nodes"
  key_name      = "local-provisioner"

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  node_groups_defaults = {
    ami_release_version     = "1.20.4-20210519"
    instance_types          = []
    desired_capacity        = 1
    max_capacity            = 10
    min_capacity            = 1
  launch_template_version = aws_launch_template.cluster_nodes.default_version

}
node_groups = {
  "first" = {
    subnets = [module.vpc.public_subnets[0]]
  },
  "second" = {
    subnets = [module.vpc.public_subnets[1]]
  },
  "third" = {
    subnets = [module.vpc.public_subnets[2]]
  }
}
}



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
