variable "hostname" {
  description = "Hostname of the Panorama instance"
  type        = string
}

variable "api_key" {
  description = <<EOF
    API key for the Panorama instance
    More info - https://docs.paloaltonetworks.com/pan-os/10-1/pan-os-panorama-api/get-started-with-the-pan-os-xml-api/get-your-api-key#idca192ed7-45df-4992-a0f7-41ebe94fbdac
  EOF
  type        = string
}

variable "device_group_name" {
  description = "Device Group name for the CloudNGFW. This name will be prefixed with 'cngfw-aws-'"
  type        = string
}

variable "template_stack_name" {
  description = "Template stack name for the CloudNGFW. This name will be prefixed with 'cngfw-aws-'"
  type        = string
}

variable "skip_tls_verify" {
  description = "Skip TLS verification for the Panorama instance"
  type        = bool
  default     = true
}

variable "tenant_serial_number" {
  description = "Serial number of the CloudNGFW tenant"
  type        = string
}

variable "region" {
  description = "AWS region of the CloudNGFW resource"
  type        = string
}

variable "tenant_name" {
  description = "Name of the CloudNGFW tenant"
  type        = string
}

variable "cngfw_id" {
  description = "ID of the CloudNGFW resource"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID of the CloudNGFW resource"
  type        = string
}

variable "cngfw_name" {
  description = "Name of the CloudNGFW resource"
  type        = string
}

variable "commit_message" {
  description = "Description to use when commiting the configuration to Panorama"
  type        = string
  default     = "Commit via Go"
}
