variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the cluster will be launched"
  nullable    = false
}

variable "region" {
  type        = string
  description = "Region where the project will run"
  nullable    = false
}

variable "bastion_public_ip" {
  type        = string
  description = "Bastion public IP"
  nullable    = false
}

variable "bastion_private_key_path" {
  type = string
  description = "Bastion private key"
  nullable    = false
}

variable "eks_name" {
  type        = string
  description = "EKS cluster name"
  nullable    = false
}

variable "eks_endpoint" {
  type        = string
  description = "Cluster EKS endpoint"
  nullable    = false
}

variable "karpenter_federated_role_arn" {
  type        = string
  description = "Role to provision new Nodes for the eks cluster"
  nullable    = false
}

variable "karpenter_instance_profile_name" {
  type        = string
  description = "Instance profile used by the karpenter provisioned instances"
  nullable    = false
}
