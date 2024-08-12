resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "Internet Gateway - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.net_cidr.pub_subnet)

  tags = {
    Name = "Elastic IP NAT Gateway - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.net_cidr.pub_subnet)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "NAT Gateway - ${var.project_name}",
    Type = var.module_name
  }
}
