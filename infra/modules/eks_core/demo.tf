
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.env}-${var.project_name}-eks"
  kubernetes_version = var.cluster_version

  addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      before_compute = true
      most_recent = true
    }
  }

  # Optional
  endpoint_public_access = true
  

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  enable_irsa = var.enable_irsa


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

    eks_managed_node_groups = {
    for name, ng in var.node_groups :
    name => {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [ng.node_instance_type]

      desired_size = ng.desired_size
      min_size     = ng.min_size
      max_size     = ng.max_size
    }
  }
  
 


  tags = var.tags
}

