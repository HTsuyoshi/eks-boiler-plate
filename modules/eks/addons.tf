resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.eks.id
  addon_name    = "vpc-cni"
  addon_version = var.eks_addons_version["vpc-cni"]

  depends_on = [
    aws_eks_node_group.private_node_group
  ]

  tags = {
    Name = "EKS VPC CNI Addon - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.eks.id
  addon_name    = "kube-proxy"
  addon_version = var.eks_addons_version["kube-proxy"]

  depends_on = [
    aws_eks_node_group.private_node_group
  ]

  tags = {
    Name = "EKS Kube Proxy Addon - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.eks.id
  addon_name    = "coredns"
  addon_version = var.eks_addons_version["coredns"]

  depends_on = [
    aws_eks_node_group.private_node_group
  ]

  tags = {
    Name = "EKS CoreDNS Addon - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.eks.id
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.eks_addons_version["aws-ebs-csi-driver"]
  service_account_role_arn = aws_iam_role.ebs_csi_federated_role.arn

  depends_on = [
    aws_eks_node_group.private_node_group
  ]

  tags = {
    Name = "EKS EBS CSI Addon - ${var.project_name}",
    Type = var.module_name
  }
}
