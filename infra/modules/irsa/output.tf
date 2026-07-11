output "alb_role_arn" {
  value = try(aws_iam_role.alb_irsa_role[0].arn, null)
}

output "externaldns_role_arn" {
  value = try(aws_iam_role.externaldns_irsa[0].arn, null)
}

output "karpenter_role_arn" {
  value = try(aws_iam_role.karpenter_irsa[0].arn, null)
}

output "eso_role_arn" {
  value = try(aws_iam_role.eso_irsa[0].arn, null)
}

output "ebs_csi_version" {
  value = try(aws_eks_addon.ebs_csi[0].addon_version, null)
}

output "ebs_csi_role_arn" {
  value       = try(aws_iam_role.ebs_csi[0].arn, null)
  description = "IAM role ARN for EBS CSI Driver"
}

output "cluster_autoscaler_role_arn" {
  value = try(aws_iam_role.cluster_autoscaler[0].arn, null)
}