output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_eks_cluster_role_arn" {
  value = data.aws_eks_cluster.current.role_arn
}

output "oidc" {
  value = module.eks.oidc_provider_arn
}