# public subnets
resource "aws_subnet" "public" {
  count                   = var.public_sb_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index) //https://ntwobike.medium.com/how-cidrsubnet-works-in-terraform-f6ccd8e1838f
  availability_zone       = element(var.az.*, count.index)
  map_public_ip_on_launch = true

  tags = merge(var.gen_tags,
    {
      Name = "public_sb${count.index}"
    }
  )
}

# private subnets
resource "aws_subnet" "private" {
  count             = var.private_sb_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, (count.index + length(aws_subnet.public.*)))
  availability_zone = element(var.az.*, count.index)

  tags = merge(var.gen_tags,
    {
      Name = "private_sb${count.index}"
    }
  )
}