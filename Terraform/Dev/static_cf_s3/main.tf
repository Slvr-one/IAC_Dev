module "s3" {
  source = "./modules/s3"

  kms_master_key_id = module.kms.kms_key.arn
  bucket_name = var.bucket_name
}

module "kms" {
  source = "./modules/kms"
}

module "waf" {
  source = "./modules/waf"
}

module "cloudfront" {
  source = "./modules/cloud_front"

  distro_name = var.distro_name

  bucket_name = module.s3.bucket_name
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  # origin_domain_name = module.s3.bucket_domain_name
  # origin_path = module.s3.bucket_path

  waf_acl_id = module.waf.waf_acl_id
}
