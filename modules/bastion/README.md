<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.bastion_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_iam_instance_profile.bastion_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.bastion_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.bastion_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bastion_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.bastion_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.bastion_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | Bastion EC2 configuration | <pre>object({<br>    instance_type    = string<br>    volume_type      = string<br>    volume_size      = number<br>    private_ip       = string<br>    source_cidr      = string<br>    public_key_path  = string<br>    private_key_path = string<br>  })</pre> | n/a | yes |
| <a name="input_eks_arn"></a> [eks\_arn](#input\_eks\_arn) | EKS cluster ARN | `string` | n/a | yes |
| <a name="input_eks_name"></a> [eks\_name](#input\_eks\_name) | EKS cluster Name | `string` | n/a | yes |
| <a name="input_image_ami_id"></a> [image\_ami\_id](#input\_image\_ami\_id) | EC2 image AMI ID | `string` | n/a | yes |
| <a name="input_module_name"></a> [module\_name](#input\_module\_name) | Name of the module | `string` | `"Bastion"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_public_subnet_id"></a> [public\_subnet\_id](#input\_public\_subnet\_id) | Subnet where bastion will run | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the project will run | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster will be launched | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->