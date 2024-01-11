module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  create_igw = true
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "test_cluster"
  cluster_version = "1.27"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      resolve_conflict = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflict = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflict = "OVERWRITE"
    }
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t2.micro"]
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}