locals {
  environment = lookup(var.common_tags, "environment", "default")

//metrics-server
  metrics_chart_version = "3.12.2"
  metrics_replica_count = "1"
  metrics_app_name      = "metrics-server"

//cluster-autoscaler 
  autoscaler_chart_version    = "9.46.6"
  autoscaler_replica_count    = "1"
  cluster_autoscaler_app_name = "cluster-autoscaler"
  

}
