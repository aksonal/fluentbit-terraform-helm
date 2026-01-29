resource "kubernetes_service_account" "ic_dev_fluentbit_pod_sa" {
  metadata {
    name      = "fluentbit-custom-sa"
    namespace = kubernetes_namespace.ic_dev_fluentbit_ns.id
    annotations = {
      "eks.amazonaws.com/role-arn" = "${aws_iam_role.ic_dev_fluentbit_pod_role.arn}"
    }
  }

  automount_service_account_token = true
  depends_on                      = [kubernetes_namespace.ic_dev_fluentbit_ns]
}
