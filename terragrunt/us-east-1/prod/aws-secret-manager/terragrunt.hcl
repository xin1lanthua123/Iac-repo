include "root" {
    path = find_in_parent_folders("root.hcl")
}
include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true
    merge_strategy = "no_merge"
    }
terraform {
    source = "../../../../infra/modules/aws-secret-manager"
}
inputs = {
    env                        = include.env.locals.tags.env
   
}

