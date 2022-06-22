resource "kubernetes_network_policy" "whitelist_sandbox" {
  metadata {
    name      = "whitelist-sandbox"
    namespace = "schematics-sandbox"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "sandbox"
      }
    }

    ingress {
      ports {
        port = "3000"
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
            microservice = "jobrunner"
          }
        }
      }
    }

    egress {
      ports {
        protocol = "TCP"
        port     = "80"
      }

      ports {
        protocol = "TCP"
        port     = "443"
      }

      ports {
        protocol = "TCP"
        port     = "53"
      }

      ports {
        protocol = "UDP"
        port     = "53"
      }

      ports {
        protocol = "UDP"
        port     = "443"
      }

      ports {
        protocol = "TCP"
        port     = "5986"
      }

      ports {
        protocol = "TCP"
        port     = "22"
      }
    }

    policy_types = ["Ingress", "Egress"]
  }
  depends_on = [kubernetes_deployment.sandbox]
}

