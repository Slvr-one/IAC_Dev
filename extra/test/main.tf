
#cluster vprovisioning
module "eks" {
  source = "./modules/eks"

  cluster      = var.cluster
  cluster_name = var.cluster_name

  cluster_role = module.iam.cluster_iam_role
  nodes_role   = module.iam.nodes_iam_role

  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets

  cluster_policy_attach = module.iam.cluster_policy_attach
  nodes_policys_attach = [
    module.iam.nodes_policy_attach_worker,
    module.iam.nodes_policy_attach_cni,
    module.iam.nodes_policy_attach_ecr,
    module.iam.nodes_policy_attach_vpc
  ]
}

#cluster & nodes iam roles
module "iam" {
  source = "./modules/iam"

  fingerprint = module.tls.cert_fingerprint
  oidc_issuer = module.eks.oidc_issuer
}

#tls cert for open id connect to cluster
module "tls" {
  source = "./modules/tls"

  oidc_issuer = module.eks.oidc_issuer
}

#cluster vpc & subnets
module "network" {
  source = "./modules/network"

  env    = var.env
  tags   = var.tags
  region = var.region
  eks_cluster = module.eks.cluster//
}

#deploy argocd helm chart in cluster
module "helm" {
  source = "./modules/helm"
}

#apply argo app manifest to cluster & start monitoring cluster, infra from argo-config repo

