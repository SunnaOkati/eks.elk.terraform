variable  "eck_operator_version" {
  type        = string
  default     = ""
  description = "Elastic Cloud on Kubernetes Version"
}

variable "eks_cluster_name" {
  type        = string
  description = "Please, enter your EKS cluster name"
}

variable "aws_connection_string" {
  description = "AWS connection string for EKS"
  type        = string
  default     = "TO CONNECT TO EKS: aws eks update-kubeconfig --name <EKS_CLUSTER_NAME>"
}

variable "email" {
  type        = string
  description = "Please, enter your email (elastic email) or a user"
}

variable "kibana_endpoint" {
  description = "Kibana endpoint"
  type        = string
  default     = "TO CONNECT TO KIBANA: kubectl port-forward svc/<KIBANA-ENDPOINT> 5601:5601"
}