variable "project_name" {
  type        = string
  description = "Name of the project"
  nullable    = false
}

variable "module_name" {
  type        = string
  description = "Name of the module"
  nullable    = false

  default = "Elastic Kubernetes Service"
}

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

variable "private_eks_subnet_cidr" {
  type        = list(string)
  description = "List of EKS private subnets CIDR"
  nullable    = false
}

variable "private_eks_subnet_ids" {
  type        = list(string)
  description = "List of EKS private subnets ids"
  nullable    = false
}

variable "public_eks_subnet_ids" {
  type        = list(string)
  description = "List of EKS public subnets ids"
  nullable    = false
}

variable "bastion_private_ip" {
  description = "Bastion private IP"
  type        = string
  nullable    = false
}

variable "eks" {
  type = object({
    name                = string
    version             = string
    private_endpoint    = bool
    public_endpoint     = bool
    public_access_cidrs = list(string)
    control_plane_cidr  = string
  })
  description = "EKS configuration"
  nullable    = false
}

variable "eks_addons_version" {
  type        = map(string)
  description = "EKS addons version"
  nullable    = false
}

variable "eks_node_group" {
  type = object({
    name            = string
    disk_size       = number
    capacity_type   = string
    instance_types  = list(string)
    desired_size    = number
    max_size        = number
    min_size        = number
    max_unavailable = number
  })
  description = "EKS node group configuration"
  nullable    = false
}
