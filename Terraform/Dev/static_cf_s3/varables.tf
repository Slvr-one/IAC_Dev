

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "region" {
  description = "AWS region to deploy to"
  type        = string
}

variable "gen_tags" {
  description = "general tags; Owner, exp_date"
  type        = map(any)
}

variable "distro_name" {
  description = "name for cloud front ditribution"
}

variable "bucket_name" {
    type = string
    description = "name of bucket" 
}