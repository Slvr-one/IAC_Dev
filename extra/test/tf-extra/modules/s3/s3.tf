#S3--
resource "aws_s3_bucket" "ted_state" {
  bucket = "ted-state-dviross"

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name            = format("ted_state_%s", var.tags["Owner"])
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }
}
#S3 acess control list--
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.ted_state.id
  acl    = "private"
}
#S3 versioning--
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.ted_state.id

  versioning_configuration {
    status = "Enabled"
  }

}