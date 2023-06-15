env = "dev"

region = "eu-central-1" #frankfurt

cluster_name = "victor-12"

cluster = [
  {
    node_group = {
      instance_types = ["t3.small"]
      # scaling_config = {
      #   desired_size = 1
      #   max_size     = 5
      #   min_size     = 0
      # }
    }
    # username = "role1"
    # groups   = ["system:masters"]
  },
]

tags = {
  Owner           = "dvir.gross"
  expiration_date = "tomorrow"
  bootcamp        = "16"
}

# service_port = 5000

# image = "514095112279.dkr.ecr.eu-central-1.amazonaws.com/bookmaker"

# image_tag = "latest"

# source_files = {
#   user_data = "./user_data.sh"
#   static    = "../app/src/main/resources/static"
#   conf      = "../nginx/nginx.conf"
#   compose   = "../docker-compose.yml"
# }

# cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# cidr_block = ["10.0.1.0/24"]

# user_data = "./user_data.sh"

# ec2 = {
#   keyPairName  = "dvir_ted"
#   instanceType = "t2.micro"
# }