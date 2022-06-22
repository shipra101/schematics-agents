resource "kubernetes_network_policy" "runtime_ingress_job" {
  metadata {
    name      = "runtime-ingress-job"
    namespace = "schematics-runtime"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "runtime-job"
      }
    }

    ingress {
      ports {
        protocol = "TCP"
        port     = "3002"
      }
    }

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "schematics-job-runtime"
          }
        }
      }

      from {
        pod_selector {
          match_labels = {
            microservice = "schematics-job-runtime"
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
  depends_on = [kubernetes_deployment.runtime_job]
}

