
# resource "null_resource" "save_key_pair_localy" {

#   # will run on every apply
#   triggers = { 
#     always_run = timestamp()
#   }

#   # Generate and save private on local disk 
#   provisioner "local-exec" {
#     command = <<-EOT
#       echo '${tls_private_key.ssh_private_key.private_key_pem}' > '~/.ssh/${var.keypair_name}'
#       chmod 400 '~/.ssh/${var.keypair_name}'
#     EOT
#   }
# }