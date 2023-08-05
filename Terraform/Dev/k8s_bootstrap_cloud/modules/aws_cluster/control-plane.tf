# K8s Control Pane instances:
resource "aws_instance" "controller" {

  count         = var.HA ? 3 : 1
  ami           = lookup(var.amis, var.region)
  instance_type = var.controller_instance_type

  iam_instance_profile = var.k8s_iam_profile

  subnet_id                   = var.k8s_subnet_id
  private_ip                  = cidrhost(var.vpc_cidr, 20 + count.index)
  associate_public_ip_address = true
  source_dest_check           = false

  availability_zone      = var.az
  vpc_security_group_ids = [var.control-plane_sg_id, var.k8s_sg_id]
  key_name               = var.keypair_name

  tags = merge(var.tags,
    {
      Name            = "controller-${count.index}"
      ansibleFilter   = var.ansibleFilter
      ansibleNodeType = "controller"
      ansibleNodeName = "controller${count.index}"
    }
  )
}
