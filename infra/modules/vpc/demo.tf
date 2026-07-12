module "vpc" {

  source = "terraform-aws-modules/vpc/aws"

  version = "~> 5.0"


  name = "${var.env}-${var.project_name}-vpc"

  cidr = var.vpc_cidr


  azs = var.azs


  private_subnets = var.private_subnets

  public_subnets = var.public_subnets


  enable_nat_gateway = var.enable_nat_gateway

  single_nat_gateway = var.single_nat_gateway


  enable_dns_hostnames = true

  enable_dns_support = true


  public_subnet_tags = {
  "kubernetes.io/role/elb" = "1"
  "kubernetes.io/cluster/${var.env}-${var.project_name}-eks" = "shared"
}

private_subnet_tags = {
  "kubernetes.io/role/internal-elb" = "1"
  "kubernetes.io/cluster/${var.env}-${var.project_name}-eks" = "shared"
}


  tags = var.tags

}