resource "digitalocean_droplet" "web" {
  count = 3
  image = "ubuntu-20-04-x64"
  # name   = "web-${count.index}"
  name   = format("%s-%s", data.external.droplet_name.result.name, count.index)
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install -y python3"]

    connection {
      host  = self.ipv4_address
      type  = "ssh"
      user  = "root"
      agent = true
      # private_key = file(var.pvt_key)
      timeout = "7m"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' ./ansible/apache-install.yaml"
  }
}