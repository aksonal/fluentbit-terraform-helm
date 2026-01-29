#AWS provider file
provider "aws" {
  region  = var.aws_region
  profile = var.profile
  default_tags {
    tags = {
      Environment = "ic-dev"
      Owner  = "terraform"
    }
  }
}

data "aws_eks_cluster_auth" "ic_dev_eks_cluster_auth" {
  name = module.eks_cluster.eks_cluster_name
}

provider "kubernetes" {
  host                   = module.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.ca_certificate)
  token                  = data.aws_eks_cluster_auth.ic_dev_eks_cluster_auth.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.ca_certificate)
    token                  = data.aws_eks_cluster_auth.ic_dev_eks_cluster_auth.token
  }
}


