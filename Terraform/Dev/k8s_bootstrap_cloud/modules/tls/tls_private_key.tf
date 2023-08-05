

resource "tls_private_key" "ssh_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  #   algorithm   = "ECDSA"
  #   ecdsa_curve = "P384"

  #   algorithm = "ED25519"

}