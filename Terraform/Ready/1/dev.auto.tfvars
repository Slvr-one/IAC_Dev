aws_profile = "default"
aws_region  = "eu-central-1"

keypair_name         = "kp-one"
ubuntu_instance_type = "t2.micro"

gen_tags = {
  Owner           = "gru minion"
  expiration_date = "x.x.x"
  ManagedBy       = "terraform"
}

HA   = true
amis = { eu-central-1 = "ami-0ec7f9846da6b0f61" }

vpc_cidr = "10.0.0.0/16"
vpc_name = "vpc-1"
elb_name = "nginxLB"

private_sb_count = 2
public_sb_count  = 2

nginx_port = 8090