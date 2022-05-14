
resource "aws_eip" "nat" {
  #count = length(var.azs)
  count = var.toggle_nat_gateway ? length(var.azs) : 0
  vpc   = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.14.0"

  name = var.vpc_name
  cidr = var.cidr
  secondary_cidr_blocks = var.secondary_cidr_blocks

  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway     = var.toggle_nat_gateway
  create_igw             = var.toggle_igw
  one_nat_gateway_per_az = true
  reuse_nat_ips          = true
  external_nat_ip_ids    = aws_eip.nat.*.id

  enable_dhcp_options      = true
  dhcp_options_domain_name = var.internal_domain_name
  dhcp_options_domain_name_servers = var.internal_domain_name_servers
  enable_dns_hostnames     = true
  enable_dns_support       = true

  tags = {
    Name                                        = var.vpc_name
    Owner                                       = var.owner_name
    Environment                                 = var.environment_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared" 
  }

  private_subnet_tags = {
    Name = "${var.vpc_name}_${var.private_subnet_tag_suffix}"
    "kubernetes.io/role/internal-elb" = "1"
    "karpenter.sh/discovery" = var.eks_cluster_name
  }

  public_subnet_tags = {
    Name = "${var.vpc_name}_${var.public_subnet_tag_suffix}"
    "kubernetes.io/role/elb" = "1"
  }
}

module "vpc_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v4.9.0"

  name        = "vpc_security_group"
  description = "vpc security group"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]

  tags = {
    Name        = var.vpc_name
    Owner       = var.owner_name
    Environment = var.environment_name
  }
}

resource "aws_route53_zone" "private" {
  name = var.internal_domain_name

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = {
    Name        = var.vpc_name
    Owner       = var.owner_name
    Environment = var.environment_name
  }
}

resource "aws_route53_zone" "external" {
  name = var.external_domain_name

  tags = {
    Name        = var.vpc_name
    Owner       = var.owner_name
    Environment = var.environment_name
  }
}


data "aws_route53_zone" "target_zone" {
  zone_id  = var.r53_target_zone
}


resource "aws_route53_record" "glue_record_ext" {
  zone_id  = data.aws_route53_zone.target_zone.zone_id
  name     = var.external_domain_name
  type     = "NS"
  ttl      = "300"

  # Match and create A records for all occurences for this host/node
  records = aws_route53_zone.external.name_servers

  lifecycle {
    create_before_destroy = true
  }
}


