###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

##############################################################################
# Create IKS on Classic Cluster
##############################################################################

resource "ibm_container_cluster" "cluster" {
  count           = var.create_cluster ? 1 : 0
  name            = "${var.prefix}-cluster"
  machine_type    = var.machine_type
  hardware        = "shared"
  public_vlan_id  = "vlan"
  private_vlan_id = "vlan"
  resource_group_id    = var.resource_group_id
  
  default_pool_size = 1

  labels = {
    "test" = "test-pool"
  }

}
##############################################################################
