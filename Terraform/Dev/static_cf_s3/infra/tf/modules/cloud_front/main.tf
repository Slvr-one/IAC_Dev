
resource "aws_s3_bucket_policy" "static" {
  bucket = var.bucket_name #"static-bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.static.id}"
        }
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::static-bucket/*"
      }
    ]
  })

  # policy = data.aws_iam_policy_document.s3_policy.json
}

# resource "aws_s3_bucket_policy" "access" {
#   bucket = "static-bucket"

#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "Statement1",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::io.myapp/*"
#         }
#     ]
#   })
# }

resource "aws_cloudfront_key_group" "kg_static" {
  name = "static-key-group"

  items = [aws_cloudfront_public_key.example.id]
}

resource "aws_cloudfront_public_key" "pk_static" {
  name       = "static-public-key"
  encoded_key = file("path/to/your/public_key.pem")
  comment    = "static CloudFront public key"
}