
locals {
  name = var.cluster_name
  # name            = "ex-${replace(basename(path.cwd), "_", "-")}"
  cluster_version = "1.23"
  region          = var.aws_region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name    = local.name
    GithubRepo = "Slvr-one/Portfolio"  }
}

# # deploy argocd helm chart in cluster
# module "helm" {
#   source     = "./modules/helm"
#   node_group = module.eks.main_node_group #public_node_group

#   depends_on = [
#     module.vpc
#   ]
# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs #["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  # public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }
  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # version = "18.20.2"
  version = "19.15.1"


  cluster_name    = local.name
  cluster_version = local.cluster_version

  # cluster_addons = {
  #   coredns = {
  #     most_recent = true
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  # vpc-cni = {
  #     most_recent = true
  #   }
  # }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  # control_plane_subnet_ids = module.vpc.intra_subnets

  # create_aws_auth_configmap = true
  # manage_aws_auth_configmap = true

  # No values were provided so this is unknown
  # aws_auth_roles = local.map_roles
  # aws_auth_users = local.map_users

  self_managed_node_groups = {
    worker-group-1 = {
      min_size      = 1
      desired_size  = 1
      max_size      = 3
      instance_type = "t3.medium"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypt               = true
            volume_size           = 50
            volume_type           = "gp2"
          }
        }
      }
    }

    worker-group-2 = {
      min_size      = 1
      desired_size  = 1
      max_size      = 3
      instance_type = "t2.medium"

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            delete_on_termination = true
            encrypt               = true
            volume_size           = 50
            volume_type           = "gp2"
          }
        }
      }
    }
  }
  tags = local.tags
}

# module "key_pair" {
#   source  = "terraform-aws-modules/key-pair/aws"
#   version = "~> 2.0"

#   key_name_prefix    = local.name
#   create_private_key = true

#   tags = local.tags
# }

# module "lb_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "${var.env_name}_eks_lb"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_issuer
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }


# # localhost registry with password protection
#   registry {
#     url = "oci://localhost:5000"
#     username = "username"
#     password = "password"
#   }

#   # private registry
#   registry {
#     url = "oci://private.registry"
#     username = "username"
#     password = "password"
#   }

#apply argo app manifest to cluster & start monitoring cluster, infra from argo-config repo
