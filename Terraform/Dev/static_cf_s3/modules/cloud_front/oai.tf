

resource "aws_cloudfront_origin_access_identity" "static" {
  comment = "static CloudFront OAI"
  # comment = "s3-my-webapp.example.com"
}

resource "aws_cloudfront_origin_access_identity_attachment" "static" {
  count = length(aws_cloudfront_distribution.static.origin)

  origin_id                  = aws_cloudfront_distribution.static.origin[count.index].origin_id
  cloudfront_origin_access_identity = aws_cloudfront_origin_access_identity.static.cloudfront_access_identity_path
}
