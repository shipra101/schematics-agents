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
# Terraform Providers
##############################################################################

terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~>1.42.0"
    }
  }
  experiments = [ module_variable_optional_attrs ]
}

##############################################################################