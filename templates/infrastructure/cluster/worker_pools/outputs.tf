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
# Worker Pool Outputs
##############################################################################

output worker_pools {
    description = "Worker pool data"
    value       = ibm_container_vpc_worker_pool.pool
}

##############################################################################