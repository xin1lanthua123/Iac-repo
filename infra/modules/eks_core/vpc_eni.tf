resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "vpc-cni"

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
    networkPolicyEnforcingMode = "strict"

    env = {
      ENABLE_PREFIX_DELEGATION = "true"
    }
  })
}