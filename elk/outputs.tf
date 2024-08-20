output "aws_connection_string" {
  description = "AWS connection string for EKS"
  value       = var.aws_connection_string
}

output "eks_cluster_name" {
  value       = "${var.eks_cluster_name}"
}

output "kibana_endpoint" {
  value       = "${var.kibana_endpoint}"
}