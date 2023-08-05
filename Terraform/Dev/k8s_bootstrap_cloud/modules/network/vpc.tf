# vpc:
resource "aws_vpc" "k8s" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(var.tags,
    {
      Name = var.vpc_name
    }
  )
}

# DHCP Options (not required, identical to Default Option):
resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(var.tags,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.k8s.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

# Routing:
resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.k8s.id

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags,
    {
      Name = "kubernetes"
    }
  )
}

resource "aws_route_table_association" "k8s" {
  subnet_id      = aws_subnet.k8s.id
  route_table_id = aws_route_table.k8s.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.k8s.id

  tags = merge(var.tags,
    {
      Name = "kubernetes"
    }
  )
}