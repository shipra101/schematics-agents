###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

variable "agent_prefix" {
  description = "You will use this prefix, for vpc, cluster and  observability. (Max length 27 chars)"
  type        = string
  default     = "my-project"

  # validation {
  #   error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters. The maximum length for prefix is 27 characters"
  #   condition     = length(var.agent_prefix) <= 27
  # }
}

variable "location" {
  description = "Location of the agent infrastructure.  Note: For Beta, the agent must be deployed in a freshly provisioned VPC, IKS Cluster, Log Analysis instance."
  type        = string
  default     = "us-south"
}

variable "resource_group_name" {
  description = "Name of resource group used where agent infrastructure was provisioned"
  type        = string

  # validation  {
  #   error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
  #   condition     = can(regex("^([A-Za-z]|[a-z][-a-z0-9]*[0-9A-Za-z])$", var.resource_group))
  # }
}

variable "tags" {
  description = "A list of tags for the agent infrastructure"
  type        = list(string)
  default     = ["my-project:agent"]

  # validation {
  #   error_message = "Tags must match the regex `^([a-z]|[a-z][-a-z0-9]*[a-z0-9][:][a-z]|[a-z][-a-z0-9]*[a-z0-9])$`."
  #   condition = length([
  #     for name in var.tags :
  #     false if !can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9][:][a-z]|[a-z][-a-z0-9]*[a-z0-9])$", name))
  #   ]) == 0
  # }
}

variable "ibmcloud_api_key" {
  description = "The IBM Cloud API Key used to provision the schematics agent infrastructure resources. If not provided, then resources will be provisioned in currently logged in user account."
  type        = string
  sensitive   = true
  default     = ""
}

##############################################################################