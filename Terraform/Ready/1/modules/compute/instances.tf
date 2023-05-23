
resource "aws_instance" "ubuntu" {

  count         = var.HA ? 2 : 1
  ami           = lookup(var.amis, var.aws_region)
  instance_type = var.ubuntu_instance_type

  subnet_id              = element(var.public_subnets_ids.*, count.index)
  availability_zone      = var.az[count.index]
  vpc_security_group_ids = [var.main_sg_id]
  key_name               = var.keypair_name

  user_data = data.template_file.nginx_srv.rendered

  tags = merge(var.gen_tags,
    {
      Name = "ubuntu-${count.index}"
    }
  )
}
