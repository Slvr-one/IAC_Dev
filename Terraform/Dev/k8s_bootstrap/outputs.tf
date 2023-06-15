output "controllers_ip" {
  value       = var.HA ? module.cluster.control-plane_nodes.*.public_ip : module.cluster.control-plane_nodes.public_ip
  description = "public IP of master nodes"
}

output "workers_ip" {
  value       = var.HA ? module.cluster.worker_nodes.*.public_ip : module.cluster.worker_nodes.public_ip
  description = "public IP of worker nodes"
}

output "api_server" {
  value       = module.cluster.k8s_api_dns_name
  description = "api server endpoint, load balancer of control nodes"
} 