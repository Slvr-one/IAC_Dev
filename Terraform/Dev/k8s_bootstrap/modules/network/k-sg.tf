
# cluster - sg:
resource "aws_security_group" "k8s" {
  name        = "k8s"
  vpc_id      = aws_vpc.k8s.id
  description = "access to workers vms"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${var.control_cidr}"]
  }

  # Allow all internal
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  # Allow all traffic from the API ELB
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.k8s_api.id}"]
  }

  # Allow all traffic from control host IP
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.control_cidr]
  }

  # # Allow all traffic from control host IP 
  # ingress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = [var.ansible_master_cidr]
  # }

  tags = merge(var.tags,
    {
      Name = "kubernetes"
    }
  )
}

# resource "aws_security_group_rule" "allow_ssh_from_vpc_to_gen_sg" {
#  type              = "ingress"
#  description       = "Allow SSH from VPC"
#  from_port         = 22
#  to_port           = 22
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"] #[aws_vpc.k8s.cidr_block]
#  security_group_id = aws_security_group.k8s.id
# }

# resource "aws_security_group_rule" "allow_all_myip_k8s" {
#   type            = "ingress"
#   from_port       = 0
#   to_port         = 0
#   protocol        = "all"
#   cidr_blocks     = ["${data.external.myipaddr.result["ip"]}/32"]
#   description     = "Management Ports for K8s Cluster"

#   security_group_id = aws_security_group.k8s.id
# }