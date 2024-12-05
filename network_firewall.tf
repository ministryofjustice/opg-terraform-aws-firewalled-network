resource "aws_networkfirewall_firewall" "main" {
  count               = 3
  name                = "${local.name-prefix}-${data.aws_availability_zones.all.names[count.index]}"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall[count.index].id
  }
}

resource "aws_networkfirewall_firewall_policy" "main" {
  name = "main"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_engine_options {
      rule_order              = "DEFAULT_ACTION_ORDER"
      stream_exception_policy = "DROP"
    }
    stateful_rule_group_reference {
      resource_arn = var.network_firewall_rules_file == null ? aws_networkfirewall_rule_group.suricata[0].arn : aws_networkfirewall_rule_group.rule_group[0].arn
    }
  }
}

resource "aws_networkfirewall_rule_group" "suricata" {
  count    = var.network_firewall_rules_file == null ? 0 : 1
  capacity = 100
  name     = "main"
  type     = "STATEFUL"
  rules    = file(var.network_firewall_rules_file)
}

resource "aws_networkfirewall_rule_group" "rule_group" {
  count    = var.allowed_targets_list == null || [] ? 0 : 1
  capacity = 100
  name     = "main"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["HTTP_HOST"]
        targets              = var.allowed_targets_list
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "network_firewall" {
  name              = "/aws/network-firewall-flow-log/${aws_vpc.main.id}"
  retention_in_days = var.network_firewall_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.network_firewall_cloudwatch_log_group_kms_key_id
}

resource "aws_networkfirewall_logging_configuration" "main" {
  count        = 3
  firewall_arn = aws_networkfirewall_firewall.main[count.index].arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }
}
