include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
  source = "${get_repo_root()}/infra/modules/ec2"
}
inputs = {
   aws_region    = include.env.locals.ec2.region
   key_name      = include.env.locals.ec2.key_name
   instance_type = include.env.locals.ec2.instance_type
}

# dependency "vpc" {
#     config_path = "../vpc"
#      mock_outputs = {
#      vpc_id = "vpc-0000000000"
#      vpc_cidr = "10.0.0.0/16"
#      private_subnets = ["subnet-11111111", "subnet-22222222"]
#   }
# }

