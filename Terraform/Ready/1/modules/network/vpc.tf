resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true #gives an internal domain name
  enable_dns_hostnames = true #gives an internal host name

  instance_tenancy = "default"
  tags = merge(var.gen_tags,
    {
      Name = var.vpc_name
    }
  )
}

# Enables vpc to connect to the internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.gen_tags,
    {
      Name = "main_gw"
    }
  )
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  # Default route through Internet Gateway
  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.gen_tags,
    {
      Name = "main_rt"
    }
  )
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.main.id
}

# Attach subnets to an internet gateway
resource "aws_route_table_association" "a" {
  count          = length(aws_subnet.public.*)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.main.id
}
