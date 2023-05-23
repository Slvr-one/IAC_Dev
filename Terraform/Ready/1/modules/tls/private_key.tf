resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  # some other options:
  #   algorithm   = "ECDSA"
  #   algorithm = "ED25519"
  #   ecdsa_curve = "P384"
}