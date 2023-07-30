
data "aws_availability_zones" "available" {
  state = "available"
}

# # existing ecr data--
# data "aws_ecr_repository" "bm_repo" {
#   name = "bookmaker"
# } 

# data "external" "myipaddr" {
#   program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   owners = ["099720109477"]
# }

# data "aws_ami" "al2_latest" {
#   owners      = ["amazon"]
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#   }
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }


# data aws_ami latest_ubuntu_ami {
#     most_recent = true
#     owners = ["099720109477"]
#     filter {
#         name = "name"
#         values = [""]
#     }
#     filter {
#         name = "virtualization-type"
#         values = ["hvm"]
#     }
# }