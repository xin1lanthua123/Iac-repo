  resource "aws_eks_addon" "vpc_cni" {
    cluster_name = aws_eks_cluster.eks.name
    addon_name   = "vpc-cni"
    
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"

    configuration_values = jsonencode({
      enableNetworkPolicy = "true"

      env = {
        ENABLE_PREFIX_DELEGATION = "true"
        NETWORK_POLICY_ENFORCING_MODE = "strict"
      }
    })
  }