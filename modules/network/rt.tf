resource "aws_route_table" "private_eks_rt" {
  count  = length(aws_subnet.private_eks_subnet)
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "Route Table ${count.index} EKS - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_route" "eks_nat" {
  count                  = length(aws_subnet.private_eks_subnet)
  route_table_id         = aws_route_table.private_eks_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway[count.index].id

  depends_on = [aws_route_table.private_eks_rt]
}

resource "aws_route_table_association" "private_eks_rt_assoc" {
  count          = length(aws_subnet.private_eks_subnet)
  subnet_id      = aws_subnet.private_eks_subnet[count.index].id
  route_table_id = aws_route_table.private_eks_rt[count.index].id
  depends_on = [
    aws_route_table.private_eks_rt,
    aws_subnet.private_eks_subnet
  ]
}

resource "aws_route_table" "public_nat_rt" {
  vpc_id = aws_vpc.vpc_eks.id

  tags = {
    Name = "Route Table Public - ${var.project_name}"
    Type = var.module_name
  }
}

resource "aws_route" "nat_igw" {
  route_table_id         = aws_route_table.public_nat_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  depends_on = [aws_route_table.private_eks_rt]
}

resource "aws_route_table_association" "public_assoc_nat" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_nat_rt.id
  depends_on = [
    aws_route_table.public_nat_rt,
    aws_subnet.public_subnet
  ]
}
