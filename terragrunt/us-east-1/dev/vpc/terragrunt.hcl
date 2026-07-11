include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }

terraform {
    source = "${get_repo_root()}/infra/modules/vpc"
}

inputs = {
  tags = include.env.locals.tags
  env = include.env.locals.tags.env
  project_name = include.env.locals.tags.Project
  vpc_cidr = include.env.locals.vpc.vpc_cidr
  azs = include.env.locals.vpc.azs
  private_subnets = include.env.locals.vpc.private_subnets
  public_subnets = include.env.locals.vpc.public_subnets
  enable_nat_gateway = include.env.locals.vpc.enable_nat_gateway
  single_nat_gateway = include.env.locals.vpc.single_nat_gateway
}
