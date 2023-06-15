
#subnets--
resource "aws_subnet" "private-1a" {
  # count = length(data.aws_availbility_zones.available)
  # cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  # availability_zone = element(var.availability_zones, count.index)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/19" //8000 ips
  availability_zone       = "${var.region}a"

  tags = {
    "Name"                            = "private-1a"
    "kubernetes.io/role/internal-elb" = 1
    # "kubernetes.io/cluster/victor"    = "owned"
    "kubernetes.io/cluster/${var.eks_cluster.name}" = "shared"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.32.0/19"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                            = "private-1b"
    "kubernetes.io/role/internal-elb" = 1
    # "kubernetes.io/cluster/victor"    = "owned"
    "kubernetes.io/cluster/${var.eks_cluster.name}" = "shared"
  }
}

resource "aws_subnet" "public-1a" {
  # count = length(data.aws_availbility_zones.available)
  # cidr_block = element(var.private_subnet_cidr_blocks, count.index)
  # availability_zone = element(var.availability_zones, count.index)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                         = "public-1a"
    "kubernetes.io/role/elb"       = 1 //create an elb in this subnet
    # "kubernetes.io/cluster/victor" = "owned"
    "kubernetes.io/cluster/${var.eks_cluster.name}" = "shared"

  }
}

resource "aws_subnet" "public-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                         = "public-1b"
    "kubernetes.io/role/elb"       = 1
    # "kubernetes.io/cluster/victor" = "owned"
    "kubernetes.io/cluster/${var.eks_cluster.name}" = "shared"

  }
}

#elastic IP--
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "nat"
  }
}

#nat--
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  # subnet_id     = aws_subnet.public_subnet[0].id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}


#rt routes--
# Route the public subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main"
  }
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   # route = [
#   #   {
#   #     cidr_block                 = "0.0.0.0/0"
#   #     gateway_id                 = aws_internet_gateway.igw.id
#   #     nat_gateway_id             = ""
#   #     carrier_gateway_id         = ""
#   #     destination_prefix_list_id = ""
#   #     egress_only_gateway_id     = ""
#   #     instance_id                = ""
#   #     ipv6_cidr_block            = ""
#   #     local_gateway_id           = ""
#   #     network_interface_id       = ""
#   #     transit_gateway_id         = ""
#   #     vpc_endpoint_id            = ""
#   #     vpc_peering_connection_id  = ""
#   #     # core_network_arn           = ""
#   #   },
#   # ]
#   tags = {
#     Name = "private"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0" #"10.0.1.0/24"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   # route = [
#   #   {
#   #     cidr_block                 = "0.0.0.0/0"
#   #     gateway_id                 = aws_internet_gateway.igw.id
#   #     nat_gateway_id             = ""
#   #     carrier_gateway_id         = ""
#   #     destination_prefix_list_id = ""
#   #     egress_only_gateway_id     = ""
#   #     instance_id                = ""
#   #     ipv6_cidr_block            = ""
#   #     local_gateway_id           = ""
#   #     network_interface_id       = ""
#   #     transit_gateway_id         = ""
#   #     vpc_endpoint_id            = ""
#   #     vpc_peering_connection_id  = ""
#   #     # core_network_arn           = ""

#   #   },
#   # ]
#   tags = {
#     Name = "public"
#   }
# }

# # Route table and subnet associations
# resource "aws_route_table_association" "internet_access" {
#   count = length(var.availability_zones)
#   subnet_id      = "${aws_subnet.public_subnet[count.index].id}"
#   route_table_id = aws_route_table.main.id
# }

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.main.id
}


# resource "aws_route_table_association" "private-1a" {
#   subnet_id      = aws_subnet.private-1a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private-1b" {
#   subnet_id      = aws_subnet.private-1b.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "public-1a" {
#   subnet_id      = aws_subnet.public-1a.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public-1b" {
#   subnet_id      = aws_subnet.public-1b.id
#   route_table_id = aws_route_table.public.id
# }

