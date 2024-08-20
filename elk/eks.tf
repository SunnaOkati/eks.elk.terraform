# Create the VPC for the Kubernetes cluster
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create the subnet for the Kubernetes cluster
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create the IAM role for the Kubernetes service account
resource "aws_iam_role" "eks_service_role" {
  name = "eksServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.aws_region}.amazonaws.com/id/${aws_iam_openid_connect_provider.oidc.issuer_id}"
        }
        Condition = {
          StringEquals = {
            "${aws_iam_openid_connect_provider.oidc.url}:sub" = "system:serviceaccount:default:default"
          }
        }
      },
    ]
  })
}

# Create the OpenID Connect (OIDC) provider
resource "aws_iam_openid_connect_provider" "oidc" {
  url        = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${aws_iam_role.eks_service_role.arn}"
  client_id_list = ["default"]
  thumbprint_list = ["1234567890ABCDEF1234567890ABCDEF12345678"]
}

# Create the EKS cluster
resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_service_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cni,
    aws_iam_role_policy_attachment.eks_pod,
  ]
}

# Attach the Amazon EKS CNI plugin policy to the EKS service role
resource "aws_iam_role_policy_attachment" "eks_cni" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Attach the Amazon EKS Pod execution role policy to the EKS service role
resource "aws_iam_role_policy_attachment" "eks_pod" {
  role       = aws_iam_role.eks_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_PodExecutionRolePolicy"
}

# Create the node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.eks_service_role.arn
  subnet_ids      = [aws_subnet.subnet.id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  ami_type        = "AL2_x86_64"
  disk_size       = 20
  instance_types  = ["t2.small"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cni,
    aws_iam_role_policy_attachment.eks_pod,
  ]