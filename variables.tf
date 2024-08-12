variable "region" {
  type        = string
  description = "Region where the project will initialize"
  nullable    = false
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  nullable    = false
}

variable "net_cidr" {
  type = object({
    vpc              = string,
    eks_subnet       = list(string),
    pub_subnet       = list(string)
  })
  description = "CIDR used in the project"
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
  description = "EKS addons"
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

variable "bastion_config" {
  type = object({
    instance_type    = string
    volume_type      = string
    volume_size      = number
    private_ip       = string
    source_cidr      = string
    public_key_path  = string
    private_key_path = string
  })
  description = "bastion EC2 configuration"
  nullable    = false
}

variable "default_tags" {
  type        = map(any)
  description = "AWS Tags to add to all resources created"
  nullable    = false

  default = {
    Application = "EKS Karpenter Boiler plate",
    Terraform   = "true",
    Environment = "",
    Owner       = "",
    Name        = "",
    Type        = "",
  }
}
