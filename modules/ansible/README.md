<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.setup_ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_private_key_path"></a> [bastion\_private\_key\_path](#input\_bastion\_private\_key\_path) | Bastion private key | `string` | n/a | yes |
| <a name="input_bastion_public_ip"></a> [bastion\_public\_ip](#input\_bastion\_public\_ip) | Bastion public IP | `string` | n/a | yes |
| <a name="input_eks_endpoint"></a> [eks\_endpoint](#input\_eks\_endpoint) | Cluster EKS endpoint | `string` | n/a | yes |
| <a name="input_eks_name"></a> [eks\_name](#input\_eks\_name) | EKS cluster name | `string` | n/a | yes |
| <a name="input_karpenter_federated_role_arn"></a> [karpenter\_federated\_role\_arn](#input\_karpenter\_federated\_role\_arn) | Role to provision new Nodes for the eks cluster | `string` | n/a | yes |
| <a name="input_karpenter_instance_profile_name"></a> [karpenter\_instance\_profile\_name](#input\_karpenter\_instance\_profile\_name) | Instance profile used by the karpenter provisioned instances | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where the project will run | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster will be launched | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->