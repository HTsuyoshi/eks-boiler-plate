variable "project_name" {
  type        = string
  description = "Name of the project"
  nullable    = false
}

variable "module_name" {
  type        = string
  description = "Name of the module"
  nullable    = false

  default = "Bastion"
}

variable "region" {
  type        = string
  description = "Region where the project will run"
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the cluster will be launched"
  nullable    = false
}

variable "image_ami_id" {
  type        = string
  description = "EC2 image AMI ID"
  nullable    = false
}

variable "public_subnet_id" {
  type        = string
  description = "Subnet where bastion will run"
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
  description = "Bastion EC2 configuration"
  nullable    = false
}

variable "eks_name" {
  type        = string
  description = "EKS cluster Name"
  nullable    = false
}

variable "eks_arn" {
  type        = string
  description = "EKS cluster ARN"
  nullable    = false
}
