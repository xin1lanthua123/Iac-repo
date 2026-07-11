output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
output "cluster_name" {
  value = module.eks.cluster_name
}
output "eks_cluster_arn" {
  value = module.eks.cluster_arn
}
output "cluster_ca" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = try(module.eks.oidc_provider_arn, null)
}

output "oidc_provider_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}
