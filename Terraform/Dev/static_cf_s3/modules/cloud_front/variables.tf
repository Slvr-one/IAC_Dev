variable "waf_acl_id" {
  description = "web application firewall access control list id for resricting access to cf ditro"
}

variable "bucket_regional_domain_name" {
  description = "domain name to be forwrded by cf ditro"
}

variable "bucket_name" {
  description = "bucket name to act as origin to cf ditro"
}

variable "distro_name" {
  description = "name for cloud front ditribution"
}