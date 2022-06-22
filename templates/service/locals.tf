#DONOT EDIT THIS FILE UNLESS YOU ARE SURE WHAT YOU ARE DOING

locals {
  #"IAM endpoint url"
  iam_url = "https://iam.cloud.ibm.com/"
  #IAM compatmode (false for stage/prod)
  iam_compatmode = "false"
  #Schematics endpoint url (optional: private CSE or VPE)
  schematics_endpoint = "https://private-${var.schematics_endpoint_location}.schematics.cloud.ibm.com"
  #Schematics agent jobrunner image ID
  schematics_jobrunner_image = "us.icr.io/schematics/schematics-job-runner:7d9ff119-142"
  #Schematics agent job12 image ID
  schematics_runtime_job_image = "us.icr.io/schematics/schematics-job_0.12.31:7e46e318-259"
  #schematics_sandbox_image
  schematics_sandbox_image = "us.icr.io/schematics/schematics-sandbox:3c73c85c-262"
  #Schematics environment (dev|stage|prod)
  schematics_environment = "Prod"
}

locals {
  #Config dir where the cluster config will be downloaded
  config_dir = "/tmp"
}