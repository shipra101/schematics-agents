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
# Cluster Outputs
##############################################################################

output "id" {
  description = "ID of cluster created"
  value       = ibm_container_vpc_cluster.cluster[0].id
  # Ensure cluster is finished before outputting variable from module
  depends_on = [ibm_container_vpc_cluster.cluster]
}

output "name" {
  description = "Name of cluster created"
  value       = ibm_container_vpc_cluster.cluster[0].name
  # Ensure cluster is finished before outputting variable from module
  depends_on = [ibm_container_vpc_cluster.cluster]
}

output "private_service_endpoint_url" {
  description = "URL For Cluster Private Service Endpoint"
  value       = ibm_container_vpc_cluster.cluster[0].private_service_endpoint_url
}

output "private_service_endpoint_port" {
  description = "Port for Cluster private service endpoint"
  value       = split(":", ibm_container_vpc_cluster.cluster[0].private_service_endpoint_url)[2]
}

##############################################################################
