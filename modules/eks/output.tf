output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_arn" {
  value = aws_eks_cluster.eks.arn
}

output "karpenter_instance_profile_name" {
  value = aws_iam_instance_profile.karpenter_instance_profile.name
}

output "karpenter_federated_role_arn" {
  value = aws_iam_role.karpenter_federated_role.arn
}
