resource "aws_iam_role" "bastion_role" {
  name = "CustomerServiceRoleForBastion"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "Bastion Role - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_iam_policy" "bastion_policy" {
  name = "BastionPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ],
        Resource = var.eks_arn
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateTags",
        ],
        Resource = "*"
      },
    ]
  })

  tags = {
    Name = "Bastion EKS Policy - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_iam_role_policy_attachment" "bastion_policy_attachment" {
  policy_arn = aws_iam_policy.bastion_policy.arn
  role       = aws_iam_role.bastion_role.name
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "BastionInstanceProfile"
  role = aws_iam_role.bastion_role.name

  tags = {
    Name = "Bastion Instance Profile - ${var.project_name}",
    Type = var.module_name
  }
}
