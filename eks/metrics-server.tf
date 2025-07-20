module "metrics-server" {
  source      = "./modules/metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"

  app = {
    deploy  = true
    name    = "metrics-server"
    version = local.metrics_chart_version
    chart   = "metrics-server"
  }

  set = [
    {
      name  = "replicaCount"
      value = local.metrics_replica_count
    }
  ]
}
