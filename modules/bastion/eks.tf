resource "aws_eks_access_entry" "bastion_access" {
  cluster_name  = var.eks_name
  principal_arn = aws_iam_role.bastion_role.arn
  type = "STANDARD"

  tags = {
    Name = "EKS Access Entry - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_eks_access_policy_association" "policy" {
  cluster_name  = var.eks_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_iam_role.bastion_role.arn

  access_scope {
    type = "cluster"
  }
}