resource "aws_eks_cluster" "eks" {
  name     = var.eks.name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks.version

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
  ]

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.eks.control_plane_cidr
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    endpoint_private_access = var.eks.private_endpoint
    endpoint_public_access  = var.eks.public_endpoint
    public_access_cidrs     = var.eks.public_access_cidrs
    subnet_ids              = concat(var.public_eks_subnet_ids, var.private_eks_subnet_ids)
    security_group_ids = [
      aws_security_group.worker_node_access_sg.id,
      aws_security_group.bastion_access_sg.id,
    ]
  }

  tags = {
    Name                                    = "EKS Cluster - ${var.project_name}",
    Type                                    = var.module_name,
    "kubernetes.io/cluster/${var.eks.name}" = "owned"
  }
}

resource "aws_eks_node_group" "private_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.eks_node_group.name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_eks_subnet_ids
  instance_types  = var.eks_node_group.instance_types
  capacity_type   = var.eks_node_group.capacity_type
  disk_size       = var.eks_node_group.disk_size

  taint {
    key    = "CriticalAddonsOnly"
    value  = "true"
    effect = "NO_SCHEDULE"
  }
  

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]

  update_config {
    max_unavailable = var.eks_node_group.max_unavailable
  }

  scaling_config {
    desired_size = var.eks_node_group.desired_size
    max_size     = var.eks_node_group.max_size
    min_size     = var.eks_node_group.min_size
  }

  tags = {
    Name = "EKS Node group - ${var.project_name}",
    Type = var.module_name
  }
}
