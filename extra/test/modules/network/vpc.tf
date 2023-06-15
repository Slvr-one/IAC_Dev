#vpc--
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" //65000 ips
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name            = format("main_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
    "kubernetes.io/cluster/${var.eks_cluster.name}" = "shared"
  }

}

#igw--
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }

  # tags = {
  #   Name            = format("dvir_%s", var.env)
  #   Owner           = var.tags["Owner"]
  #   expiration_date = var.tags["expiration_date"]
  #   bootcamp        = var.tags["bootcamp"]
  # }
}
