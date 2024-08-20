data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "current" {
  name       = try(module.eks.cluster_name, null)
  depends_on = [module.eks]
}
data "aws_eks_cluster_auth" "current" {
  name       = try(module.eks.cluster_name, null)
  depends_on = [module.eks]
}

data "aws_availability_zones" "available" {}