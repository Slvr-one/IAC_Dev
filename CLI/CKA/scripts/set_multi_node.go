package main

import (
	"fmt"
	"os"
	"os/exec"
)

func setMultiNodeCluster() {
	controlPlaneIP := "<control_plane_ip>"
	controlPlanePort := "<control_plane_port>"
	token := "<token>"
	discoveryTokenCACertHash := "<discovery_token_ca_cert_hash>"

	// Join worker nodes to the control-plane node
	workerNodes := []string{"worker1", "worker2", "worker3"}

	for _, node := range workerNodes {
		cmd := exec.Command("ssh", node, fmt.Sprintf("kubeadm join %s:%s --token %s --discovery-token-ca-cert-hash %s", controlPlaneIP, controlPlanePort, token, discoveryTokenCACertHash))
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err := cmd.Run()
		if err != nil {
			fmt.Printf("Error executing command on %s: %v\n", node, err)
		}
	}
}

func main() {
	if len(os.Args) > 1 && os.Args[1] == "set_multi_node_cluster" {
		setMultiNodeCluster()
	}
}
