provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = "reference-vpc"
  cidr = "10.16.0.0/16"

  azs                 = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  public_subnets      = ["10.16.48.0/20", "10.16.112.0/20", "10.16.176.0/20"] # Web tier
  private_subnets     = ["10.16.16.0/20", "10.16.80.0/20", "10.16.144.0/20"] # App tier
  database_subnets    = ["10.16.32.0/20", "10.16.96.0/20", "10.16.160.0/20"] # DB tier
  intra_subnets       = ["10.16.0.0/20", "10.16.64.0/20", "10.16.128.0/20"] # Reserved tier

  enable_nat_gateway     = false
  single_nat_gateway     = true
  enable_vpn_gateway     = false
  enable_dns_support     = true
  enable_dns_hostnames   = true

  create_database_subnet_group = true
  create_flow_log_cloudwatch_log_group = true
  enable_flow_log                    = true

  tags = {
    id     = "core-vpc"
  }
}
