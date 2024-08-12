# Karpenter with EKS boilerplate

Karpenter is running in the default 3 nodes of EKS ASG

![Karpenter architecture](./karpenter.png)

The infrastructure is created by terraform and the cluster configuration with anible.

## Deploy

Setup provider.aws in `main.tf`

Change `bastion_config.source_cidr` to your IP in `development.tfvars`

Create your own ssh key with `ssh-keygen` and set `bastion_config.public_key_path` and `bastion_config.private_key_path` in `development.tfvars`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.58.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ansible"></a> [ansible](#module\_ansible) | ./modules/ansible | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | bastion EC2 configuration | <pre>object({<br>    instance_type    = string<br>    volume_type      = string<br>    volume_size      = number<br>    private_ip       = string<br>    source_cidr      = string<br>    public_key_path  = string<br>    private_key_path = string<br>  })</pre> | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | AWS Tags to add to all resources created | `map(any)` | <pre>{<br>  "Application": "EKS Karpenter Boiler plate",<br>  "Environment": "",<br>  "Name": "",<br>  "Owner": "",<br>  "Terraform": "true",<br>  "Type": ""<br>}</pre> | no |
| <a name="input_eks"></a> [eks](#input\_eks) | EKS configuration | <pre>object({<br>    name                = string<br>    version             = string<br>    private_endpoint    = bool<br>    public_endpoint     = bool<br>    public_access_cidrs = list(string)<br>    control_plane_cidr  = string<br>  })</pre> | n/a | yes |
| <a name="input_eks_addons_version"></a> [eks\_addons\_version](#input\_eks\_addons\_version) | EKS addons | `map(string)` | n/a | yes |
| <a name="input_eks_node_group"></a> [eks\_node\_group](#input\_eks\_node\_group) | EKS node group configuration | <pre>object({<br>    name            = string<br>    disk_size       = number<br>    capacity_type   = string<br>    instance_types  = list(string)<br>    desired_size    = number<br>    max_size        = number<br>    min_size        = number<br>    max_unavailable = number<br>  })</pre> | n/a | yes |
| <a name="input_net_cidr"></a> [net\_cidr](#input\_net\_cidr) | CIDR used in the project | <pre>object({<br>    vpc              = string,<br>    eks_subnet       = list(string),<br>    pub_subnet       = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the project will initialize | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | n/a |
<!-- END_TF_DOCS -->
