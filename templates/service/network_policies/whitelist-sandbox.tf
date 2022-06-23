###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

resource "kubernetes_network_policy" "whitelist_sandbox" {
  metadata {
    name      = "whitelist-sandbox"
    namespace = var.schematics_sandbox
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
            name = var.schematics_job_runtime
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
}

