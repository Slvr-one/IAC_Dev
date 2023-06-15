resource "digitalocean_loadbalancer" "web-lb" {
  name   = "web-lb"
  region = "fra1"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }
  droplet_ids = [
    digitalocean_droplet.web[0].id,
    digitalocean_droplet.web[1].id,
    digitalocean_droplet.web[2].id,
  ]
}