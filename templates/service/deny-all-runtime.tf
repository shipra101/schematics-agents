resource "kubernetes_network_policy" "deny_all_runtime" {
  metadata {
    name      = "deny-all-runtime"
    namespace = "schematics-runtime"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "app"
        operator = "In"
        values   = ["runtime-job"]
      }
    }

    policy_types = ["Egress", "Ingress"]
  }
  depends_on = [kubernetes_deployment.runtime_job]
}

