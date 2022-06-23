###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

resource "kubernetes_network_policy" "deny_all_sandbox" {
  metadata {
    name      = "deny-all-sandbox"
    namespace = var.schematics_sandbox
  }

  spec {
    pod_selector {
      match_labels = {
        app = "sandbox"
      }
    }

    policy_types = ["Egress", "Ingress"]
  }
}

