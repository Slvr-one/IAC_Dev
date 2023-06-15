#costum vpc--
resource "aws_vpc" "main_ted" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name            = format("ted_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }
}

#igw--
resource "aws_internet_gateway" "dvir_igw" {
  vpc_id = aws_vpc.main_ted.id

  tags = var.tags
}

#rt--
resource "aws_route_table" "dvir_rt" {
  vpc_id = aws_vpc.main_ted.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dvir_igw.id
  }

  tags = var.tags
}

#public subnet--
resource "aws_subnet" "public_sn_ted" {
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main_ted.id

  cidr_block        = var.cidr_block[0]
  availability_zone = data.aws_availability_zones.AZ.names[0]


  tags = {
    Name            = format("ted_public_%s", var.env)
    Owner           = var.tags["Owner"]
    expiration_date = var.tags["expiration_date"]
    bootcamp        = var.tags["bootcamp"]
  }
}

#RT association--
resource "aws_main_route_table_association" "dvir_rta" {
  vpc_id         = aws_vpc.main_ted.id
  route_table_id = aws_route_table.dvir_rt.id
}

