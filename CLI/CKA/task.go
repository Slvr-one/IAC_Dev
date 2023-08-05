package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/user"
	"path/filepath"
	"strings"
	"time"
)

const (
	KubeConfigPath = "/etc/kubernetes/admin.conf"
	UA             = "unattended-upgrades"
)

func main() {
	if len(os.Args) < 2 {
		// When script runs without a flag, default is to setup cluster and run app.
		installDependencies()
		setupCluster()
		runApp()
		postInstall()

	} else {
		switch os.Args[1] {
		case "setup":
			installDependencies()
			setupCluster()
			postInstall()
		case "run_app":
			installDependencies()
			runApp()
			postInstall()
		case "run_test":
			runTest()
		default:
			log.Fatal("Invalid flag provided.")
		}
	}
}

func setupCluster() {

	// Environment variables
	kubernetesVersion := "1.26.3"
	ubuntuVersion, err := exec.Command("lsb_release", "-sr").Output()
	if err != nil {
		log.Fatal(err)
	}
	osVersion := fmt.Sprintf("xUbuntu_%s", string(ubuntuVersion))
	crioVersion := kubernetesVersion[:3]
	calicoVersion := "3.25.0"
	cidr := "10.32.0.0/12" // Default CIDR for Flannel/Canal

	addAptRepos(osVersion, crioVersion)

	installCrio()
	installKubePackages(kubernetesVersion)

	configEnvForKubernetes()

	initKubeadmCluster(kubernetesVersion, cidr)
	setKubeconfig()

	installClusterAddons(calicoVersion)
	setSingleNodeCluster()
	// setMultiNodeCluster()
}

func runApp() {
	// Clone the microservices-demo repository
	err := os.RemoveAll("microservices-demo")
	if err != nil {
		log.Fatal(err)
	}
	err = exec.Command("git", "clone", "https://github.com/microservices-demo/microservices-demo.git", "microservices-demo").Run()
	if err != nil {
		log.Fatal(err)
	}

	// Fix for microservices-demo issue #891: https://github.com/microservices-demo/microservices-demo/issues/891
	err = exec.Command("sed", "-i", "s/readOnlyRootFilesystem: true/readOnlyRootFilesystem: false/g", "microservices-demo/deploy/kubernetes/complete-demo.yaml").Run()
	if err != nil {
		log.Fatal(err)
	}

	// Create sock-shop namespace
	err = exec.Command("kubectl", "create", "namespace", "sock-shop").Run()
	if err != nil {
		log.Fatal(err)
	}

	// Apply sock-shop manifests
	err = exec.Command("kubectl", "apply", "-f", "microservices-demo/deploy/kubernetes/complete-demo.yaml").Run()
	if err != nil {
		log.Fatal(err)
	}
}

func runTest() {
	frontendUp := false
	fmt.Println("Deploying liveness probe")
	for {
		frontendIP, err := exec.Command("kubectl", "--namespace", "sock-shop", "get", "services/front-end", "--output", "jsonpath={.spec.clusterIP}:{.spec.ports[0].port}").Output()
		if err != nil {
			log.Fatal(err)
		}
		if _, err := exec.Command("curl", "-fsSLI", string(frontendIP), "--max-time", "0.1").Output(); err == nil {
			frontendUp = true
		} else {
			frontendUp = false
		}
		if frontendUp {
			fmt.Println("Probe is up, sleeping 5")
		} else {
			fmt.Println("Probe is down, sleeping 5")
		}
		time.Sleep(5 * time.Second)
	}
}

func installDependencies() {
	// Avoid apt interruptions
	err := exec.Command("sudo", "apt-get install", "-y", UA).Run()
	if err != nil {
		log.Fatal(err)
	}
	// Update and upgrade packages
	err = exec.Command("sudo", "apt-get", "update").Run()
	if err != nil {
		log.Fatal(err)
	}
	err = exec.Command("sudo", "apt-get", "upgrade", "-y").Run()
	if err != nil {
		log.Fatal(err)
	}
	// Install required packages
	packages := []string{"git", "curl", "lsb-release", "apt-transport-https", "ca-certificates", "software-properties-common"}
	for _, pkg := range packages {
		err = exec.Command("sudo", "apt-get", "install", "-y", pkg).Run()
		if err != nil {
			log.Fatal(err)
		}
	}
}

func postInstall() {
	// Enable and start unattended-upgrades
	err := exec.Command("sudo", "systemctl", "enable", UA).Run()
	if err != nil {
		log.Fatal(err)
	}
	err = exec.Command("sudo", "systemctl", "start", UA).Run()
	if err != nil {
		log.Fatal(err)
	}
	// Print completion message
	fmt.Println("Cluster setup and application deployment completed successfully!")
}

//////!SECTION

func addAptRepos(osVersion string, crioVersion string) {
	// Add CRI-O apt repo
	crioRepo := fmt.Sprintf("deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/%s/ /", osVersion)
	crioRepoCmd := exec.Command("sudo", "tee", "/etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list")
	crioRepoCmd.Stdin = strings.NewReader(crioRepo)
	err := crioRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	crioCrioRepo := fmt.Sprintf("deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/%s/%s/ /", crioVersion, osVersion)
	crioCrioRepoCmd := exec.Command("sudo", "tee", "/etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:"+crioVersion+".list")
	crioCrioRepoCmd.Stdin = strings.NewReader(crioCrioRepo)
	err = crioCrioRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Add Kubernetes apt repo
	kubernetesRepoCmd := exec.Command("sudo", "tee", "/etc/apt/sources.list.d/kubernetes.list")
	kubernetesRepoCmd.Stdin = strings.NewReader("deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main")
	err = kubernetesRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Add Helm apt repo
	helmRepoCmd := exec.Command("sudo", "tee", "/etc/apt/sources.list.d/helm-stable-debian.list")
	helmRepoCmd.Stdin = strings.NewReader("deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main")
	err = helmRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Update apt to get packages from newly-added repos
	updateCmd := exec.Command("sudo", "apt-get", "update")
	err = updateCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func installCrio() {
	// Install helm
	helmCmd := exec.Command("sudo", "apt-get", "install", "helm")
	err := helmCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Install cri-o, cri-o-runc, and cri-tools
	crioCmd := exec.Command("sudo", "apt-get", "install", "-y", "cri-o", "cri-o-runc", "cri-tools")
	err = crioCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Reload and enable CRI-O
	reloadCmd := exec.Command("sudo", "systemctl", "daemon-reload")
	err = reloadCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	enableCmd := exec.Command("sudo", "systemctl", "enable", "crio", "--now")
	err = enableCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func installKubePackages(kubernetesVersion string) {
	// Install kubelet, kubeadm, and kubectl
	kubeCmd := exec.Command("sudo", "apt-get", "update")
	err := kubeCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	kubePackages := []string{"kubelet=" + kubernetesVersion + "-00", "kubeadm=" + kubernetesVersion + "-00", "kubectl=" + kubernetesVersion + "-00"}
	installCmd := exec.Command("sudo", "apt-get", "install", "-y")
	installCmd.Args = append(installCmd.Args, kubePackages...)
	err = installCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Mark kubelet, kubeadm, and kubectl as held to prevent automatic upgrades
	markCmd := exec.Command("sudo", "apt-mark", "hold", "kubelet", "kubeadm", "kubectl")
	err = markCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func configEnvForKubernetes() {
	// Forwarding IPv4 and letting iptables see bridged traffic
	modulesConf := `overlay
	br_netfilter`
	modulesCmd := exec.Command("sudo", "tee", "/etc/modules-load.d/k8s.conf")
	modulesCmd.Stdin = strings.NewReader(modulesConf)
	err := modulesCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	modprobeCmd := exec.Command("sudo", "modprobe", "overlay")
	err = modprobeCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	modprobeCmd = exec.Command("sudo", "modprobe", "br_netfilter")
	err = modprobeCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// sysctl params required by setup, they persist across reboots
	sysctlConf := `net.bridge.bridge-nf-call-iptables  = 1
	net.bridge.bridge-nf-call-ip6tables = 1
	net.ipv4.ip_forward                 = 1`
	sysctlCmd := exec.Command("sudo", "tee", "/etc/sysctl.d/k8s.conf")
	sysctlCmd.Stdin = strings.NewReader(sysctlConf)
	err = sysctlCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	sysctlReloadCmd := exec.Command("sudo", "sysctl", "--system")
	err = sysctlReloadCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Verify that br_netfilter & overlay kernel modules are loaded
	lsmodCmd := exec.Command("lsmod")
	lsmodOutput, err := lsmodCmd.Output()
	if err != nil {
		log.Fatal(err)
	}

	if !strings.Contains(string(lsmodOutput), "br_netfilter") {
		log.Fatal("br_netfilter kernel module not loaded")
	}

	if !strings.Contains(string(lsmodOutput), "overlay") {
		log.Fatal("overlay kernel module not loaded")
	}

	// Turn off swap
	swapoffCmd := exec.Command("sudo", "swapoff", "-a")
	err = swapoffCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Remove swap entry from /etc/fstab
	fstabCmd := exec.Command("sudo", "sed", "-i", "/swap/d", "/etc/fstab")
	err = fstabCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func initKubeadmCluster(kubernetesVersion string, cidr string) {
	// Creating a single control-plane cluster with kubeadm
	pullImagesCmd := exec.Command("sudo", "kubeadm", "config", "images", "pull", "--kubernetes-version", kubernetesVersion, "--cri-socket=unix:///var/run/crio/crio.sock")
	err := pullImagesCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	initCmd := exec.Command("sudo", "kubeadm", "init", "--kubernetes-version", kubernetesVersion, "--cri-socket=unix:///var/run/crio/crio.sock", "--pod-network-cidr="+cidr, "--ignore-preflight-errors=NumCPU")
	err = initCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func setKubeconfig() {
	// Set kubeconfig for the root user
	if os.Getuid() == 0 {
		os.Setenv("KUBECONFIG", KubeConfigPath)
	}

	// Set kubeconfig for the current user
	homeDir, err := os.UserHomeDir()
	if err != nil {
		log.Fatal(err)
	}

	kubeconfigDir := filepath.Join(homeDir, ".kube")
	err = os.MkdirAll(kubeconfigDir, 0755)
	if err != nil {
		log.Fatal(err)
	}

	kubeconfigPath := filepath.Join(kubeconfigDir, "config")
	err = exec.Command("sudo", "cp", "-i", kubeconfigPath, kubeconfigPath).Run()
	if err != nil {
		log.Fatal(err)
	}

	err = exec.Command("sudo", "chown", fmt.Sprintf("%d:%d", os.Getuid(), os.Getgid()), kubeconfigPath).Run()
	if err != nil {
		log.Fatal(err)
	}

	// Set kubeconfig for the uid=1000 user (e.g., "ubuntu" user)
	if _, err := user.LookupId("1000"); err == nil {
		user1000HomeDir, err := os.UserHomeDir()
		if err != nil {
			log.Fatal(err)
		}

		user1000KubeconfigDir := filepath.Join(user1000HomeDir, ".kube")
		err = os.MkdirAll(user1000KubeconfigDir, 0755)
		if err != nil {
			log.Fatal(err)
		}

		user1000KubeconfigPath := filepath.Join(user1000KubeconfigDir, "config")
		err = exec.Command("sudo", "cp", "-i", kubeconfigPath, user1000KubeconfigPath).Run()
		if err != nil {
			log.Fatal(err)
		}

		err = exec.Command("sudo", "chown", "1000:1000", user1000KubeconfigPath).Run()
		if err != nil {
			log.Fatal(err)
		}
	}
}

func installClusterAddons(calicoVersion string) {
	// Install Canal CNI (Calico for policy and Flannel for networking)
	canalURL := fmt.Sprintf("https://raw.githubusercontent.com/projectcalico/calico/v%s/manifests/canal.yaml", calicoVersion)
	canalCmd := exec.Command("kubectl", "apply", "--filename", canalURL)
	err := canalCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Add Helm repos
	helmRepoCmd := exec.Command("helm", "repo", "add", "containeroo", "https://charts.containeroo.ch")
	err = helmRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	helmRepoCmd = exec.Command("helm", "repo", "add", "openebs", "https://openebs.github.io/charts")
	err = helmRepoCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	helmRepoUpdateCmd := exec.Command("helm", "repo", "update")
	err = helmRepoUpdateCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Install local-path-provisioner
	localPathCmd := exec.Command("helm", "upgrade", "--install", "local-path-provisioner", "containeroo/local-path-provisioner", "--namespace=local-path-storage", "--create-namespace")
	err = localPathCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	// Install OpenEBS CSI
	openebsCmd := exec.Command("helm", "upgrade", "--install", "openebs", "openebs/openebs", "--namespace=openebs", "--create-namespace")
	err = openebsCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

func setSingleNodeCluster() {
	// Untaint control-plane node to run as single-node cluster
	untaintCmd := exec.Command("kubectl", "taint", "nodes", "--all", "node-role.kubernetes.io/control-plane-")
	err := untaintCmd.Run()
	if err != nil {
		log.Fatal(err)
	}

	untaintMasterCmd := exec.Command("kubectl", "taint", "nodes", "--all", "node-role.kubernetes.io/master-")
	err = untaintMasterCmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}

// func setMultiNodeCluster() {
// 	// TODO: Implement the logic to set up a multi-node cluster
// 	// Add your code here to configure the cluster for multiple nodes
// 	// For example, you might want to join worker nodes to the control-plane node

// 	// Additional configuration steps for a multi-node cluster
// 	// Add any other necessary steps to configure the cluster for multiple nodes
// }
