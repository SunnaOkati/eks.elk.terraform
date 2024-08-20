module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-${local.naming_suffix}"
  cluster_version = var.eks_confiugration["cluster_version"]

  cluster_endpoint_public_access           = var.eks_confiugration["cluster_endpoint_public_access"]
  enable_cluster_creator_admin_permissions = var.eks_confiugration["enable_cluster_creator_admin_permissions"]
  create_cloudwatch_log_group              = var.eks_confiugration["create_cloudwatch_log_group"]

  cluster_addons = var.eks_confiugration["cluster_addons"]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = var.eks_confiugration["eks_managed_node_group_defaults"]

  eks_managed_node_groups = {
    "eks-${local.naming_suffix}" = var.eks_confiugration["eks_managed_node_groups"]
  }

  tags = merge(local.common_tags, var.eks_confiugration["tags"])

}