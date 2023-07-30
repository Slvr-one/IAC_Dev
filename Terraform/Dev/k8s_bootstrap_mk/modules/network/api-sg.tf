# control planes - sg:
resource "aws_security_group" "k8s_api" {
  name        = "k8s-api"
  vpc_id      = aws_vpc.k8s.id
  description = "access to control plane vms"

  # Allow inbound traffic to the port used by K8s API HTTPS
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    cidr_blocks = ["${var.control_cidr}"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags,
    {
      Name = "kubernetes-api"
    }
  )
}

# resource "aws_security_group_rule" "allow_ssh_from_vpc_to_api_sg" {
#  type              = "ingress"
#  description       = "Allow SSH from VPC"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]
#  security_group_id = aws_security_group.k8s_api.id
# }

# resource "aws_security_group_rule" "allow_all_myip_api" {
#   type            = "ingress"
#   from_port       = 0
#   to_port         = 0
#   protocol        = "all"
#   cidr_blocks     = ["${data.external.myipaddr.result["ip"]}/32"]
#   description     = "Management Ports for K8s Cluster"

#   security_group_id = aws_security_group.k8s_api.id
# }