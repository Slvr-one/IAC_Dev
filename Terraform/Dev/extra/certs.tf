# Generate Certificates
data "template_file" "certificates" {
  template   = file("${path.module}/template/k8s-csr.json")
  depends_on = [module.cluster.k8s_api, module.cluster.etcd_nodes, module.cluster.conrtrol-plane_nodes, module.cluster.worker_nodes]
  vars = {
    kubernetes_api_elb_dns_name = module.cluster.k8s_api_dns_name
    kubernetes_cluster_dns      = "${var.k8s_cluster_dns}"

    # Unfortunately, variables must be primitives, neither lists nor maps
    etcd0_ip       = module.cluster.etcd_nodes.0.private_ip
    etcd1_ip       = module.cluster.etcd_nodes.1.private_ip
    etcd2_ip       = module.cluster.etcd_nodes.2.private_ip
    controller0_ip = module.cluster.control-plane_nodes.0.private_ip
    controller1_ip = module.cluster.control-plane_nodes.1.private_ip
    controller2_ip = module.cluster.control-plane_nodes.2.private_ip
    worker0_ip     = module.cluster.worker_nodes.0.private_ip
    worker1_ip     = module.cluster.worker_nodes.1.private_ip
    worker2_ip     = module.cluster.worker_nodes.2.private_ip

    etcd0_dns       = module.cluster.etcd_nodes.0.private_dns
    etcd1_dns       = module.cluster.etcd_nodes.1.private_dns
    etcd2_dns       = module.cluster.etcd_nodes.2.private_dns
    controller0_dns = module.cluster.control-plane_nodes.0.private_dns
    controller1_dns = module.cluster.control-plane_nodes.1.private_dns
    controller2_dns = module.cluster.control-plane_nodes.2.private_dns
    worker0_dns     = module.cluster.worker_nodes.0.private_dns
    worker1_dns     = module.cluster.worker_nodes.1.private_dns
    worker2_dns     = module.cluster.worker_nodes.2.private_dns
  }
}
resource "null_resource" "certificates" {
  triggers = {
    template_rendered = data.template_file.certificates.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.certificates.rendered}' > ../cert/kubernetes-csr.json"
  }
  provisioner "local-exec" {
    command = "cd ../cert; cfssl gencert -initca ca-csr.json | cfssljson -bare ca; cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes"
  }
}