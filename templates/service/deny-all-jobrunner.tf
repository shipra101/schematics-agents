resource "kubernetes_network_policy" "deny_all_jobrunner" {
  metadata {
    name      = "deny-all-jobrunner"
    namespace = "schematics-job-runtime"
  }

  spec {
    pod_selector {
      match_expressions {
        key      = "app"
        operator = "In"
        values   = ["jobrunner"]
      }
    }

    policy_types = ["Egress", "Ingress"]
  }
  depends_on = [kubernetes_deployment.jobrunner]
}

