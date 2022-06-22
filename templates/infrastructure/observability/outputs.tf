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

output "logdna_resource_key" {
  description = "ID for logdna resource key"
  value       = ibm_resource_key.logdna_key[0].id
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