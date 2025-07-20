module "cluster-autoscaler" {
  source      = "./modules/cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"

  app = {
    deploy  = true
    name    = "cluster-autoscaler"
    version = local.autoscaler_chart_version
    chart   = "cluster-autoscaler"
  }

  set = [
    {
      name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
      value = module.cluster_autoscaler_irsa_role.iam_role_arn
    },
    {
      name  = "rbac.serviceAccount.name"
      value = local.cluster_autoscaler_app_name
    },
    {
      name  = "autoDiscovery.clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "replicaCount"
      value = local.autoscaler_replica_count
    },
    {
      name  = "autoDiscovery.tags"
      type  = "string"
      value = "{k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${module.eks.cluster_name}}"
    }
  ]
}


###############################
# IAM assumable role for cluster-autoscaler
###############################
module "cluster_autoscaler_irsa_role" {
  source  = "./modules/cluster_autoscaler_irsa_role"

  role_name                        = "${var.name}-${local.environment}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_ids   = [module.eks.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:${local.cluster_autoscaler_app_name}"]
    }
  }

  tags = var.common_tags
}
