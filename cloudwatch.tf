resource "aws_cloudwatch_metric_alarm" "nat_gateway_bytes_out" {
  alarm_name        = "${local.name-prefix}-${local.aws_region}-${aws_vpc.main.id}-nat-bytes-out"
  alarm_description = "Sum of BytesOutToDestination for NAT Gateways in VPC ${aws_vpc.main.id}."

  actions_enabled = length(var.nat_gateway_egress_alarm_config.alarm_actions) > 0 ? true : false
  alarm_actions   = var.nat_gateway_egress_alarm_config.alarm_actions

  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = var.nat_gateway_egress_alarm_config.datapoints_to_alarm
  evaluation_periods  = var.nat_gateway_egress_alarm_config.evaluation_periods
  threshold           = var.nat_gateway_egress_alarm_config.threshold

  metric_query {
    expression  = "SELECT SUM(BytesOutToDestination) FROM \"AWS/NATGateway\" WHERE tag.VpcId = '${aws_vpc.main.id}'"
    id          = "q1"
    label       = "SumNatGateWayBytesOutByVpc"
    period      = 60
    return_data = true
  }

  treat_missing_data = "notBreaching"
}

resource "aws_cloudwatch_alarm_mute_rule" "nat_gateway_bytes_out_mute_periods" {
  for_each    = { for idx, mute in var.nat_gateway_egress_alarm_mute_config : idx => mute }
  name        = "NAT Gateway Egress Scheduled Mute Rule ${each.key}"
  description = each.value.description
  rule {
    schedule {
      duration   = each.value.duration
      expression = each.value.cron
    }
  }
  mute_targets {
    alarm_names = [aws_cloudwatch_metric_alarm.nat_gateway_bytes_out.alarm_name]
  }
}
