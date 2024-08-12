resource "aws_security_group" "worker_node_access_sg" {
  name        = "worker_node_access"
  description = "Let Worker Nodes access EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_eks_subnet_cidr
    description = "Allow nodes and pods access EKS cluster API"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connection to all CIDRs"
  }

  tags = {
    Name = "EKS Cluster Worker Node Security Group - ${var.project_name}"
    Type = var.module_name
  }
}

resource "aws_security_group" "bastion_access_sg" {
  name        = "bastion_access"
  description = "Let bastion access EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_private_ip}/32"]
    description = "Allow bastion access EKS cluster API"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connection to all CIDRs"
  }

  tags = {
    Name = "EKS Cluster Bastion Security Group - ${var.project_name}"
    Type = var.module_name
  }
}

#resource "aws_security_group" "node_group_sg" {
#  for_each               = toset(aws_eks_cluster.eks.vpc_config[0].security_group_ids)
#  vpc_id                 = var.vpc_id
#  tags                   = {
#    "karpenter.sh/discovery" = "${var.eks.name}"
#  }
#}
#