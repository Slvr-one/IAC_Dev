


# K8s API Load Balancer:
resource "aws_elb" "k8s_api" {
  name                      = var.elb_name
  instances                 = aws_instance.controller.*.id
  subnets                   = [var.k8s_subnet_id]
  cross_zone_load_balancing = false

  security_groups = [var.control-plane_sg_id, var.k8s_sg_id]

  listener {
    lb_port           = 6443
    instance_port     = 6443
    lb_protocol       = "TCP"
    instance_protocol = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    target              = "HTTP:8080/health"
    interval            = 30
  }

  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #   interval      = 60
  # }

  tags = merge(var.tags,
    {
      Name = "kubernetes"
    }
  )
}
