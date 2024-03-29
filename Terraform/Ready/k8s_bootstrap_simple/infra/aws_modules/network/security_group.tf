resource "aws_security_group" "kubeadm_sg" {
  name        = var.sg_name
  description = "kubeadm security group"
  vpc_id      = aws_vpc.kubeadm_vpc.id


  # Inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.local_ip_address}/32"]
  }

  ingress {
    from_port   = 30001
    to_port     = 30001
    protocol    = "tcp"
    cidr_blocks = ["${local.local_ip_address}/32"]
  }

  # Outbound rules
  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}