
#tls provider for provisioned key generating--
resource "tls_private_key" "dvir_ted" {
  algorithm = "ED25519"
}

#personal key pair--
resource "aws_key_pair" "dvir_ted" {
  key_name   = var.ec2["keyPairName"]
  public_key = tls_private_key.dvir_ted.public_key_openssh

}

#instance - 1-- 
resource "aws_instance" "ubuntu_dvir" {
  # for_each = var.source_files[*]

  ami                    = "ami-097a2df4ac947655f"
  instance_type          = var.ec2["instanceType"]
  key_name               = var.ec2["keyPairName"]
  vpc_security_group_ids = [var.ted_sg_id]
  subnet_id              = var.ted_subnet_id
  user_data              = file(var.source_files["user_data"])
  iam_instance_profile   = var.iam_profile
  # user_data_replace_on_change = true
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    timeout     = "1m"
    private_key = tls_private_key.dvir_ted.private_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 50",
      "docker --version",
      "mkdir dvir/"
    ]
  }
  provisioner "file" {
    source      = var.source_files["static"]
    destination = "home/ubuntu/dvir/static/"

  }
  provisioner "file" {
    source      = var.source_files["conf"]
    destination = "home/ubuntu/dvir/nginx/"
  }
  provisioner "file" {
    source      = var.source_files["compose"]
    destination = "home/ubuntu/dvir/docker-compose.yml"
  }
  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/dvir/",
      "pwd && ls -alF && tree",
      "docker compose up -d --remove-orphans"
    ]
  }

  tags = {
    Name            = format("ted_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }
  volume_tags = {
    Name            = format("ted_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }
}

