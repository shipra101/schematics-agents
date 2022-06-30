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
# Outputs
##############################################################################

output "logdna_crn" {
  description = "Logdna CRN"
  value       = ibm_resource_instance.logdna[0].crn
}

output "logdna_guid" {
  description = "Logdna GUID"
  value       = ibm_resource_instance.logdna[0].guid
}

output "logdna_name" {
  description = "Name of the logdna instance"
  value       = ibm_resource_instance.logdna[0].name
}

# output "sysdig_crn" {
#   description = "Sysdig CRN"
#   value       = ibm_resource_instance.sysdig[0].crn
# }

# output "sysdig_guid" {
#   description = "Sysdig GUID"
#   value       = ibm_resource_instance.sysdig[0].crn
# }

##############################################################################