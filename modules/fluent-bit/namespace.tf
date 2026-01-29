resource "kubernetes_namespace" "ic_dev_fluentbit_ns" {
  metadata {
    name = var.namespace
  }
 
  depends_on = [var.cluster_ready]

}
