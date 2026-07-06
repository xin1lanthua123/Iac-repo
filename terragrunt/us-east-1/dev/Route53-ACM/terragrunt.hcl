include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "${get_repo_root()}/infra/modules/Route53-ACM"
}
inputs = {
    domain_name  = include.env.locals.route53.domain_name
}

     
