terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.2.1"
    }
  }
}

# Create Template Stack for CloudNGFW
resource "terracurl_request" "cloud-tpl-stack" {
  name   = "cngfw-aws-${var.template_stack_name}"
  url    = "https://${var.hostname}/api?type=op"
  method = "POST"
  request_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <create-cngfw-template-stack>
            <name>${var.template_stack_name}</name>
          </create-cngfw-template-stack>
        </aws>
      </plugins>
    </request>
    EOF
  }

  headers = {
    X-PAN-KEY = var.api_key
  }

  response_codes = [
    200
  ]

  skip_tls_verify = var.skip_tls_verify


  destroy_url    = "https://${var.hostname}/api?type=config"
  destroy_method = "DELETE"

  destroy_headers = {
    X-PAN-KEY = var.api_key
  }

  destroy_response_codes = [
    200
  ]

  destroy_parameters = {
    action = "delete"
    xpath  = "/config/devices/entry[@name='localhost.localdomain']/template-stack/entry[@name='cngfw-aws-${var.template_stack_name}']"
  }

  destroy_skip_tls_verify = var.skip_tls_verify

}

# Create Device Group for CloudNGFW
resource "terracurl_request" "cloud-dg" {
  name   = "cngfw-aws-${var.device_group_name}"
  url    = "https://${var.hostname}/api?type=op"
  method = "POST"
  request_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <create-cngfw-device-groups>
            <name>${var.device_group_name}</name>
            <template-stack-name>${var.template_stack_name}</template-stack-name>
          </create-cngfw-device-groups>
        </aws>
      </plugins>
    </request>
    EOF
  }

  headers = {
    X-PAN-KEY = var.api_key
  }

  response_codes = [
    200
  ]

  skip_tls_verify = var.skip_tls_verify


  destroy_url    = "https://${var.hostname}/api?type=config"
  destroy_method = "DELETE"

  destroy_headers = {
    X-PAN-KEY = var.api_key
  }

  destroy_response_codes = [
    200
  ]

  destroy_parameters = {
    action = "delete"
    xpath  = "/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='cngfw-aws-${var.device_group_name}']"
  }

  destroy_skip_tls_verify = var.skip_tls_verify

}

# Associate CloudNGFW Device Group with tenant
resource "terracurl_request" "assoc-cloud-dg-tenant" {
  name   = "cloud-dg-tenant-association-${var.device_group_name}-${var.template_stack_name}"
  url    = "https://${var.hostname}/api?type=op"
  method = "POST"
  request_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <tenant-dg-mapping>
            <add>
              <tenant-name>${var.tenant_serial_number}</tenant-name>
              <region>${var.region}</region>
              <tenant-id>${var.tenant_name}</tenant-id>
              <device-group>cngfw-aws-${var.device_group_name}</device-group>
              <cert-arn-mapping>
                <member>/</member>
              </cert-arn-mapping>
            </add>
          </tenant-dg-mapping>
        </aws>
      </plugins>
    </request>
    EOF
  }

  headers = {
    X-PAN-KEY = var.api_key
  }

  response_codes = [
    200
  ]

  skip_tls_verify = var.skip_tls_verify

  destroy_url    = "https://${var.hostname}/api?type=op"
  destroy_method = "POST"

  destroy_headers = {
    X-PAN-KEY = var.api_key
  }

  destroy_response_codes = [
    200
  ]

  destroy_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <tenant-dg-mapping>
            <remove>
              <tenant-name>${var.tenant_serial_number}</tenant-name>
              <cloud-provider>AWS</cloud-provider>
              <tenant-id>${var.tenant_name}</tenant-id>
              <region>${var.region}</region>
              <device-groups>
                <member>cngfw-aws-${var.device_group_name}</member>
              </device-groups>
            </remove>
          </tenant-dg-mapping>
        </aws>
      </plugins>
    </request>
    EOF
  }

  destroy_skip_tls_verify = var.skip_tls_verify
  destroy_timeout         = 30

  depends_on = [
    terracurl_request.cloud-dg,
    terracurl_request.cloud-tpl-stack
  ]
}

# Associate CloudNGFW Device Group with CloudNGFW resource
resource "terracurl_request" "assoc-cloud-dg-cngfw" {
  name   = "cloud-dg-cngfw-association-${var.device_group_name}-${var.template_stack_name}"
  url    = "https://${var.hostname}/api?type=op"
  method = "POST"
  request_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <resource-dg-mapping>
            <add>
              <resource-ids>
                <member>${var.cngfw_id}:${var.aws_account_id}</member>
              </resource-ids>
              <region>${var.region}</region>
              <cloud-provider>AWS</cloud-provider>
              <template-name>n/a</template-name>
              <tenant-id>${var.tenant_name}</tenant-id>
              <tenant-name>${var.tenant_serial_number}</tenant-name>
              <device-group>${terracurl_request.cloud-dg.name}</device-group>
              <resource-names>
                <member>${var.cngfw_name}</member>
              </resource-names>
            </add>
          </resource-dg-mapping>
        </aws>
      </plugins>
    </request>
    EOF
  }

  headers = {
    X-PAN-KEY = var.api_key
  }

  response_codes = [
    200
  ]

  skip_tls_verify = var.skip_tls_verify

  destroy_url    = "https://${var.hostname}/api?type=op"
  destroy_method = "POST"

  destroy_headers = {
    X-PAN-KEY = var.api_key
  }

  destroy_response_codes = [
    200
  ]

  destroy_parameters = {
    cmd = <<EOF
    <request>
      <plugins>
        <aws>
          <resource-dg-mapping>
            <remove>
              <resource-ids>
                <member>${var.cngfw_id}:${var.aws_account_id}</member>
              </resource-ids>
              <region>${var.region}</region>
              <cloud-provider>AWS</cloud-provider>
              <template-name>1</template-name>
              <tenant-id>${var.tenant_name}</tenant-id>
              <tenant-name>${var.tenant_serial_number}</tenant-name>
              <device-group>None</device-group>
              <resource-names>
                <member>${var.cngfw_name}</member>
              </resource-names>
            </remove>
          </resource-dg-mapping>
        </aws>
      </plugins>
    </request>
    EOF
  }

  destroy_skip_tls_verify = var.skip_tls_verify
  destroy_timeout         = 120

  depends_on = [
    terracurl_request.cloud-dg,
    terracurl_request.cloud-tpl-stack,
    terracurl_request.assoc-cloud-dg-tenant
  ]
}

resource "terraform_data" "commit" {
  triggers_replace = [
    terracurl_request.cloud-dg.name,
    terracurl_request.cloud-tpl-stack.name,
    terracurl_request.assoc-cloud-dg-tenant.name,
    terracurl_request.assoc-cloud-dg-cngfw.name
  ]

  provisioner "local-exec" {
    command     = "go run commit.go -devicegroup ${terracurl_request.cloud-dg.name} '${var.commit_message}'"
    working_dir = "${path.module}/scripts"

    environment = {
      PANOS_HOSTNAME = var.hostname
      PANOS_API_KEY  = var.api_key
    }
  }

}
