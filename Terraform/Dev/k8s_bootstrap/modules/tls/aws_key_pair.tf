

resource "aws_key_pair" "generated_key" {

  key_name   = var.keypair_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh

}

resource "null_resource" "save_key_pair_localy" {

  triggers = {
    always_run = timestamp()
  }

  # Generate and save private key(kp-one.pem) on local disk 
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh_private_key.private_key_pem}' > ~/.ssh/kp-one.pem
      chmod 400 ~/.ssh/kp-one.pem
    EOT
    # environment = {
    #   FOO = "bar"
    #   BAR = 1
    #   BAZ = "true"
    # }
  }

  # provisioner "local-exec" {
  #   command = <<EOT
  #     kubectl apply -f ${local.configmap_auth_file} --kubeconfig ${var.kubeconfig_path}
  #   EOT
  # }
}