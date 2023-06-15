data "digitalocean_ssh_key" "terraform" {
  name = "local"
}

data "external" "droplet_name" {
  program = ["python3", "${path.module}/external/name-gen.py"]
}