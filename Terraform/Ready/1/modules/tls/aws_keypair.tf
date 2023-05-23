resource "aws_key_pair" "generated_key" {

  key_name   = var.keypair_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}
