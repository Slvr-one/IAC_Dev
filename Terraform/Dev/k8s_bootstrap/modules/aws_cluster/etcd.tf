# etcd cluster instances:
resource "aws_instance" "etcd" {

  count         = 0 #var.HA.etcd
  ami           = lookup(var.amis, var.region)
  instance_type = var.etcd_instance_type

  subnet_id                   = var.k8s_subnet_id
  private_ip                  = cidrhost(var.vpc_cidr, 10 + count.index)
  associate_public_ip_address = true

  availability_zone      = var.az
  vpc_security_group_ids = [var.control-plane_sg_id]
  key_name               = var.keypair_name

  tags = merge(var.tags,
    {
      Name            = "etcd-${count.index}"
      ansibleFilter   = var.ansibleFilter
      ansibleNodeType = "etcd"
      ansibleNodeName = "etcd${count.index}"
    }
  )
}
