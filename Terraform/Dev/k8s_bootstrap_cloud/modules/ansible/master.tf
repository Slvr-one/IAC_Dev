
# provisioner block will install Ansible on the EC2 instances 
# and run the install-kubernetes.yaml playbook.
resource "aws_instance" "ansible_master" {
  count = 1

  ami               = lookup(var.amis, var.region)
  instance_type     = var.ansible_master_instance_type
  availability_zone = var.az
  key_name          = var.keypair_name

  subnet_id                   = var.k8s_subnet_id
  associate_public_ip_address = true

  vpc_security_group_ids = [var.control-plane_sg_id, var.k8s_sg_id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "8"
    delete_on_termination = true
  }

  tags = merge(var.tags,
    {
      Name = "ansible master"
    }
  )
}
