terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.58.0"
    }
  }
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = ""

  default_tags {
    tags = var.default_tags
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-noble-24.04-amd64-server-20240701.1*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "network" {
  source                 = "./modules/network"
  project_name           = var.project_name
  net_cidr               = var.net_cidr
  eks_name               = var.eks.name
  eks_control_plane_cidr = var.eks.control_plane_cidr
}

module "eks" {
  source                   = "./modules/eks"
  project_name             = var.project_name
  vpc_id                   = module.network.vpc_id
  region                   = var.region
  private_eks_subnet_cidr  = var.net_cidr.eks_subnet
  private_eks_subnet_ids   = module.network.private_eks_subnet[*].id
  public_eks_subnet_ids    = module.network.public_subnet[*].id
  bastion_private_ip       = var.bastion_config.private_ip
  eks                      = var.eks
  eks_addons_version       = var.eks_addons_version
  eks_node_group           = var.eks_node_group

  depends_on = [
    module.network
  ]
}

module "bastion" {
  source           = "./modules/bastion"
  project_name     = var.project_name
  region           = var.region
  vpc_id           = module.network.vpc_id
  image_ami_id     = data.aws_ami.ubuntu.id
  public_subnet_id = module.network.public_subnet[0].id
  bastion_config   = var.bastion_config
  eks_name         = var.eks.name
  eks_arn          = module.eks.eks_arn

  depends_on = [
    module.network,
    module.eks
  ]
}

module "ansible" {
  source                          = "./modules/ansible"
  bastion_public_ip               = module.bastion.public_ip
  bastion_private_key_path        = var.bastion_config.private_key_path
  region                          = var.region
  vpc_id                          = module.network.vpc_id
  eks_name                        = var.eks.name
  eks_endpoint                    = module.eks.eks_endpoint
  karpenter_instance_profile_name = module.eks.karpenter_instance_profile_name
  karpenter_federated_role_arn    = module.eks.karpenter_federated_role_arn

  depends_on = [
    module.network,
    module.eks,
    module.bastion
  ]
}