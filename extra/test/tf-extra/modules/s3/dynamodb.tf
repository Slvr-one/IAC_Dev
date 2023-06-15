# for state lock while i work on the project
resource "aws_dynamodb_table" "state_lock" {
  name           = "state_lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = var.tags
}