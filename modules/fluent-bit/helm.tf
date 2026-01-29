resource "helm_release" "ic_dev_fluentbit" {
  name       = "fluentbit-cw-logs-${var.env}" #release name
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.55.0" #https://artifacthub.io/packages/helm/fluent/fluent-bit

  namespace = kubernetes_namespace.ic_dev_fluentbit_ns.metadata[0].name

   values = [
    yamlencode({
      # --- ServiceAccount (CRITICAL) ---
      serviceAccount = {
        create = false
        name   = "fluentbit-custom-sa"
      }

      # --- Scheduling ---
      tolerations = [
        {
          operator = "Exists"
        }
      ]

      # --- Fluent Bit runtime ---
      fluentBit = {
        logLevel = "debug"
      }

      # --- Fluent Bit config ---
      config = {
        inputs  = local.fluentbit_inputs
        filters = local.fluentbit_filters
        outputs = local.fluentbit_outputs
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.ic_dev_fluentbit_pod_sa,
    kubernetes_namespace.ic_dev_fluentbit_ns
  ]
}
