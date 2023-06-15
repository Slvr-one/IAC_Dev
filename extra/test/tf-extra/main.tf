
module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/network"

  tags       = var.tags
  cidr_block = var.cidr_block
  env        = var.env
}

module "compute" {
  depends_on = [module.network]
  source     = "./modules/compute"

  tags          = var.tags
  ec2           = var.ec2
  cidr_block    = var.cidr_block
  ted_subnet_id = module.network.ted_subnet_id
  ted_sg_id     = module.network.ted_sg_id
  env           = var.env
  source_files  = var.source_files
  iam_profile   = module.iam.iam_profile.name
}

