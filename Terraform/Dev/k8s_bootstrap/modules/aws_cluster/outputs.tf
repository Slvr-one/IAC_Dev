# output "instances" {
#   value       = aws_instance.node
#   description = "All Machine details"
# }

output "k8s_api_dns_name" {
  value = aws_elb.k8s_api.dns_name
}

output "k8s_api" {
  value = aws_elb.k8s_api
}

output "control-plane_nodes" {
  value = aws_instance.controller.*
}

output "etcd_nodes" {
  value = aws_instance.etcd.*
}

output "worker_nodes" {
  value = aws_instance.worker.*
}

# output "kubernetes_workers_public_ip" {
#   value = join(",", aws_instance.worker.*.public_ip)
# }