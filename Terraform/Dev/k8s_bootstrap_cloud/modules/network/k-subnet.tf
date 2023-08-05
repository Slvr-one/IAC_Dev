# Subnet (public):
resource "aws_subnet" "k8s" {
  vpc_id            = aws_vpc.k8s.id
  cidr_block        = var.vpc_cidr
  availability_zone = var.zone

  tags = merge(var.tags,
    {
      Name = "kubernetes"
    }
  )
}