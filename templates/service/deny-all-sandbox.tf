resource "kubernetes_network_policy" "deny_all_sandbox" {
  metadata {
    name      = "deny-all-sandbox"
    namespace = "schematics-sandbox"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "sandbox"
      }
    }

    policy_types = ["Egress", "Ingress"]
  }
  depends_on = [kubernetes_deployment.sandbox]
}

