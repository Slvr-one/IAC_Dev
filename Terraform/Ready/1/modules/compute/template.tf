data "template_file" "nginx_srv" {
  template = file("${path.module}/user_data/nginx.tftpl")
  vars = {
    nginx_port = var.nginx_port
  }
}