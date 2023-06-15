profile = "default"
region  = "eu-central-1" #frankfurt
az      = "eu-central-1a"

tags = {
  Owner           = "Dvir Gross"
  expiration_date = "x.x.x"
  Bootcamp        = "16"
  ManagedBy       = "terraform"
}

HA = true

amis = { eu-central-1 = "ami-0ec7f9846da6b0f61" }

cluster_name = "dev-24"
elb_name     = "kubernetes"
keypair_name = "kp-one"

k8s_cluster_dns = "10.31.0.1"

vpc_cidr            = "10.43.0.0/16"
control_cidr        = "147.235.205.46/32"
kubernetes_pod_cidr = "10.200.0.0/16"


instance_user      = "ubuntu"
keypair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmI+/POIw5Gg1ZggK68Zt+ftLOvYdXcz1Q4rdRaEtVeHgX5uXjPuWvaEhqZ33tcZtxpgvv/vxBLhokLgP7nC7LdTJL2G91xbZikp+b/Y0uXG4COETkOneB5BqMhUJD3qUSgc+PzOMmrNGcz+rzHXLfWQzIWYWdq8yxcbwkmZgbyg9AvFlFCJr3k8nDjPzFRWnjRNd9dxdarx6TtJiDsKz5EaEfaczqno9OOM73X0t0djlRXzRT5zJiuwK8tk7SxW19NBxvp/jwg684ivcV/xind/t8I4mLe71tKxYOLg0R7mIM/4C13IdZ9OhucIfbgMsO31vLDwd1VPuaHA+lIuRvOshaG8klANIGxfGMZxhVb07K95fpCJz1GY+cR4oEvd3DOxIqRrBzFg4LoS53aTj69XearPw8ZHsBaXCpcUEHHSmpvTkWUtWponuZotJsvUUQ1wyRKPTQFAIFfi6WtiCwazMjsXyPlwDiUjYl7BXJUGc9CByL2DDpbUwOXJpPTYU= dvir@vivobook"

ansibleFilter                = "Kubernetes01" #CHANGE instance_filters = tag:ansibleFilter=Kubernetes01 in ./ansible/hosts/ec2.ini
ansible_master_instance_type = "t2.medium"
etcd_instance_type           = "t2.medium"
controller_instance_type     = "t2.medium"
worker_instance_type         = "t2.medium"

# env = "dev"

# configuration = [
#   {
#     "node" : "control-plane",
#     "ami" : "ami-09e67e426f25ce0d7",
#     "instance_type" : "t2.medium",
#     "no_of_instances" : "3",
#     "subnet_id" : "subnet-0f4f294d8404946eb",
#     "vpc_security_group_ids" : ["sg-0d15a4cac0567478c", "sg-0d8749c35f7439f3e"]
#   },
#   {
#     "node" : "etcd",
#     "ami" : "ami-0747bdcabd34c712a",
#     "instance_type" : "t2.medium",
#     "no_of_instances" : "3"
#     "subnet_id" : "subnet-0f4f294d8404946eb"
#     "vpc_security_group_ids" : ["sg-0d15a4cac0567478c"]
#   },
#   {
#     "node" : "worker",
#     "ami" : "ami-0747bdcabd34c712a",
#     "instance_type" : "t3.micro",
#     "no_of_instances" : "3"
#     "subnet_id" : "subnet-0f4f294d8404946eb"
#     "vpc_security_group_ids" : ["sg-0d15a4cac0567478c"]
#   }
# ]

# cluster = [
#   {
#     node_group = {
#       instance_types = ["t3.small"]
#       # scaling_config = {
#       #   desired_size = 1
#       #   max_size     = 5
#       #   min_size     = 0
#       # }
#     }
#     # username = "role1"
#     # groups   = ["system:masters"]
#   },
# ]


# source_files = {
#   user_data = "./user_data.sh"
#   static    = "../app/src/main/resources/static"
#   conf      = "../nginx/nginx.conf"
#   compose   = "../docker-compose.yml"
# }

# cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# cidr_block = ["10.0.1.0/24"]
