variable "primary_service_name" {
  type        = string
  description = "Name of the services using the resources"
}
variable "environment_name" {
  type        = string
  description = "Name of the environment"
}

variable "region" {
  type        = string
  description = "Name of the region"
}

locals {
  owner         = "ranjth2raj@gmail.com"
  naming_suffix = "${var.region}-${var.environment_name}"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = var.primary_service_name
    Owner       = local.owner
    Environment = var.environment_name
    terraform   = true
  }
}

variable "vpc_confiugration" {
  type = object({
    cidr_block : string
    enable_nat_gateway : bool
    enable_vpn_gateway : bool,
    tags : map(string)
  })
  description = "VPC Configuration"
  default = {
    cidr_block : "10.170.0.0/16"
    enable_nat_gateway : true
    enable_vpn_gateway : true,
    tags : {}
  }
}

variable "subnet_confiugration" {
  type = object({
    private_subnets : list(string),
    public_subnets : list(string),
    tags : map(string)
  })
  description = "Subnet Configuration"
  default = {
    private_subnets : ["10.170.16.0/24", "10.170.32.0/24", "10.170.48.0/24"],
    public_subnets : ["10.170.101.0/24", "10.170.102.0/24", "10.170.103.0/24"]
    tags : {}
  }
}

variable "eks_confiugration" {
  type = object({
    cluster_version : string,
    cluster_endpoint_public_access : bool,
    enable_cluster_creator_admin_permissions : bool,
    create_cloudwatch_log_group : bool,
    eks_managed_node_group_defaults : object({
      ami_type : string
    }),
    eks_managed_node_groups : object(
      {
        name : string,
        instance_types : list(string),
        min_size : number,
        max_size : number,
        desired_size : number,
        iam_role_additional_policies : map(string)
      }
    ),
    cluster_addons : object({
      aws-ebs-csi-driver : object({
        most_recent : bool
      })
    })
    tags : map(string)
  })
  description = "EKS Configuration"
  default = {
    cluster_version : "1.23",
    cluster_endpoint_public_access : true,
    enable_cluster_creator_admin_permissions : true,
    create_cloudwatch_log_group : false,
    eks_managed_node_group_defaults : { ami_type : "AL2_ARM_64" },
    eks_managed_node_groups : {
      name : "managed-m6g-large",
      instance_types : ["m6g.large"],
      desired_size : 4,
      min_size : 4,
      max_size : 4    
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }},
      cluster_addons : {
      aws-ebs-csi-driver = {
        most_recent = true
      }
    },
    tags : {
    }
  }
}