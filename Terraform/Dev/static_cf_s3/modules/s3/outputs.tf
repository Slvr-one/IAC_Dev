
locals {
  enabled = true
}

output "enabled" {
  value       = local.enabled
  description = "Is module enabled"
}

output "bucket_id" {
  value       = local.enabled ? join("", aws_s3_bucket.tf-state.*.id) : ""
  description = "Bucket Name / ID"
}

output "bucket_arn" {
  value       = local.enabled ? join("", aws_s3_bucket.tf-state.*.arn) : ""
  description = "Bucket ARN"
}

output "bucket_region" {
  value       = local.enabled ? join("", aws_s3_bucket.tf-state.*.region) : ""
  description = "Bucket region"
}


output "bucket_domain_name" {
  value       = local.enabled ? join("", aws_s3_bucket.tf-state.*.bucket_domain_name) : ""
  description = "FQDN of bucket"
}

output "bucket_regional_domain_name" {
  value       = local.enabled ? join("", aws_s3_bucket.tf-state.*.bucket_regional_domain_name) : ""
  description = "The bucket region-specific domain name"
}