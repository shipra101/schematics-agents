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
# Create VPC
##############################################################################

module "multizone_vpc" {
  count                = (local.create_cluster ? 1 : 0)
  create_vpc           = local.create_cluster
  source               = "./vpc"
  prefix               = var.agent_prefix
  region               = var.location
  resource_group_id    = data.ibm_resource_group.resource_group.id
  classic_access       = local.classic_access
  subnet_tiers         = local.subnet_tiers
  use_public_gateways  = local.use_public_gateways
  network_acls         = local.network_acls
  security_group_rules = local.security_group_rules
}

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

locals {
  # Get latest openshift version
  # https://cloud.ibm.com/docs/openshift?topic=openshift-openshift_versions
  latest = "${
    data.ibm_container_cluster_versions.cluster_versions.valid_openshift_versions[
      length(data.ibm_container_cluster_versions.cluster_versions.valid_openshift_versions) - 1
  ]}_openshift"
}

module "vpc_cluster" {
  count          = (local.create_cluster ? 1 : 0)
  create_cluster = local.create_cluster
  source         = "./cluster"
  # Account Variables
  prefix            = var.agent_prefix
  region            = var.location
  resource_group_id = data.ibm_resource_group.resource_group.id
  # VPC Variables
  vpc_id  = (local.create_cluster ? module.multizone_vpc[0].vpc_id : 0)
  subnets = module.multizone_vpc[0].subnet_tier_list["vpc"]
  # Cluster Variables
  machine_type     = local.machine_type
  workers_per_zone = local.workers_per_zone
  kube_version     = local.kube_version #local.latest
  tags             = var.tags
  worker_pools     = local.worker_pools
}

##############################################################################