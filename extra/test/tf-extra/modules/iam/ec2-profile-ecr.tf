
#IAM role for ec2 to assume--
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#IAM policy to attach to ec2 role--
resource "aws_iam_policy" "ecr_allow_policy" {
  name = "ec2_ecr_access_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#attach policy to role--
resource "aws_iam_policy_attachment" "ecr_policy_attachment" {
  name       = "ec2-attach"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ecr_allow_policy.arn
}
#ubuntu profile with ecr-policy role--
resource "aws_iam_instance_profile" "ubuntu_profile" {
  name = "ubuntu"
  role = aws_iam_role.ec2_role.name
}

output "iam_profile" {
  value = aws_iam_instance_profile.ubuntu_profile
}
