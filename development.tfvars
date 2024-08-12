region       = "us-east-2"
project_name = "EKS Karpenter Boilerplate"

net_cidr = {
  vpc = "192.168.0.0/16",
  eks_subnet = [
    "192.168.0.0/18",
    "192.168.64.0/18",
  ],
  pub_subnet = [
    "192.168.128.0/24",
    "192.168.129.0/24",
  ]
}

eks = {
  name                = "eks-karpenter"
  version             = "1.30"
  private_endpoint    = true
  public_endpoint     = false
  public_access_cidrs = ["0.0.0.0/32"]
  control_plane_cidr  = "10.100.0.0/16"
}

eks_addons_version = {
  "kube-proxy"         = "v1.29.0-eksbuild.1",
  "vpc-cni"            = "v1.16.0-eksbuild.1",
  "coredns"            = "v1.11.1-eksbuild.9",
  "aws-ebs-csi-driver" = "v1.32.0-eksbuild.1"
}

eks_node_group = {
  name            = "eks_node_group"
  disk_size       = 20
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3.medium"]
  desired_size    = 3
  max_size        = 3
  min_size        = 3
  max_unavailable = 1
}

bastion_config = {
  instance_type    = "t3.micro"
  volume_type      = "standard"
  volume_size      = 8
  private_ip       = "192.168.130.130"
  source_cidr      = "0.0.0.0/32"
  public_key_path  = ""
  private_key_path = ""
}
