#existing ecr data--
data "aws_ecr_repository" "ted_private_repo" {
  name = "ted-dvir"
}

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
