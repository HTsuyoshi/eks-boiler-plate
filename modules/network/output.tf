output "vpc_id" {
  value = aws_vpc.vpc_eks.id
}

output "private_eks_subnet" {
  value = aws_subnet.private_eks_subnet
}

output "public_subnet" {
  value = aws_subnet.public_subnet
}