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
# VPC
##############################################################################

##############################################################################

##############################################################################
# Subnet Outputs
##############################################################################


##############################################################################

##############################################################################
# Cluster Outputs
##############################################################################

output "cluster_id" {
  description = "ID of cluster created"
  value       = module.classic_cluster.*.id
}

output "cluster_name" {
  description = "Name of cluster created"
  value       = module.classic_cluster.*.name
}


##############################################################################

##############################################################################
# Logging and Monitoring Outputs
##############################################################################

output "logdna_name" {
  description = "Name of LogDna created"
  value       = module.observability.*.logdna_name
}

##############################################################################