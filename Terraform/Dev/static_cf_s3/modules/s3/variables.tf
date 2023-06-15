
variable "bucket_name" {
  description = "state s3 bucket name"
}

variable "kms_master_key_id" {
  description = "for bucket server side encription"
}

variable "gen_tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}