resource "aws_iam_policy" "AWSKarpenterControllerPolicy" {
  name        = "KarpenterControllerPolicy"
  path        = "/"
  description = "Allow karpenter provision nodes"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowScopedEC2InstanceAccessActions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:RunInstances",
          "ec2:CreateFleet"
        ],
        "Resource" : [
          "arn:aws:ec2:${var.region}::image/*",
          "arn:aws:ec2:${var.region}::snapshot/*",
          "arn:aws:ec2:${var.region}:*:security-group/*",
          "arn:aws:ec2:${var.region}:*:subnet/*"
        ]
      },
      {
        "Sid" : "AllowScopedEC2LaunchTemplateAccessActions",
        "Effect" : "Allow",
        "Resource" : "arn:aws:ec2:${var.region}:*:launch-template/*",
        "Action" : [
          "ec2:RunInstances",
          "ec2:CreateFleet"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned"
          },
          "StringLike" : {
            "aws:ResourceTag/karpenter.sh/nodepool" : "*"
          }
        }
      },
      {
        "Sid" : "AllowScopedEC2InstanceActionsWithTags",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ec2:${var.region}:*:fleet/*",
          "arn:aws:ec2:${var.region}:*:instance/*",
          "arn:aws:ec2:${var.region}:*:volume/*",
          "arn:aws:ec2:${var.region}:*:network-interface/*",
          "arn:aws:ec2:${var.region}:*:launch-template/*",
          "arn:aws:ec2:${var.region}:*:spot-instances-request/*"
        ],
        "Action" : [
          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned"
          },
          "StringLike" : {
            "aws:RequestTag/karpenter.sh/nodepool" : "*"
          }
        }
      },
      {
        "Sid" : "AllowScopedResourceCreationTagging",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ec2:${var.region}:*:fleet/*",
          "arn:aws:ec2:${var.region}:*:instance/*",
          "arn:aws:ec2:${var.region}:*:volume/*",
          "arn:aws:ec2:${var.region}:*:network-interface/*",
          "arn:aws:ec2:${var.region}:*:launch-template/*",
          "arn:aws:ec2:${var.region}:*:spot-instances-request/*"
        ],
        "Action" : "ec2:CreateTags",
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned",
            "ec2:CreateAction" : [
              "RunInstances",
              "CreateFleet",
              "CreateLaunchTemplate"
            ]
          },
          "StringLike" : {
            "aws:RequestTag/karpenter.sh/nodepool" : "*"
          }
        }
      },
      {
        "Sid" : "AllowScopedResourceTagging",
        "Effect" : "Allow",
        "Resource" : "arn:aws:ec2:${var.region}:*:instance/*",
        "Action" : "ec2:CreateTags",
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned"
          },
          "StringLike" : {
            "aws:ResourceTag/karpenter.sh/nodepool" : "*"
          },
          "ForAllValues:StringEquals" : {
            "aws:TagKeys" : [
              "karpenter.sh/nodeclaim",
              "Name"
            ]
          }
        }
      },
      {
        "Sid" : "AllowScopedDeletion",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ec2:${var.region}:*:instance/*",
          "arn:aws:ec2:${var.region}:*:launch-template/*"
        ],
        "Action" : [
          "ec2:TerminateInstances",
          "ec2:DeleteLaunchTemplate"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned"
          },
          "StringLike" : {
            "aws:ResourceTag/karpenter.sh/nodepool" : "*"
          }
        }
      },
      {
        "Sid" : "AllowRegionalReadActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSpotPriceHistory",
          "ec2:DescribeSubnets"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestedRegion" : "${var.region}"
          }
        }
      },
      {
        "Sid" : "AllowSSMReadActions",
        "Effect" : "Allow",
        "Resource" : "arn:aws:ssm:${var.region}::parameter/aws/service/*",
        "Action" : "ssm:GetParameter"
      },
      {
        "Sid" : "AllowPricingReadActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : "pricing:GetProducts"
      },
      {
        "Sid" : "AllowInterruptionQueueActions",
        "Effect" : "Allow",
        "Resource" : "${aws_sqs_queue.karpenter_interruption_queue.arn}",
        "Action" : [
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage"
        ]
      },
      {
        "Sid" : "AllowPassingInstanceRole",
        "Effect" : "Allow",
        "Resource" : "${aws_iam_role.karpenter_node_role.arn}",
        "Action" : "iam:PassRole",
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : "ec2.amazonaws.com"
          }
        }
      },
      {
        "Sid" : "AllowScopedInstanceProfileCreationActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "iam:CreateInstanceProfile"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned",
            "aws:RequestTag/topology.kubernetes.io/region" : "${var.region}"
          },
          "StringLike" : {
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" : "*"
          }
        }
      },
      {
        "Sid" : "AllowScopedInstanceProfileTagActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "iam:TagInstanceProfile"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned",
            "aws:ResourceTag/topology.kubernetes.io/region" : "${var.region}",
            "aws:RequestTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned",
            "aws:RequestTag/topology.kubernetes.io/region" : "${var.region}"
          },
          "StringLike" : {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" : "*",
            "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" : "*"
          }
        }
      },
      {
        "Sid" : "AllowScopedInstanceProfileActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:DeleteInstanceProfile"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.eks.name}" : "owned",
            "aws:ResourceTag/topology.kubernetes.io/region" : "${var.region}"
          },
          "StringLike" : {
            "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" : "*"
          }
        }
      },
      {
        "Sid" : "AllowInstanceProfileReadActions",
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : "iam:GetInstanceProfile"
      },
      {
        "Sid" : "AllowAPIServerEndpointDiscovery",
        "Effect" : "Allow",
        "Resource" : "${aws_eks_cluster.eks.arn}",
        "Action" : "eks:DescribeCluster"
      }
    ]
  })

  tags = {
    Name = "EKS Cluster Karpenter node provisioning Policy - ${var.project_name}",
    Type = var.module_name
  }
}
