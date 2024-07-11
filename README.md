# Panorama Cloud Device Group Onboarding Terraform Module for Cloud NGFW

This is a helper module that can be used when onboarding Cloud NGFWs to Panorama Cloud Device Groups.

This module uses the [terracurl](https://github.com/michaelcontento/terraform-provider-terracurl) provider to make API calls to Panorama and configures the following items.

- Cloud Device Group
- Cloud Template Stack
- Cloud Device Group to Tenant association
- Cloud Device Group to Cloud NGFW association

Once the onboarding process is completed you may want to use the [panos](https://registry.terraform.io/providers/PaloAltoNetworks/panos/latest) provider to configure the firewalls.

## Prerequisites

- Install required plugins on the Panorama device (see [prepare for Panorama integration](https://docs.paloaltonetworks.com/cloud-ngfw/aws/cloud-ngfw-on-aws/panorama-integration-overview/cloud-ngfw-aws-panorama-integration/prepare-for-panorama-integration))
- Link the Cloud NGFW tenant to Panorama (see [Link the Cloud NGFW to Palo Alto Networks Management](https://docs.paloaltonetworks.com/cloud-ngfw/aws/cloud-ngfw-on-aws/panorama-integration-overview/cloud-ngfw-aws-panorama-integration/link-cngfw-to-panorama))

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terracurl"></a> [terracurl](#provider\_terracurl) | 1.2.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terracurl_request.assoc-cloud-dg-cngfw](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terracurl_request.assoc-cloud-dg-tenant](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terracurl_request.cloud-dg](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terracurl_request.cloud-tpl-stack](https://registry.terraform.io/providers/devops-rob/terracurl/1.2.1/docs/resources/request) | resource |
| [terraform_data.commit](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for the Panorama instance<br>    More info - https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-panorama-api/get-started-with-the-pan-os-xml-api/get-your-api-key#idca192ed7-45df-4992-a0f7-41ebe94fbdac | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID of the CloudNGFW resource | `string` | n/a | yes |
| <a name="input_cngfw_id"></a> [cngfw\_id](#input\_cngfw\_id) | ID of the CloudNGFW resource | `string` | n/a | yes |
| <a name="input_cngfw_name"></a> [cngfw\_name](#input\_cngfw\_name) | Name of the CloudNGFW resource | `string` | n/a | yes |
| <a name="input_device_group_name"></a> [device\_group\_name](#input\_device\_group\_name) | Device Group name for the CloudNGFW. This name will be prefixed with 'cngfw-aws-' | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname of the Panorama instance | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region of the CloudNGFW resource | `string` | n/a | yes |
| <a name="input_skip_tls_verify"></a> [skip\_tls\_verify](#input\_skip\_tls\_verify) | Skip TLS verification for the Panorama instance | `bool` | `true` | no |
| <a name="input_template_stack_name"></a> [template\_stack\_name](#input\_template\_stack\_name) | Template stack name for the CloudNGFW. This name will be prefixed with 'cngfw-aws-' | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Name of the CloudNGFW tenant | `string` | n/a | yes |
| <a name="input_tenant_serial_number"></a> [tenant\_serial\_number](#input\_tenant\_serial\_number) | Serial number of the CloudNGFW tenant | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_device_group"></a> [device\_group](#output\_device\_group) | The device group name to be used when configuring firewalls (cngfw-aws prepended to the value of var.device\_group\_name) |
| <a name="output_template_stack"></a> [template\_stack](#output\_template\_stack) | The template stack name to be used when configuring firewalls (cngfw-aws prepended to the value of var.template\_stack\_name) |
<!-- END_TF_DOCS -->