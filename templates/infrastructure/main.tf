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
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.location
  ibmcloud_timeout = 60
}

##############################################################################


##############################################################################
# Resource Group where VPC will be created
##############################################################################

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}


# data "ibm_resource_instance" "schematics_resource_instance" {
# name     = "schematics"
# location = var.region
# service  = "schematics"
# resource_group_id = data.ibm_resource_group.resource_group.id
#
#}

##############################################################################


##############################################################################

##############################################################################
# observability
##############################################################################

module "observability" {
  count                = (local.enable_observability ? 1 : 0)
  enable_observability = local.enable_observability
  source               = "./observability"
  prefix               = var.agent_prefix
  region               = var.location
  resource_group_id    = data.ibm_resource_group.resource_group.id
}

##############################################################################


##############################################################################
# Create Cluster
##############################################################################

data "ibm_container_cluster_versions" "cluster_versions" {
  region = var.location
}

module "classic_cluster" {
  count          = (local.create_cluster ? 1 : 0)
  create_cluster = local.create_cluster
  source         = "./cluster"
  # Account Variables
  prefix            = var.agent_prefix
  region            = var.location
  resource_group_id = data.ibm_resource_group.resource_group.id
  # Cluster Variables
  machine_type     = local.machine_type
  kube_version     = local.kube_version #local.latest
  tags             = var.tags
}

##############################################################################