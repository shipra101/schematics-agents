resource "kubernetes_network_policy" "whitelist_egress_jobrunner" {
  metadata {
    name      = "whitelist-egress-jobrunner"
    namespace = "schematics-job-runtime"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "jobrunner"
      }
    }


    egress {
      ports {
        protocol = "TCP"
        port     = "443"
      }
      ports {
        protocol = "TCP"
        port     = "53"
      }
      ports {
        protocol = "TCP"
        port     = "3000"
      }
      ports {
        protocol = "TCP"
        port     = "3002"
      }

      ports {
        protocol = "UDP"
        port     = "443"
      }
      ports {
        protocol = "UDP"
        port     = "53"
      }

      to {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }

    }

    policy_types = ["Ingress", "Egress"]
  }
  depends_on = [kubernetes_deployment.jobrunner]
}

