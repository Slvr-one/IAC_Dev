
resource "aws_elb" "ubuntu_lb" {
  count   = 1
  name    = var.elb_name
  subnets = var.public_subnets_ids.*
  security_groups = [var.main_sg_id]

  instances                   = aws_instance.ubuntu.*.id
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.nginx_port}/"
    interval            = 30
    # path                = "/healthcheck" 
  }

  listener {
    lb_port           = 8000
    lb_protocol       = "TCP"
    instance_port     = var.nginx_port
    instance_protocol = "TCP"
  }

  tags = merge(var.gen_tags,
    {
      Name = var.elb_name
    }
  )
}