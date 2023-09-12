# resource "aws_networkfirewall_firewall" "main" {
#   name                = local.name-prefix
#   firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
#   vpc_id              = aws_vpc.main.id
#   subnet_mapping {
#     subnet_id = aws_subnet.firewall.id
#   }
# }

# resource "aws_networkfirewall_firewall_policy" "main" {
#   name = "main"

#   firewall_policy {
#     policy_variables {
#       rule_variables {
#         key = "HOME_NET"
#         ip_set {
#           definition = ["10.0.0.0/16", "10.1.0.0/24"]
#         }
#       }
#     }
#     stateless_default_actions          = ["aws:pass"]
#     stateless_fragment_default_actions = ["aws:drop"]
#     stateless_rule_group_reference {
#       priority     = 1
#       resource_arn = aws_networkfirewall_rule_group.main.arn
#     }
#   }
# }

resource "aws_networkfirewall_rule_group" "main" {
  capacity = 100
  name     = "main"
  type     = "STATEFUL"
  rules    = file(var.network_firewall_rules_file)
}

resource "aws_cloudwatch_log_group" "network_firewall" {
  name              = "/aws/network-firewall-flow-log/${aws_vpc.main.id}"
  retention_in_days = var.network_firewall_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.network_firewall_cloudwatch_log_group_kms_key_id
}

# resource "aws_networkfirewall_logging_configuration" "main" {
#   firewall_arn = aws_networkfirewall_firewall.main.arn
#   logging_configuration {
#     log_destination_config {
#       log_destination = {
#         logGroup = aws_cloudwatch_log_group.network_firewall.name
#       }
#       log_destination_type = "CloudWatchLogs"
#       log_type             = "FLOW"
#     }
#   }
# }
