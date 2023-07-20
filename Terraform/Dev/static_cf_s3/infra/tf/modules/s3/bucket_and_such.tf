
#S3 bucket--
resource "aws_s3_bucket" "static_serve" {
  bucket        = var.bucket_name
  # force_destroy = true 
  # acl    = "private"

  # Add specefic S3 policy in the s3-policy.json on the same directory
  #policy = file("s3-policy.json")

  # website {
  #   index_document = "index.html"
  #   error_document = "error.html"
	
	# # Add routing rules if required
  #   #routing_rules = <<EOF
  #   #                [{
  #   #                    "Condition": {
  #   #                        "KeyPrefixEquals": "docs/"
  #   #                    },
  #   #                    "Redirect": {
  #   #                        "ReplaceKeyPrefixWith": "documents/"
  #   #                    }
  #   #                }]
  #   #                EOF
  # }

  tags = merge(var.gen_tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.static_serve.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.static_serve.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]

}

resource "aws_s3_bucket_versioning" "bucket_ver" {
  bucket = aws_s3_bucket.static_serve.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_sse_config" {
  bucket = aws_s3_bucket.static_serve.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = "aws:kms"
      # sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_serve.id

  block_public_acls       = true
  block_public_policy     = true
  # ignore_public_acls      = true
  # restrict_public_buckets = true
}