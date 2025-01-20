resource "aws_networkfirewall_firewall" "main" {
  count               = 3
  name                = "${local.name-prefix}-${data.aws_availability_zones.all.names[count.index]}"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall[count.index].id
  }
}

locals {
  # rule_file         = try(aws_networkfirewall_rule_group.rule_file[0].arn, "")
  # domain_allow_list = try(aws_networkfirewall_rule_group.domain_allow_list[0].arn, "")
  rule_file         = var.network_firewall_rules_file == "" ? "" : aws_networkfirewall_rule_group.rule_file[0].arn
  domain_allow_list = length(var.domain_allow_list) == 0 ? "" : aws_networkfirewall_rule_group.domain_allow_list[0].arn
  rule_group_arns   = toset(sort(concat([local.rule_file], [local.domain_allow_list])))
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
    dynamic "stateful_rule_group_reference" {
      for_each = local.rule_group_arns
      content {
        resource_arn = stateful_rule_group_reference.key
      }
    }
  }
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  # count    = var.network_firewall_rules_file == "" ? 0 : 1
  capacity = 100
  name     = "rule-file-${replace(filebase64sha256(var.network_firewall_rules_file), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules    = file(var.network_firewall_rules_file)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_networkfirewall_rule_group" "domain_allow_list" {
  # count    = length(var.domain_allow_list) == 0 ? 0 : 1
  capacity = 100
  name     = "domain-allow-list${replace(sha256(jsonencode(var.domain_allow_list)), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rule_group {
    stateful_rule_options {
      rule_order = "DEFAULT_ACTION_ORDER"
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types = [
          "HTTP_HOST",
          "TLS_SNI"
        ]
        targets = var.domain_allow_list
      }
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "network_firewall" {
  name              = "/aws/vendedlogs/network-firewall-flow-log/${aws_vpc.main.id}"
  retention_in_days = var.network_firewall_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.network_firewall_cloudwatch_log_group_kms_key_id
}

data "aws_caller_identity" "main" {}

data "aws_iam_policy_document" "network_firewall_log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = [aws_cloudwatch_log_group.network_firewall.arn]

    principals {
      identifiers = [data.aws_caller_identity.main.account_id]
      type        = "AWS"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "network_firewall_log_publishing" {
  policy_document = data.aws_iam_policy_document.network_firewall_log_publishing.json
  policy_name     = "network-firewall-log-publishing-policy"
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
      log_type             = "FLOW"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.network_firewall.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "TLS"
    }
  }
}

resource "aws_cloudwatch_query_definition" "network_firewall_logs" {
  name = "Network Firewall Queries/Network Firewall Logs"
  log_group_names = [
    aws_cloudwatch_log_group.network_firewall.name
  ]

  query_string = <<EOF
fields @timestamp, event.alert.action, event.tls.sni, event.event_type, event.alert.signature, availability_zone, event.proto, @message
| sort @timestamp desc
| limit 10000
EOF
}
