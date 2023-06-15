
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    # host     = "https://cluster_endpoint:port"

    # client_certificate     = file("~/.kube/client-cert.pem")
    # client_key             = file("~/.kube/client-key.pem")
    # cluster_ca_certificate = file("~/.kube/cluster-ca-cert.pem")
  }

  # localhost registry with password protection
  registry {
    url      = "oci://localhost:5000"
    username = "username"
    password = "password"
  }

  # private registry
  registry {
    url      = "oci://private.registry"
    username = "username"
    password = "password"
  }
}