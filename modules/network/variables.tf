variable "project_name" {
  type        = string
  description = "Name of the project"
  nullable    = false
}

variable "module_name" {
  type        = string
  description = "Name of the module"
  nullable    = false

  default = "Networking"
}

variable "net_cidr" {
  type = object({
    vpc        = string,
    eks_subnet = list(string),
    pub_subnet = list(string),
  })
  description = "CIDRs used in the project"
  nullable    = false
}

variable "eks_name" {
  type        = string
  description = "EKS cluster name"
  nullable    = false
}

variable "eks_control_plane_cidr" {
  type        = string
  description = "EKS Control Plane CIDR"
  nullable    = false
}