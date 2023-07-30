
locals {
  ansible_dest    = "/home/ubuntu/dvir/ansible"
  ssh_user        = "ubuntu"
  private_ssh_key = "~/.ssh/kp-one.pem"
}

resource "null_resource" "ansible_setup" {

  triggers = {
    # always_run = timestamp()
    master_ready = element(aws_instance.ansible_master.*.public_ip, 0)
  }

  depends_on = [
    aws_instance.ansible_master
  ]

  connection {
    type        = "ssh"
    host        = element(aws_instance.ansible_master.*.public_ip, 0)
    user        = "ubuntu"
    timeout     = "4m"
    private_key = var.ssh_private_key
    # private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" { # setup 
    inline = [
      "mkdir -p ${local.ansible_dest}, .ssh} ",
      "sudo apt update -qqy",
      "sudo apt-add-repository -y --update ppa:ansible/ansible",
      "sudo apt install -qqy ansible tree curl software-properties-common",
    ]
  }
}

# resource "null_resource" "ansible_run" {
#   triggers = {
#     always_run = timestamp()
#     # master_ready = element(aws_instance.ansible_master.*.public_ip, 0)
#   }

#   depends_on = [
#     aws_instance.ansible_master
#   ]

#   connection {
#     type        = "ssh"
#     host        = element(aws_instance.ansible_master.*.public_ip, 0)
#     user        = "ubuntu"
#     timeout     = "4m"
#     private_key = var.ssh_private_key
#     # private_key = file("~/.ssh/id_rsa")
#   }

#   provisioner "file" { # copy dir of ansible roles, main playbook & inventory
#     source      = "${path.module}/ansible_config"
#     destination = "${local.ansible_dest}"

#   }

#   provisioner "remote-exec" { # check everything is in place
#     inline = [
#       "pwd && ls -alF '${local.ansible_dest}' && tree '${local.ansible_dest}'"
#     ]
#   }

#   provisioner "remote-exec" { # run ansible playbook
#     inline = [
#       "sudo chmod 777 '${local.ansible_dest}/ansible_config/inventory.ini'",
#       "sudo cp '${local.ansible_dest}/ansible_config/ansible.cfg' /etc/ansible/ansible.cfg",
#       #   "echo ${var.ssh_private_key} > ${local.private_ssh_key}",
#       "ansible-playbook -i '${local.ansible_dest}/ansible_config/inventory.ini' '${local.ansible_dest}/ansible_config/install_kubernetes.yaml' --user ${local.ssh_user}" # --key-file ${local.private_ssh_key}
#     ]
#   }
# }



resource "null_resource" "ansible_run" {
  triggers = {
    always_run = timestamp()
    # master_ready = element(aws_instance.ansible_master.*.public_ip, 0)
  }

  depends_on = [
    aws_instance.ansible_master,
    null_resource.ansible_setup
  ]

  # provisioner "local-exec" { # cp ansible.cfg to its default location
  #   command = "sudo cp '${path.module}/ansible_config/ansible.cfg' /etc/ansible/ansible.cfg"
  #     # "sudo chmod 777 '${path.module}/ansible_config/inventory.ini'",
  #     #   "echo ${var.ssh_private_key} > ${local.private_ssh_key}",
  # }

  provisioner "local-exec" { # run ansible playbook
    command = "ansible-playbook -i '${path.module}/ansible_config/inventory.ini' '${path.module}/ansible_config/install_kubernetes.yaml' --user ${local.ssh_user} --key-file ${local.private_ssh_key}"
  }

}
