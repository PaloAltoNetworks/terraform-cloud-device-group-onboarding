output "device_group" {
  description = "The device group name to be used when configuring firewalls (cngfw-aws prepended to the value of var.device_group_name)"
  value       = terracurl_request.cloud-dg.name
}

output "template_stack" {
  description = "The template stack name to be used when configuring firewalls (cngfw-aws prepended to the value of var.template_stack_name)"
  value       = terracurl_request.cloud-tpl-stack.name
}
