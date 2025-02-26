module "network" {
  source                              = "github.com/ministryofjustice/opg-terraform-aws-firewalled-network?ref=v0.2.14"
  cidr                                = var.network_cidr_block
  enable_dns_hostnames                = true
  enable_dns_support                  = true
  default_security_group_ingress      = []
  default_security_group_egress       = []
  aws_networkfirewall_firewall_policy = aws_networkfirewall_firewall_policy.main
  providers = {
    aws = aws.region
  }
}

variable "network_firewall_rules_file" {
  type        = string
  description = "path to the file containing the network firewall rules in suricata format"
  default     = ""
}

variable "domain_allow_list" {
  type        = list(string)
  description = "List of domains that you want to allow egress to"
  default     = []
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
      resource_arn = aws_networkfirewall_rule_group.rule_file.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.domain_allow_list
    }
  }
  provider = aws.region
}

resource "aws_networkfirewall_rule_group" "rule_file" {
  capacity = 100
  name     = "rule-file-${replace(filebase64sha256(var.network_firewall_rules_file), "/[^[:alnum:]]/", "")}"
  type     = "STATEFUL"
  rules    = file(var.network_firewall_rules_file)
  lifecycle {
    create_before_destroy = true
  }
  provider = aws.region
}

resource "aws_networkfirewall_rule_group" "domain_allow_list" {
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
  provider = aws.region
}
