###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

resource "kubernetes_network_policy" "whitelist_egress_jobrunner" {
  metadata {
    name      = "whitelist-egress-jobrunner"
    namespace = var.schematics_job_runtime
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
}

