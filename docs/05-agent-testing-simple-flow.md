# Testing Schematics Agents Feature Using Simple Terraform Template

## Introduction
Schematics Agent is an Experimental feature, this guide describes the steps to test this feature by creating a Schematics Workspace with a speacial tag, and pointing it to a simple terraform template repository.

## Summary of steps
1. Create a Schematics Workspace with tag **"schematics:remote"** and point it to a simple terraform repository.
2. Generate the Plan for the Schematics Workspace.
3. Apply the Plan for the Schematics Workspace.
4. Destroy the resources created by the Schematics Workspace.

## Pre-req
A) The `Schematics Agents Infrastructure Workspace` must be `ACTIVE` - Refer to the guide [02-remoteagent-infrastructure-workspace.md](https://github.com/Cloud-Schematics/schematics-agents/blob/develop/docs/02-agent-infrastructure-workspace.md).

B) The `Schematics Agents Runtime Services Workspace` must be `ACTIVE` - Refer to the guide [03-remoteagent-service-workspace.md](https://github.com/Cloud-Schematics/schematics-agents/blob/develop/docs/03-agent-service-workspace.md).

## Expected outcome:
1. The plan workload will be run in **your** IKS Cluster that was created as part of the **Schematics Agents Setup.**
2. The apply workload will be run in **your** IKS Cluster that was created as part of the **Schematics Agents Setup.**
3. The destroy workload will be run in **your** IKS Cluster that was created as part of the **Schematics Agents Setup.**
4. The workload logs (plan/apply/destroy) will be visible in **your** LogDNA instance, that was created as part of the **Schematics Agents Setup.**

## Steps:
1. Login to IBM Cloud Stage - https://test.cloud.ibm.com/schematics/workspaces/create
2. Create a Schematics Workspace with these details
    - Repository URL - `https://github.com/KshamaG/tf_cloudless_sleepy13_public`
    - Terraform Version - `terraform_v0.13`
    - Workspace Name - `test-remoteagent-workspace`
    - Tags - `schematics:remote`
3. Once the Schematics Workspace is created, it will be in `INACTIVE` state.
4. From the Workspace Details page, click on `Generate Plan` button.
    - Navigate to the **Jobs** tab > *Generate plan successful.* 
    - The Plan Job logs will display activity `action=Plan`
    - The Plan Job logs will display activity processed by job runner, where the job runner pod name will be the one running in your IKS cluster (`schematics-job-runtime` namespace) that is part of **Schematics Agents Setup.**
    - The Plan Job logs will display activity processed by job12, where the job12 pod name will be the one running in your IKS cluster (`schematics-runtime` namespace) that is part of **Schematics Agents Setup.**
5. From the Workspace Details page, click on `Apply Plan` button.
    - Navigate to the **Jobs** tab > *Apply plan successful.* 
    - The Apply Job logs will display activity `action=Apply`
    - The Apply Job logs will display activity processed by job runner, where the job runner pod name will be the one running in your IKS cluster (`schematics-job-runtime` namespace) that is part of **Schematics Agents Setup.**
    - The Apply Job logs will display activity processed by job12, where the job12 pod name will be the one running in your IKS cluster (`schematics-runtime` namespace) that is part of **Schematics Agents Setup.**
    - The Apply job will display `terraform apply` output as given here 
   ```
    2022/01/06 05:34:49 Starting command: terraform13 apply -state=terraform.tfstate -var-file=schematics.tfvars -auto-approve -no-color -lock=false
    2022/01/06 05:34:52 Terraform apply | data.template_file.test: Refreshing state...
    2022/01/06 05:34:54 Terraform apply | null_resource.sleep: Creating...
    2022/01/06 05:34:54 Terraform apply | null_resource.sleep: Provisioning with 'local-exec'...
    2022/01/06 05:34:54 Terraform apply | null_resource.sleep (local-exec): Executing: ["/bin/sh" "-c" "sleep 5"]
    2022/01/06 05:34:59 Terraform apply | null_resource.sleep: Creation complete after 5s [id=4604054167449299867]
    2022/01/06 05:34:59 Terraform apply | 
    2022/01/06 05:34:59 Terraform apply | Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    2022/01/06 05:34:59 Terraform apply | 
    2022/01/06 05:34:59 Terraform apply | Outputs:
    2022/01/06 05:34:59 Terraform apply | 
    2022/01/06 05:34:59 Terraform apply | rendered_template = Hello, I am a template. My sample_var value = hello-sample
    2022/01/06 05:34:59 Command finished successfully.
   ```
    - Note that the Workspace status will now be `ACTIVE`.
6. From the Workspace Details page, click on `Actions` > `Destroy resources` > `Destroy` button.
    - Navigate to the **Jobs** tab > *Workspace destroy successful.* 
    - The Destroy Job logs will display activity `action=Destroy`
    - The Destroy Job logs will display activity processed by job runner, where the job runner pod name will be the one running in your IKS cluster (`schematics-job-runtime` namespace) that is part of **Schematics Agents Setup.**
    - The Destroy Job logs will display activity processed by job12, where the job12 pod name will be the one running in your IKS cluster (`schematics-runtime` namespace) that is part of **Schematics Agents Setup.**
    - The Destroy job will display `terraform destroy` output as given here 
   ```
    2022/01/06 05:44:53 Starting command: terraform13 destroy -state=terraform.tfstate -var-file=schematics.tfvars -force -lock=false -no-color
    2022/01/06 05:44:55 Terraform destroy | data.template_file.test: Refreshing state... [id=d6042f8b7271ecb87b73a42dcfeaf7b7d92c19a6b765e6f4bbf69be00673b321]
    2022/01/06 05:44:55 Terraform destroy | null_resource.sleep: Refreshing state... [id=4604054167449299867]
    2022/01/06 05:44:57 Terraform destroy | null_resource.sleep: Destroying... [id=4604054167449299867]
    2022/01/06 05:44:57 Terraform destroy | null_resource.sleep: Destruction complete after 0s
    2022/01/06 05:44:57 Terraform destroy | 
    2022/01/06 05:44:57 Terraform destroy | Destroy complete! Resources: 1 destroyed.
   ```

## Viewing the workload logs in your Schematics Agents Setup
1. Navigate to the LogDNA instance created as part of **Schematics Agents Setup.** in your IBM Cloud production account.
   - Logging page - https://cloud.ibm.com/observe/logging
   - Click on `agent-logdna` instance
   - From the logging instance overview page, click on `Open Dashboard` button
2. From the LogDNA instance logs view page, validate the jobrunner logs.
   - Filter App > `jobrunner` 
     - Verify plan/apply/destroy job related activities are logged. 
     - Sample log extract
    ```
    Jan 5 14:51:11 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-05T09:21:11.447Z","caller":"workspacemanager/workspace_processor.go:107","msg":"New action request ","component":"job-runner","RequestId":"314ff563-8452-4597-a907-6b5117998189","HandlerId":"jobrunner-686dc67d8c-rzd7h","Action Name:":"PLAN"}
    Jan 5 14:51:11 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-05T09:21:11.448Z","caller":"workspacemanager/workspace_processor.go:214","msg":"Executing the command","component":"job-runner","RequestId":"314ff563-8452-4597-a907-6b5117998189","HandlerId":"jobrunner-686dc67d8c-rzd7h","action":"PLAN"} 
    Jan 5 14:51:12 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-05T09:21:12.409Z","caller":"workspacemanager/job_cmd.go:220","msg":"GOT the post file response: ","component":"job-runner","RequestId":"314ff563-8452-4597-a907-6b5117998189","HandlerId":"jobrunner-686dc67d8c-rzd7h","response":"JobID:{ID:\"job12-75cb5d994b-ng5hz\"}  Status:{State:COMPLETE}  Error:{Message:\"Upload received with success\"  Code:Ok}"} 


    Jan 6 11:04:41 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:34:41.249Z","caller":"workspacemanager/workspace_processor.go:107","msg":"New action request ","component":"job-runner","RequestId":"c01900ff-9d69-47ec-aebb-d248c76b3d7c","HandlerId":"jobrunner-686dc67d8c-rzd7h","Action Name:":"APPLY"}
    Jan 6 11:04:41 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:34:41.249Z","caller":"workspacemanager/workspace_processor.go:214","msg":"Executing the command","component":"job-runner","RequestId":"c01900ff-9d69-47ec-aebb-d248c76b3d7c","HandlerId":"jobrunner-686dc67d8c-rzd7h","action":"APPLY"} 
    Jan 6 11:04:41 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:34:41.928Z","caller":"workspacemanager/job_cmd.go:220","msg":"GOT the post file response: ","component":"job-runner","RequestId":"c01900ff-9d69-47ec-aebb-d248c76b3d7c","HandlerId":"jobrunner-686dc67d8c-rzd7h","response":"JobID:{ID:\"job12-75cb5d994b-ng5hz\"}  Status:{State:COMPLETE}  Error:{Message:\"Upload received with success\"  Code:Ok}"} 


    Jan 6 11:14:41 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:44:41.393Z","caller":"workspacemanager/workspace_processor.go:107","msg":"New action request ","component":"job-runner","RequestId":"0ebffdee-5a26-4d35-a66e-2004ffb47df4","HandlerId":"jobrunner-686dc67d8c-rzd7h","Action Name:":"DESTROY"}
    Jan 6 11:14:41 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:44:41.394Z","caller":"workspacemanager/workspace_processor.go:214","msg":"Executing the command","component":"job-runner","RequestId":"0ebffdee-5a26-4d35-a66e-2004ffb47df4","HandlerId":"jobrunner-686dc67d8c-rzd7h","action":"DESTROY"} 
    Jan 6 11:14:42 jobrunner-686dc67d8c-rzd7h jobrunner info {"level":"info","utc_date":"2022-01-06T05:44:42.337Z","caller":"workspacemanager/job_cmd.go:220","msg":"GOT the post file response: ","component":"job-runner","RequestId":"0ebffdee-5a26-4d35-a66e-2004ffb47df4","HandlerId":"jobrunner-686dc67d8c-rzd7h","response":"JobID:{ID:\"job12-75cb5d994b-ng5hz\"}  Status:{State:COMPLETE}  Error:{Message:\"Upload received with success\"  Code:Ok}"} 

    ```
3. From the LogDNA instance logs view page, validate the job12 logs.
   - Filter App > `job12` 
     - Verify plan/apply/destroy job related activities are logged. 
     - Sample log extract
    ```
    Jan 5 14:51:20 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-05T09:21:20.018Z","caller":"cmd/terraform_job.go:313","msg":"Entry:terraformAction","component":"SCHEMATICS-JOB","requestid":"314ff563-8452-4597-a907-6b5117998189","Action":"plan","options":["-input=false","-refresh=true","-state=terraform.tfstate","-var-file=schematics.tfvars","-no-color","-lock=false"]}
    Jan 5 14:51:20 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-05T09:21:20.018Z","caller":"cmd/terraform_job.go:363","msg":"TFVersion is","component":"SCHEMATICS-JOB","requestid":"314ff563-8452-4597-a907-6b5117998189","tfVersion":"terraform_v0.13"} 
    Jan 5 14:51:23 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-05T09:21:23.398Z","caller":"cmd/terraform_job.go:523","msg":"Finished command: terraform13 plan -input=false -refresh=true -state=terraform.tfstate -var-file=schematics.tfvars -no-color -lock=false","component":"SCHEMATICS-JOB","requestid":"314ff563-8452-4597-a907-6b5117998189"} 


    Jan 6 11:04:49 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:34:49.939Z","caller":"cmd/terraform_job.go:313","msg":"Entry:terraformAction","component":"SCHEMATICS-JOB","requestid":"c01900ff-9d69-47ec-aebb-d248c76b3d7c","Action":"apply","options":["-state=terraform.tfstate","-var-file=schematics.tfvars","-auto-approve","-no-color","-lock=false"]}
    Jan 6 11:04:49 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:34:49.939Z","caller":"cmd/terraform_job.go:363","msg":"TFVersion is","component":"SCHEMATICS-JOB","requestid":"c01900ff-9d69-47ec-aebb-d248c76b3d7c","tfVersion":"terraform_v0.13"} 
    Jan 6 11:04:59 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:34:59.235Z","caller":"cmd/terraform_job.go:523","msg":"Finished command: terraform13 apply -state=terraform.tfstate -var-file=schematics.tfvars -auto-approve -no-color -lock=false","component":"SCHEMATICS-JOB","requestid":"c01900ff-9d69-47ec-aebb-d248c76b3d7c"} 

    Jan 6 11:14:53 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:44:53.183Z","caller":"cmd/terraform_job.go:313","msg":"Entry:terraformAction","component":"SCHEMATICS-JOB","requestid":"0ebffdee-5a26-4d35-a66e-2004ffb47df4","Action":"destroy","options":["-state=terraform.tfstate","-var-file=schematics.tfvars","-force","-lock=false","-no-color"]}
    Jan 6 11:14:53 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:44:53.183Z","caller":"cmd/terraform_job.go:363","msg":"TFVersion is","component":"SCHEMATICS-JOB","requestid":"0ebffdee-5a26-4d35-a66e-2004ffb47df4","tfVersion":"terraform_v0.13"} 
    Jan 6 11:14:57 job12-75cb5d994b-ng5hz job12 info {"level":"info","utc_date":"2022-01-06T05:44:57.678Z","caller":"cmd/terraform_job.go:523","msg":"Finished command: terraform13 destroy -state=terraform.tfstate -var-file=schematics.tfvars -force -lock=false -no-color","component":"SCHEMATICS-JOB","requestid":"0ebffdee-5a26-4d35-a66e-2004ffb47df4"} 
    ```

## Cleanup the Agent Test Workspace
To delete the `test-agent-workspace` Schematics Workspace : From the Workspace Details page, click on `Actions` > `Delete workspace` > `Delete` button.

## Troubleshooting
