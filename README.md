# opg-terrafrom-aws-firewalled-network
Standard OPG AWS Network Module: Managed by opg-org-infra &amp; Terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name                                                    | Version  |
|---------------------------------------------------------|----------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.5.0 |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.5.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                                                             | Type        |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_cloudwatch_log_group.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                            | resource    |
| [aws_default_network_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl)                               | resource    |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group)                            | resource    |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)                                                                   | resource    |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log)                                                        | resource    |
| [aws_iam_policy.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                 | resource    |
| [aws_iam_role.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                     | resource    |
| [aws_iam_role_policy_attachment.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                          | resource    |
| [aws_nat_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway)                                                    | resource    |
| [aws_route.application_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                           | resource    |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                           | resource    |
| [aws_route_table.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                           | resource    |
| [aws_route_table.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                  | resource    |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                | resource    |
| [aws_route_table_association.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                   | resource    |
| [aws_route_table_association.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                          | resource    |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                        | resource    |
| [aws_subnet.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                     | resource    |
| [aws_subnet.data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                            | resource    |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                          | resource    |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                  | resource    |
| [aws_vpc_dhcp_options.dns_resolver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options)                                | resource    |
| [aws_availability_zones.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)                                  | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                    | data source |
| [aws_default_tags.default_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags)                                     | data source |
| [aws_iam_policy_document.flow_log_cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)    | data source |
| [aws_iam_policy_document.vpc_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)            | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                      | data source |

## Inputs

| Name                                                                                                                                                                                          | Description                                              | Type                | Default                                    | Required |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|---------------------|--------------------------------------------|:--------:|
| <a name="input_cidr"></a> [cidr](#input\_cidr)                                                                                                                                                | n/a                                                      | `string`            | `"10.0.0.0/16"`                            |    no    |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress)                                                               | n/a                                                      | `list(map(string))` | `null`                                     |    no    |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress)                                                            | n/a                                                      | `list(map(string))` | `null`                                     |    no    |
| <a name="input_default_security_group_name"></a> [default\_security\_group\_name](#input\_default\_security\_group\_name)                                                                     | n/a                                                      | `string`            | `"default"`                                |    no    |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name)                                                                              | n/a                                                      | `string`            | `""`                                       |    no    |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers)                                                    | n/a                                                      | `list(string)`      | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> |    no    |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames)                                                                                            | n/a                                                      | `bool`              | `false`                                    |    no    |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support)                                                                                                  | n/a                                                      | `bool`              | `true`                                     |    no    |
| <a name="input_flow_log_cloudwatch_log_group_kms_key_id"></a> [flow\_log\_cloudwatch\_log\_group\_kms\_key\_id](#input\_flow\_log\_cloudwatch\_log\_group\_kms\_key\_id)                      | n/a                                                      | `string`            | `null`                                     |    no    |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | Number of days you want to retain log events.            | `number`            | `null`                                     |    no    |
| <a name="input_flow_log_log_format"></a> [flow\_log\_log\_format](#input\_flow\_log\_log\_format)                                                                                             | n/a                                                      | `string`            | `null`                                     |    no    |
| <a name="input_flow_log_traffic_type"></a> [flow\_log\_traffic\_type](#input\_flow\_log\_traffic\_type)                                                                                       | The type of traffic to log. Values: ACCEPT, REJECT, ALL. | `string`            | `"ALL"`                                    |    no    |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy)                                                                                                          | n/a                                                      | `string`            | `"default"`                                |    no    |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch)                                                                               | n/a                                                      | `bool`              | `false`                                    |    no    |
| <a name="input_public_subnet_assign_ipv6_address_on_creation"></a> [public\_subnet\_assign\_ipv6\_address\_on\_creation](#input\_public\_subnet\_assign\_ipv6\_address\_on\_creation)         | n/a                                                      | `bool`              | `false`                                    |    no    |

## Outputs

| Name                                                                                            | Description |
|-------------------------------------------------------------------------------------------------|-------------|
| <a name="output_application_subnets"></a> [application\_subnets](#output\_application\_subnets) | n/a         |
| <a name="output_data_subnets"></a> [data\_subnets](#output\_data\_subnets)                      | n/a         |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets)                | n/a         |
| <a name="output_vpc"></a> [vpc](#output\_vpc)                                                   | n/a         |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
