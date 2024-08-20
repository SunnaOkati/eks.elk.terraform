module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "~> 5.0"
  name            = "${var.environment_name}-vpc"
  cidr            = var.vpc_confiugration["cidr_block"]
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.subnet_confiugration["private_subnets"]
  public_subnets  = var.subnet_confiugration["public_subnets"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = merge(local.common_tags, var.vpc_confiugration["tags"])
}