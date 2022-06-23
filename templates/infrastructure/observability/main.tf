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
# Create Activity Tracker
##############################################################################

resource "ibm_resource_instance" "activity_tracker" {
  count             = var.create_activity_tracker == true ? 1 : 0
  name              = "${var.prefix}-activity-tracker"
  service           = "logdnaat"
  plan              = var.logdna_plan
  location          = var.region
  resource_group_id = var.resource_group_id
  parameters = {
    service-endpoints = var.service_endpoints
  }

  tags = var.tags
}
##############################################################################


##############################################################################
# LogDNA
##############################################################################

resource "ibm_resource_instance" "logdna" {
  count             = var.enable_observability == true ? 1 : 0
  name              = "${var.prefix}-logdna"
  location          = var.region
  plan              = var.logdna_plan
  resource_group_id = var.resource_group_id
  service           = "logdna"
  service_endpoints = var.service_endpoints
  tags              = var.tags
}

resource "ibm_resource_key" "logdna_key" {
  count                = var.enable_observability == true ? 1 : 0
  name                 = "${var.prefix}-logdna-key"
  role                 = "Manager"
  resource_instance_id = ibm_resource_instance.logdna[0].id
  tags                 = var.tags
}

##############################################################################


##############################################################################
# Sysdig
##############################################################################

# resource "ibm_resource_instance" "sysdig" {
#   count             = var.enable_observability == true ? 1 : 0
#   name              = "${var.prefix}-sysdig"
#   location          = var.region
#   plan              = var.sysdig_plan
#   resource_group_id = var.resource_group_id
#   service           = "sysdig-monitor"
#   service_endpoints = var.service_endpoints
# }

##############################################################################