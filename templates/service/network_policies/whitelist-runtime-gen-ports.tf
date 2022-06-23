###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

resource "kubernetes_network_policy" "whitelist_runtime_egress_gen_ports" {
  metadata {
    name      = "whitelist-runtime-egress-gen-ports"
    namespace = var.schematics_runtime
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
}

