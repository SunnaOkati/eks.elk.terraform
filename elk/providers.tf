terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/helm"
      version = "2.5.1"
      source  = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://${aws_eks_cluster.cluster.endpoint}"
#    config_path    = "~/.kube/config"

    client_certificate     = base64decode(aws_eks_cluster.cluster.master_auth.0.client_certificate)
    client_key             = base64decode(aws_eks_cluster.cluster.master_auth.0.client_key)
  }
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.master_auth.0.cluster_ca_certificate)
}

provider "kubernetes" {
  host                   = "https://${aws_eks_cluster.cluster.endpoint}"
#  config_path    = "~/.kube/config"

  client_certificate     = base64decode(aws_eks_cluster.cluster.master_auth.0.client_certificate)
  client_key             = base64decode(aws_eks_cluster.cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.master_auth.0.cluster_ca_certificate)

}


provider "kubectl" {
  host                   = "https://${aws_eks_cluster.cluster.endpoint}"
  client_certificate     = base64decode(aws_eks_cluster.cluster.master_auth.0.client_certificate)
  client_key             = base64decode(aws_eks_cluster.cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.master_auth.0.cluster_ca_certificate)
}

# Configure the AWS Provider
provider "aws" {
  region                   = "ap-southeast-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}