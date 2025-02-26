resource "aws_networkfirewall_firewall" "main" {
  count               = 3
  name                = "${local.name-prefix}-${data.aws_availability_zones.all.names[count.index]}"
  firewall_policy_arn = var.aws_networkfirewall_firewall_policy.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall[count.index].id
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
