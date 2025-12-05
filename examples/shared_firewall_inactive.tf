# Shared Network Firewall with the Firewall Routing Disabled so no traffic passes through the firewall
module "network" {
  source                              = "github.com/ministryofjustice/opg-terraform-aws-firewalled-network?ref=v0.2.14"
  aws_networkfirewall_firewall_policy = aws_networkfirewall_firewall_policy.main
  cidr                                = var.network_cidr_block
  default_security_group_egress       = []
  default_security_group_ingress      = []
  enable_dns_hostnames                = true
  enable_dns_support                  = true
  network_firewall_enabled            = false
  shared_firewall_configuration = {
    account_id   = 01234567890
    account_name = development
  }

  providers = {
    aws = aws.region
  }
}
