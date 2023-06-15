ec2 = {
  keyPairName  = "dvir_ted"
  instanceType = "t2.micro"
}

tags = {
  Owner           = "dvir.gross"
  expiration_date = "25-11-22"
  bootcamp        = "16"
}

source_files = {
  user_data = "./user_data.sh"
  static    = "../app/src/main/resources/static"
  conf      = "../nginx/nginx.conf"
  compose   = "../docker-compose.yml"
}

# cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
cidr_block = ["10.0.1.0/24"]

user_data = "./user_data.sh"

env = "dev"

region = "us-east-2" #ohio