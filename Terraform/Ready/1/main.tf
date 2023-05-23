module "network" {
  source = "./modules/network"

  gen_tags = var.gen_tags
  az       = data.aws_availability_zones.available.names

  public_sb_count  = var.public_sb_count
  private_sb_count = var.private_sb_count

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name

  nginx_port = var.nginx_port
  local_ip   = data.external.myipaddr.result.ip

  depends_on = [module.tls]
}

module "compute" {
  source = "./modules/compute"

  aws_region   = var.aws_region
  az           = data.aws_availability_zones.available.names
  gen_tags     = var.gen_tags
  HA           = var.HA
  amis         = var.amis
  keypair_name = var.keypair_name

  public_subnets_ids   = module.network.public_subnets_ids
  private_subnets_ids  = module.network.private_subnets_ids
  elb_name             = var.elb_name
  nginx_port           = var.nginx_port
  main_sg_id           = module.network.main_sg_ids
  ubuntu_instance_type = var.ubuntu_instance_type
}

module "tls" {
  source = "./modules/tls"

  keypair_name = var.keypair_name
}
