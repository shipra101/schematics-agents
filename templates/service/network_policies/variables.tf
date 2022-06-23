###############################################################################
# IBM Confidential
# OCO Source Materials
# IBM Cloud Schematics
# (C) Copyright IBM Corp. 2022 All Rights Reserved.
# The source code for this program is not  published or otherwise divested of
# its trade secrets, irrespective of what has been deposited with
# the U.S. Copyright Office.
###############################################################################

variable "schematics_job_runtime" {
  description = "Schematics Job Runtime namespace"
  type        = string
  default     = "schematics-job-runtime"
}

variable "schematics_sandbox" {
  description = "Schematics Sandbox namespace"
  type        = string
  default     = "schematics-sandbox"
}

variable "schematics_runtime" {
  description = "Schematics Runtime namespace"
  type        = string
  default     = "schematics-runtime"
}