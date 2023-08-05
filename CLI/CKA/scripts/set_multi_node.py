import subprocess
import sys

def set_multi_node_cluster(control_plane_ip, control_plane_port, token, discovery_token_ca_cert_hash):
    # Join worker nodes to the control-plane node
    worker_nodes = ['worker1', 'worker2', 'worker3'] 

    for node in worker_nodes:
        # SSH into the worker node and execute the join command
        join_command = f'kubeadm join {control_plane_ip}:{control_plane_port} --token {token} --discovery-token-ca-cert-hash {discovery_token_ca_cert_hash}'
        ssh_command = f'ssh {node} "{join_command}"'
        subprocess.run(ssh_command, shell=True)

    # Add any other necessary steps to configure the cluster for multiple nodes

if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'set_multi_node_cluster':
        set_multi_node_cluster('<control_plane_ip>', '<control_plane_port>', '<token>', '<discovery_token_ca_cert_hash>')
    else:
        # Default behavior
        install_dependencies()
        setup_cluster()
        run_application()
        perform_post_installation_tasks()
