resource "aws_iam_role" "eks_cluster_role" {
  name               = "CustomerServiceRoleForEKSCluster"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  tags = {
    Name = "EKS Cluster Role - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_group_role" {
  name               = "CustomerServiceRoleForEKSNodeGroup"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role.json

  tags = {
    Name = "EKS Node Group Role - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role" "karpenter_node_role" {
  name               = "CustomerServiceRoleForKarpenterNode"
  assume_role_policy = data.aws_iam_policy_document.eks_node_group_assume_role.json

  tags = {
    Name = "Karpenter Node Role - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_iam_role_policy_attachment" "KarpenterAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "KarpenterAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "KarpenterAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_role_policy_attachment" "KarpenterAmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.karpenter_node_role.name
}

resource "aws_iam_instance_profile" "karpenter_instance_profile" {
  name = "KarpenterNodeInstanceProfile"
  role = aws_iam_role.karpenter_node_role.name
}

resource "aws_eks_access_entry" "karpenter_access_entry" {
  cluster_name  = aws_eks_cluster.eks.name
  principal_arn = aws_iam_role.karpenter_node_role.arn
  type          = "EC2_LINUX"
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}