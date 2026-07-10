  resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks.name

  addon_name    = "vpc-cni"
  addon_version = "v1.22.3-eksbuild.1"

  configuration_values = jsonencode({
    enableNetworkPolicy          = "true"
    networkPolicyEnforcingMode   = "strict"

    env = {
      ENABLE_PREFIX_DELEGATION = "true"
      NETWORK_POLICY_ENFORCING_MODE = "strict"
    }
  })
}