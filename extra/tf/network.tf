#vpc-- #to module / data
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" //65000 ips

  tags = {
    Name            = format("main_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }

}

data "aws_eks_cluster_auth" "cluster" {
  # name = module.eks.cluster_id
  name = aws_eks_cluster.victor.id
}

data "aws_availability_zones" "available" {
}

# resource "aws_security_group" "worker_group_mgmt_one" {
#   name_prefix = "worker_group_mgmt_one"
#   vpc_id      = aws_vpc.main.id//module.vpc.vpc_id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [
#       "10.0.0.0/8",
#     ]
#   }

#   ingress {
#     from_port = 5000 #var.servicePort
#     to_port   = 5000 #var.servicePort
#     protocol  = "tcp"

#     cidr_blocks = [
#       "10.0.0.0/8",
#     ]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # dynamic "ingress" {
#   #   for_each = var.rules[*]
#   #   content {
#   #     description = ingress.value.desc
#   #     from_port   = ingress.value.port
#   #     to_port     = ingress.value.port
#   #     protocol    = ingress.value.protocol
#   #     cidr_blocks = ingress.value.cidr
#   #   }
#   # }

#   tags = {
#     Name            = format("bm%s", var.env)
#     Owner           = var.tags["Owner"]
#     expiration_date = var.tags["expiration_date"]
#     bootcamp        = var.tags["bootcamp"]
#   }
# }

#igw--
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

#subnets--
resource "aws_subnet" "private-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/19" //8000 ips
  availability_zone       = "${var.region}a"
  # map_public_ip_on_launch = true

  tags = {
    "Name"                            = "private-1a"
    "kubernetes.io/role/internal-elb" = "1" //for internal elb to discover
    "kubernetes.io/cluster/victor"    = "owned"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.32.0/19"
  availability_zone       = "${var.region}b"
  # map_public_ip_on_launch = true


  tags = {
    "Name"                            = "private-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/victor"    = "owned"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                         = "public-1a"
    "kubernetes.io/role/elb"       = "1" //create an elb in this subnet
    "kubernetes.io/cluster/victor" = "owned"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                         = "public-1b"
    "kubernetes.io/role/elb"       = "1"
    "kubernetes.io/cluster/victor" = "owned"
  }
}

#nat--
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

#rt routes--
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" #"10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  # route = [
  #   {
  #     cidr_block                 = "0.0.0.0/0"
  #     gateway_id                 = aws_internet_gateway.igw.id
  #     nat_gateway_id             = ""
  #     carrier_gateway_id         = ""
  #     destination_prefix_list_id = ""
  #     egress_only_gateway_id     = ""
  #     instance_id                = ""
  #     ipv6_cidr_block            = ""
  #     local_gateway_id           = ""
  #     network_interface_id       = ""
  #     transit_gateway_id         = ""
  #     vpc_endpoint_id            = ""
  #     vpc_peering_connection_id  = ""
  #     # core_network_arn           = ""

  #   },
  # ]
  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" #"10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  # route = [
  #   {
  #     cidr_block                 = "0.0.0.0/0"
  #     gateway_id                 = aws_internet_gateway.igw.id
  #     nat_gateway_id             = ""
  #     carrier_gateway_id         = ""
  #     destination_prefix_list_id = ""
  #     egress_only_gateway_id     = ""
  #     instance_id                = ""
  #     ipv6_cidr_block            = ""
  #     local_gateway_id           = ""
  #     network_interface_id       = ""
  #     transit_gateway_id         = ""
  #     vpc_endpoint_id            = ""
  #     vpc_peering_connection_id  = ""
  #     # core_network_arn           = ""

  #   },
  # ]

  tags = {
    Name = "public"
  }
}


resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public.id
}

