###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

resource "kubernetes_network_policy" "runtime_ingress_job" {
  metadata {
    name      = "runtime-ingress-job"
    namespace = var.schematics_runtime
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
            name = var.schematics_job_runtime
          }
        }
      }

      from {
        pod_selector {
          match_labels = {
            microservice = var.schematics_job_runtime
          }
        }
      }
    }

    policy_types = ["Ingress"]
  }
}

