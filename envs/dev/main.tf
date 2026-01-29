module "fluentbit" {
  source = "../../modules/fluent-bit"
  cluster_name = module.eks_cluster.eks_cluster_name
  env = var.env
  namespace = "amazon-cloudwatch"
  region = var.aws_region
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn
  oidc_provider_url = module.eks_cluster.oidc_provider_url
  depends_on = [ module.eks_cluster ]
  providers = {
    helm = helm
  }
  cluster_ready = module.eks_cluster.cluster_ready
}
