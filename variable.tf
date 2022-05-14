variable "cidr" {
  description = "cidr"
}

variable "secondary_cidr_blocks" {
  description = "secondary_cidr_blocks"
}

variable "vpc_name" {
  description = "vpc name"
}

variable "owner_name" {
  description = "ownwer name"
}

variable "environment_name" {
  description = "environment name"
}

variable "azs" {
  description = "azs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "public subnets"
  type        = list(string)
  default     = []
}

variable "secondary_cidr_subnets" {
  description = "secondary_cidr_subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_tag_suffix" {
  description = "private subnet tag suffix"
  default     = "private"
}

variable "public_subnet_tag_suffix" {
  description = "public subnet tag suffix"
  default     = "public"
}

variable "secondary_subnet_tag_suffix" {
  description = "secondary subnet tag suffix"
  default     = "secondary"
}

variable "database_subnets" {
  description = "database subnets"
  type        = list(string)
  default     = []
}

variable "internal_domain_name" {
  description = "internal domain name"
}

variable "external_domain_name" {
  description = "external domain name"
}

variable "internal_domain_name_servers" {
  description = "internal domain_name servers"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}


variable "r53_target_zone" {
  description = "Specify route53 zone id to connect with"
}


variable "eks_cluster_name" {
  description = "cluster name"
}

variable "toggle_nat_gateway" {
  description = "toggle whether or not to create nat gateways"
  default     = true
}

variable "toggle_igw" {
  description = "toggle whether or not to create internet gateway"
  default     = true
}

