resource "kubernetes_network_policy" "whitelist_runtime_egress_gen_ports" {
  metadata {
    name      = "whitelist-runtime-egress-gen-ports"
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

      ports {
        protocol = "TCP"
        port     = "10250"
      }

      ports {
        protocol = "UDP"
        port     = "10250"
      }

      ports {
        protocol = "TCP"
        port     = "8080"
      }

      ports {
        protocol = "UDP"
        port     = "9092"
      }

      ports {
        protocol = "UDP"
        port     = "9093"
      }

      ports {
        protocol = "TCP"
        port     = "9092"
      }

      ports {
        protocol = "TCP"
        port     = "9093"
      }
    }

    policy_types = ["Egress"]
  }
  depends_on = [kubernetes_deployment.runtime_job]
}

