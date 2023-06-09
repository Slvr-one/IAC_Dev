resource "aws_security_group" "main" {
  name        = "allow ssh and http"
  description = "SSH on port 22 and HTTP on port 80"
  vpc_id      = aws_vpc.main.id

  # dynamic "ingress" { #TODO
  #   for_each = var.ingress_ports
  #   content {
  #     from_port   = ingress.value
  #     to_port     = ingress.value
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  # }

  ingress {
    from_port   = var.nginx_port
    to_port     = var.nginx_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "for elb access to instances"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.local_ip}/32"]
    description = "allow all traffic to instances & elb from user local machine"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}