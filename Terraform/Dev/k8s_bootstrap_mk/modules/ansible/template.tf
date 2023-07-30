
resource "local_file" "ansible_inventory" {

  content = templatefile("${path.module}/templates/ansible_inventory.tftpl",
    {
      user        = "ubuntu"
      prefix      = "k8s"
      controllers = var.controllers
      workers     = var.workers
    }
  )

  filename        = "${path.module}/ansible_config/inventory.ini"
  file_permission = 644
}

# resource "local_file" "ansible_playbook" {

#   content = file("${path.module}/templates/ansible_playbook.yaml")

#   filename        = "${path.module}/playbook.yaml"
#   file_permission = 644
# }