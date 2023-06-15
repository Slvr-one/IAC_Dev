
# Generate ../ssh.cfg
data "template_file" "ssh_cfg" {
  template   = file("${path.module}/template/ssh.cfg")
  depends_on = [module.cluster.conrol-plane_nodes, module.cluster.etcd_nodes, module.cluster.worker_nodes]
  vars = {
    user = var.instance_user

    etcd0_ip       = module.cluster.etcd_nodes.0.public_ip
    etcd1_ip       = module.cluster.etcd_nodes.1.public_ip
    etcd2_ip       = module.cluster.etcd_nodes.2.public_ip
    controller0_ip = module.cluster.control-plane_nodes.0.public_ip
    controller1_ip = module.cluster.control-plane_nodes.1.public_ip
    controller2_ip = module.cluster.control-plane_nodes.2.public_ip
    worker0_ip     = module.cluster.worker_nodes.0.public_ip
    worker1_ip     = module.cluster.worker_nodes.0.public_ip
    worker2_ip     = module.cluster.worker_nodes.0.public_ip
  }
}
resource "null_resource" "ssh_cfg" {
  triggers = {
    template_rendered = data.template_file.ssh_cfg.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_cfg.rendered}' > ../ssh.cfg"
  }
}