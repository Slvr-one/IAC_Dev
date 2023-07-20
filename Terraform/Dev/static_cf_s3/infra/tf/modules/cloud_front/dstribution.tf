

resource "aws_cloudfront_distribution" "static" {
  origin {
    domain_name = var.bucket_regional_domain_name #"static-bucket.s3.amazonaws.com"
    origin_id   = var.bucket_name #"static-bucket"
  }

  enabled             = true
#   is_ipv6_enabled     = true
  comment             = "static CloudFront distribution"
  default_root_object = "index.html"
  trusted_key_groups = [aws_cloudfront_key_group.example.id]
  web_acl_id = var.web_acl_id 


  default_cache_behavior {
    # allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name # "static-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" # "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"

      # restriction_type = "whitelist"
      # locations        = ["US", "CA", "GB", "DE", "IN", "IR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Configure logging here if required 	
  #logging_config {
  #  include_cookies = false
  #  bucket          = "mylogs.s3.amazonaws.com"
  #  prefix          = "myprefix"
  #}

  # If you have domain configured use it here 
  #aliases = ["mywebsite.example.com", "s3-static-web-dev.example.com"]

  tags = merge(var.gen_tags, {
    Name = var.distro_name
  })
}