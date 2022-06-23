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
# Resource Group where VPC is created
##############################################################################

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

##############################################################################


##############################################################################
# Kubetnetes provider setup
##############################################################################

data "ibm_container_cluster_config" "config" {
  cluster_name_id   = var.cluster_id
  config_dir        = local.config_dir
  resource_group_id = data.ibm_resource_group.resource_group.id
}

provider "kubernetes" {
  config_path = data.ibm_container_cluster_config.config.config_file_path
}

##############################################################################

##############################################################################
# create all the requires namespaces for the services
##############################################################################



locals {
  namespaces = {
    schematics_job_runtime = "schematics-job-runtime"
    schematics_sandbox     = "schematics-sandbox"
    schematics_runtime     = "schematics-runtime"
    logdna_agent           = "schematics-ibm-observe"
  }
}

resource "kubernetes_namespace" "namespace" {
  for_each = local.namespaces
  metadata {
    labels = {
      mylabel = each.value
    }
    name = each.value
  }
}


##############################################################################
