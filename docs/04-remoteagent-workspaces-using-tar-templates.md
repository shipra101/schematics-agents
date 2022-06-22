# Schematics Agents - Infrastructure and Micro-services Setup using TAR templates

## Introduction

Schematics Agent is an Experimental feature, this guide describes the steps to:

(A) setup your Cloud account and resources before deploying the Agent micro-services, using terraform templates in **TAR file format**.

(B) deploy Schematics Agents micro-services on the infrastructure created in the previous step, using terraform templates in **TAR file format**.

## Summary of steps

* Use the [`remoteagent-infrastructure-templates.tar`](https://github.ibm.com/schematics-solution/schematics-remote-agents/tree/master/tarfiles) to create a `Schematics Agents Infrastructure Workspace`.
* Use the `Schematics Agents Infrastructure Workspace` to provision the cloud resources.
* Use the [`remoteagent-service-templates.tar`](https://github.ibm.com/schematics-solution/schematics-remote-agents/tree/master/) to create a `Schematics Agents Runtime Services Workspace`.
* Use the `Schematics Agents Runtime Services Workspace` to deploy the Schematics Agent microservices.

## Pre-req

1. Refer [Pre-Reqs](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/docs/02-remoteagent-infrastructure-workspace.md#pre-req) for `Schematics Agents Infrastructure Workspace`.

- **Note: **Before starting with deploying the Schematics Agents micro-services, the `Schematics Agents Infrastructure Workspace` must be `ACTIVE`
  
2. Refer [Pre-Reqs](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/docs/03-remoteagent-service-workspace.md#pre-req) for `Schematics Agents Runtime Services Workspace`.

3. Install the latest [`ibmcloud schematics`](https://cloud.ibm.com/docs/schematics?topic=schematics-setup-cli) CLI plugin.

4. Login to your IBM Cloud Accout - `ibmcloud login`

5. Target your Resource group - `ibmcloud target -g RESOURCE_GROUP`

6. Verify the account, region and resource group details - `ibmcloud target`
   
   Sample output
   ```
   $ ibmcloud target

                      
    API endpoint:      https://cloud.ibm.com   
    Region:            us-south   
    User:              kgurudut@in.ibm.com   
    Account:           Kshama Gurudutt's Account (16a85b7b99a6622e7c186fb6503781a0) <-> 1952350   
    Resource group:    Default   
    CF API endpoint:      
    Org:                  
    Space:                
   ```

## Expected outcome:

Please refer to [Expected Outcome](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/docs/02-remoteagent-infrastructure-workspace.md#expected-outcome) for `Schematics Agents Infrastructure Workspace`.

Please refer to [Expected Outcome](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/docs/03-remoteagent-service-workspace.md#expected-outcome) for `Schematics Agents Runtime Services Workspace`

Note:
> In this experimental feature of Schematics Agent, it is possible to reuse an existing IKS cluster on VPC in your account.

## Steps for Schematics Agents Infrastructure Workspace :

1. **Create a new `Schematics Agents Infrastructure Workspace`**
   
   i. Have a look at the [sample JSON for workspace configuration](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/tarfiles/create_remoteagent_infra_workspace.json) and edit the values as given in the table.
   
| Input variable  | Description                          | Example         |
|---------------------------|--------------------------------------|-----------------|
| user_logdna_name          | enter a name for the new LogDNA instance | `remote-agent-logdna-demo` |
| user_resource_key_name    | enter a name of the key instance to be created and attached with cos bucket | `remote-agent-cos-key-demo` |
| user_cos_instance_name    | enter a name for the new COS instance | `remote-agent-cos-demo` |
| user_storage_bucket_name  | enter a name for the new COS bucket - name should be unique across users | `remote-agent-cos-bucket-demo` |
| user_resource_group_name  | enter name of Resource Group where infrastructure resources will be provisioned. If not specified, resources will be created under `Default` resource group | | 
| user_create_vpc           | true, to create a new VPC. <br/> false, to reuse an existing VPC | | 
| user_vpc_name             | enter the name of the new VPC that must be created in the `us-south` region (if user_create_vpc == true) | `remoteagent-vpc` |
| vpc_id                    | enter the existing VPC ID in the `us-south` region, that will be reused (if user_create_vpc == false) | |
| create_cluster            | true, to create a new IKS cluster on the VPC. <br/> false, to reuse an existing IKS on VPC, in the `us-south` region | |
| user_cluster_name         | enter the name of the new IKS cluster that must be created in VPC | `remoteagent-iks` |

   ii. Use the CLI command `ibmcloud schematics workspace new` and pass the sample JSON file to create a new workspace with an empty repository URL.

   ```
   $ ibmcloud schematics workspace new --file create_remoteagent_infra_workspace.json
    Creating workspace...

                   
    Creation Time   Wed Dec 22 14:37:14   
    Description     schematics agents infra workspace   
    Frozen          false   
    ID              us-east.workspace.schematics-agent-infra-workspace.89a3b7f5   
    Name            schematics-agent-infra-workspace   
    Status          DRAFT   
    Version         Terraform v0.13.7   
    Template ID     53a5cbf9-3b73-4f   
                    
    Variables 
    Name                       Value   
    user_logdna_name           remote-agent-logdna-test   
    user_resource_key_name     remote-agent-cos-key-test   
    user_cos_instance_name     remote-agent-cos-test   
    user_storage_bucket_name   remote-agent-cos-bucket-test   
    user_resource_group_name   Default   
    user_create_vpc            true   
    user_vpc_name              remoteagent-vpc-test   
    create_cluster             true   
    user_cluster_name          remoteagent-iks-test   
                            
    OK

   ```

   iii. Provide your Terraform template by uploading the `remoteagent-infrastructure-templates.tar` tape archive file (.tar) to your Schematics workspace by running the given command.
   ```
   $ ibmcloud schematics workspace upload --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5 --file <path_to_file>/remoteagent-infrastructure-templates.tar --template 53a5cbf9-3b73-4f
                   
    ID              53a5cbf9-3b73-4f   
    File Name       remoteagent-infrastructure-templates.tar   
    Upload Status   true   
   ```

   iv. Get Schematics Workspace `schematics-agent-infra-workspace` details by executing the command `$ ibmcloud schematics workspace get --id <workspace_id>` 
      - Note that the Workspace status will now be `INACTIVE`.
  
   v. Get Schematics Workspace `schematics-agent-infra-workspace` actions by executing the command `$ ibmcloud schematics workspace action --id <workspace_id>` 
      - Note that the `TAR_WORKSPACE_UPLOAD` action's status is `COMPLETED`
  
    ```
    $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5
    Action ID                          Name                   Status      Performed By          Performed At   
    97d94e81d433ecf855e179737fd6626f   TAR_WORKSPACE_UPLOAD   COMPLETED   kgurudut@in.ibm.com   2021-12-22 14:51:05.272404385 +0000 UTC   
                                        
    OK
    ```

2. **Provision the `Schematics Agents Infrastructure`**
   
   i. Run Schematics Workspace plan:  `$ ibmcloud schematics plan --id <workspace_id>` and get the plan activity logs to validate that terraform plan was completed successfully.
   ```
   $ ibmcloud schematics plan --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5
                 
    Activity ID   2b79dc8231d74d7aae87696760339778   
                    
    OK

    $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5 --act-id 2b79dc8231d74d7aae87696760339778
                    
    Action ID        2b79dc8231d74d7aae87696760339778   
    Name             PLAN   
    Status           COMPLETED   
    Status Message      
    Performed By     kgurudut@in.ibm.com   
    Performed At     2021-12-22 15:02:36.351513716 +0000 UTC   
                    
    Templates:
    Template ID        Template Type     Start Time                                End Time                                  Status      Message   
    53a5cbf9-3b73-4f   terraform_v0.13   2021-12-22 15:02:47.632816444 +0000 UTC   2021-12-22 15:03:27.482940954 +0000 UTC   COMPLETED   {"messagekey":"M2001_ActivitySuccessful","parms":{},"requestid":"897ac269-5343-4479-b52c-b433d44a9794","timestamp":"2021-12-22T15:03:27.482947079Z"}   
                    
    OK

    $ ibmcloud schematics logs --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5 --act-id 2b79dc8231d74d7aae87696760339778
    ...
     2021/12/22 15:03:22 Terraform plan | Plan: 13 to add, 0 to change, 0 to destroy.
    2021/12/22 15:03:22 Command finished successfully.
    2021/12/22 15:03:26 Done with the workspace action

    OK
   ```

   ii. Run Schematics Workspace apply:  `$ ibmcloud schematics apply --id <workspace_id>` and get the apply activity logs to validate that terraform apply was completed successfully.
   
        > Note: It will take about 35 to 45 minutes if VPC & IKS Cluster creation is set to `true`
    ```
    $ ibmcloud schematics apply --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5
    Do you really want to perform this action? [y/N]> y
                    
    Activity ID   f66ca66df251d34454b27a174c7d15ee   
                    
    OK

    $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5 --act-id f66ca66df251d34454b27a174c7d15ee
                    
    Action ID        f66ca66df251d34454b27a174c7d15ee   
    Name             APPLY   
    Status           COMPLETED   
    Status Message      
    Performed By     kgurudut@in.ibm.com   
    Performed At     2021-12-22 15:09:44.997267225 +0000 UTC   
                    
    Templates:
    Template ID        Template Type     Start Time                                End Time                                  Status      Message   
    53a5cbf9-3b73-4f   terraform_v0.13   2021-12-22 15:10:02.787472527 +0000 UTC   2021-12-22 15:35:32.764688691 +0000 UTC   COMPLETED   {"messagekey":"M2001_ActivitySuccessful","parms":{},"requestid":"09be6232-9db2-43f7-b94a-5b1c90f33792","timestamp":"2021-12-22T15:35:32.764692581Z"}   
                    
    OK

    $ ibmcloud schematics logs --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5 --act-id f66ca66df251d34454b27a174c7d15ee
    ...
     2021/12/22 15:35:24 Terraform apply | module.vpc_kubernetes_cluster[0].ibm_container_vpc_cluster.cluster: Creation complete after 23m56s [id=c71k09nd06ufjo838vcg]
    2021/12/22 15:35:24 Terraform apply | 
    2021/12/22 15:35:24 Terraform apply | Apply complete! Resources: 13 added, 0 changed, 0 destroyed.
    2021/12/22 15:35:24 Command finished successfully.
    2021/12/22 15:35:31 Done with the workspace action

    ```

   iii. Get Schematics Workspace `schematics-agent-infra-workspace` details by executing the command `$ ibmcloud schematics workspace get --id <workspace_id>` 
      - Note that the Workspace status will now be `ACTIVE`.
    ```
    $ ibmcloud schematics workspace get --id us-east.workspace.schematics-agent-infra-workspace.89a3b7f5
                   
    Creation Time   Wed Dec 22 14:37:14   
    Description     schematics agents infra workspace   
    Frozen          false   
    ID              us-east.workspace.schematics-agent-infra-workspace.89a3b7f5   
    Name            schematics-agent-infra-workspace   
    Status          ACTIVE   
    Version         Terraform v0.13.7   
    Template ID     53a5cbf9-3b73-4f   
    ```
  
3. **Review the provisioned `Schematics Agents Infrastructure`**
   1. Navigate to the IBM Cloud Resources Page - https://cloud.ibm.com/resources
   2. Filter by tags - `schematics:<workspace_ID>`
   3. Verify Resources
      - VPC Infrastructure : `remoteagent-vpc` > Status: `Available`
      - Services and Software : `remoteagent-logdna` > Status: `Active`
      - Storage: `remoteagent-cos` > Status: `Active`
      - Clusters: `remoteagent-iks` > Status: `Normal`

## Steps for Schematics Agents Runtime Services Workspace :

1. **Create a new `Schematics Agents Runtime Services Workspace`**
   
   i. Have a look at the [sample JSON for workspace configuration](https://github.ibm.com/schematics-solution/schematics-remote-agents/blob/master/tarfiles/create_remoteagent_service_workspace.json) and edit the values as given in the table.
   
| Input variables      | Description                             | Example             |
|----------------------|-----------------------------------------|---------------------|
| user_cluster_id      | enter the IKS Cluster ID created as part of the Infrastructure Workspace. |   |
| user_resource_group_id | enter the Resource Group **ID** where the IKS Cluster is provisioned. |   |
| registry_password    | enter your prod ibmcloud api key to pull schematics agent images and mark this as `Sensitive`. |  |
| LOGDNA_AGENT_KEY     | enter the ingestion key of the LogDNA instance that was created as part of Infrastructure Workspace and mark this as `Sensitive`. |  |
| JR_SCHEMATICSENDPOINT | enter the target Schematics API endpoint. <br/> Initially, target the **Schematics Stage API**, override with `https://us.schematics.test.cloud.ibm.com` <br/> For the Schematics Agent feature in production, we will switch to Schematics Production Private CSE endpoint. | `https://private-us-south.schematics.test.cloud.ibm.com` |
<!-- | JR_APIKEY            | enter your IBM Cloud APIKey and mark this as `Sensitive`. |  | -->
<!-- | JR_ACCOUNTID         | enter your IBM Cloud Account ID. |  |  -->
| JR_REGION            | enter the target region to deploy runtime services (should be same as IKS cluster region) |  |
| JOB_ENVIRONMENT      | This is set to default `stage` value. | `stage` |
| JOB_CMMODULESMACHINE | This is set to default stage global catalog endpoint. | `cm.globalcatalog.cloud.test.ibm.com` |

   ii. Use the `ibmcloud schematics workspace new` and pass the sample JSON file to create a new workspace with an empty repository URL.
   ```
   $ ibmcloud schematics workspace new --file create_remoteagent_service_workspace.json
   Creating workspace...
  
   Creation Time   Wed Dec 22 19:00:10   
   Description     schematics agents runtime services workspace   
   Frozen          false   
   ID              us-east.workspace.schematics-agent-service-workspace.49f99e9c   
   Name            schematics-agent-service-workspace   
   Status          DRAFT   
   Version         Terraform v0.13.7   
   Template ID     cc1b799d-c5e3-48   
                     
   Variables 
   Name                     Value   
   user_cluster_id          c71k09nd06ufjo838vcg   
   user_resource_group_id   47ecbb1f38ea4b8aa0a091edb1e4e909
   registry_password        Sensitive value stored on server      
   LOGDNA_AGENT_KEY         Sensitive value stored on server   
   JR_SCHEMATICSENDPOINT    https://us-south.schematics.test.cloud.ibm.com   
   JR_APIKEY                Sensitive value stored on server   
   # JR_ACCOUNTID             16a85b7b99a6622e7c186fb6503781a0   
   JR_REGION                us-south   
   JOB_ENVIRONMENT          stage   
   JOB_CMMODULESMACHINE     cm.globalcatalog.cloud.test.ibm.com   
                           
   OK
   ```

   iii. Provide your Terraform template by uploading the `remoteagent-service-templates.tar` tape archive file (.tar) to your Schematics workspace by running the given command.
   ```
   $ ibmcloud schematics workspace upload --id us-east.workspace.schematics-agent-service-workspace.49f99e9c --file <path_to_file>/remoteagent-service-templates.tar --template cc1b799d-c5e3-48
                     
   ID              cc1b799d-c5e3-48   
   File Name       remoteagent-service-templates.tar   
   Upload Status   true   
                     
   OK
   ```

   iv. Get Schematics Workspace `schematics-agent-service-workspace` details by executing the `$ ibmcloud schematics workspace get --id <workspace_id>` 
      - Note that the Workspace status will now be `INACTIVE`.
  
   v. Get Schematics Workspace `schematics-agent-service-workspace` actions by executing the `$ ibmcloud schematics workspace action --id <workspace_id>` 
      - Note that the `TAR_WORKSPACE_UPLOAD` action's status is `COMPLETED`
   ```
       $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-service-workspace.49f99e9c
   Action ID                          Name                   Status      Performed By          Performed At   
   8970c9257ec3129f42dbc1df6e9f7dc3   TAR_WORKSPACE_UPLOAD   COMPLETED   kgurudut@in.ibm.com   2021-12-22 19:02:35.193469638 +0000 UTC   
                                    
   OK
   ```
1. **Provision the `Schematics Agents Runtime Services`**
   
   i. Run Schematics Workspace plan:  `$ ibmcloud schematics plan --id <workspace_id>` and get the plan activity logs to validate that terraform plan was completed successfully.
   ```
   $ ibmcloud schematics plan --id us-east.workspace.schematics-agent-service-workspace.49f99e9c
                 
   Activity ID   cacaf173be7601fe50e4af85eb18b6f8   
                  
   OK


   $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-service-workspace.49f99e9c --act-id cacaf173be7601fe50e4af85eb18b6f8
                     
   Action ID        cacaf173be7601fe50e4af85eb18b6f8   
   Name             PLAN   
   Status           COMPLETED   
   Status Message      
   Performed By     kgurudut@in.ibm.com   
   Performed At     2021-12-22 19:05:07.452709688 +0000 UTC   
                  
   Templates:
   Template ID        Template Type     Start Time                                End Time                                  Status      Message   
   cc1b799d-c5e3-48   terraform_v0.13   2021-12-22 19:05:18.803351236 +0000 UTC   2021-12-22 19:06:02.300265323 +0000 UTC   COMPLETED   {"messagekey":"M2001_ActivitySuccessful","parms":{},"requestid":"8f30bc1e-3cb0-4ca1-beda-9fd9d884e62f","timestamp":"2021-12-22T19:06:02.300268189Z"}   
                     
   OK


    $ ibmcloud schematics logs --id us-east.workspace.schematics-agent-service-workspace.49f99e9c --act-id cacaf173be7601fe50e4af85eb18b6f8
 
    ...
   2021/12/22 19:05:57 Terraform plan | Plan: 18 to add, 0 to change, 0 to destroy.
   2021/12/22 19:05:57 Command finished successfully.
   2021/12/22 19:06:01 Done with the workspace action

   OK
   ```

   ii. Run Schematics Workspace apply:  `$ ibmcloud schematics apply --id <workspace_id>` and get the apply activity logs to validate that terraform apply was completed successfully.

        > Note: It will take about 10 to 15 minutes for the Schematics Remote Agent micro-services to be deployed on the target IKS cluster.
    ```
    $ ibmcloud schematics apply --id us-east.workspace.schematics-agent-service-workspace.49f99e9c
   Do you really want to perform this action? [y/N]> y
                  
   Activity ID   cacaf173be7601fe50e4af85eb78edab   
                  
   OK

   $ ibmcloud schematics workspace action --id us-east.workspace.schematics-agent-service-workspace.49f99e9c --act-id cacaf173be7601fe50e4af85eb78edab
                     
   Action ID        cacaf173be7601fe50e4af85eb78edab   
   Name             APPLY   
   Status           COMPLETED   
   Status Message      
   Performed By     kgurudut@in.ibm.com   
   Performed At     2021-12-22 19:09:41.901630393 +0000 UTC   
                  
   Templates:
   Template ID        Template Type     Start Time                                End Time                                  Status      Message   
   cc1b799d-c5e3-48   terraform_v0.13   2021-12-22 19:09:49.346015901 +0000 UTC   2021-12-22 19:17:39.855690419 +0000 UTC   COMPLETED   {"messagekey":"M2001_ActivitySuccessful","parms":{},"requestid":"5d1ae472-a485-425e-be48-99348687135f","timestamp":"2021-12-22T19:17:39.855698678Z"}   
                     
   OK

   $ ibmcloud schematics logs --id us-east.workspace.schematics-agent-service-workspace.49f99e9c --act-id cacaf173be7601fe50e4af85eb78edab
    ...
   2021/12/22 19:17:32 Terraform apply | Apply complete! Resources: 18 added, 0 changed, 0 destroyed.
   2021/12/22 19:17:32 Command finished successfully.
   2021/12/22 19:17:38 Done with the workspace action
    ```
   iii. Get Schematics Workspace `schematics-agent-service-workspace` details by executing the `$ ibmcloud schematics workspace get --id <workspace_id>` 
      - Note that the Workspace status will now be `ACTIVE`.
   ```
   $ ibmcloud schematics workspace get --id us-east.workspace.schematics-agent-service-workspace.49f99e9c
                     
   Creation Time   Wed Dec 22 19:00:10   
   Description     schematics agents runtime services workspace   
   Frozen          false   
   ID              us-east.workspace.schematics-agent-service-workspace.49f99e9c   
   Name            schematics-agent-service-workspace   
   Status          ACTIVE   
   Version         Terraform v0.13.7   
   Template ID     cc1b799d-c5e3-48   
   ```
  
2. **Review the provisioned `Schematics Agents Runtime Services`**
   1. Navigate to the target IBM Cloud Clusters Page - https://cloud.ibm.com/kubernetes/clusters/<target_iks_cluster_ID>
   2. Click on `Kubernetes Dashboard` > Redirected to Kubernetes Dashboard
   3. Verify Kubernetes Resources are created from the Kubernetes Dashboard
      - Pods (All namespaces)
        - job12 pods (3 instances - one on each worker node) > Status: `Running`
        - jobrunner pod (1 instance) > Status: `Running`
        - logdna-agent pods (3 instances - one on each worker node) > Status: `Running`
      - Service (All namespaces)
        - job-service12-clusterip
        - job-runner-loadbalancer
       - Config Maps (All namespaces)
         - schematics-job12-config
         - schematics-jobrunner-config
         - schematics-logdna-agent-config

## How to provision in EU-FR2 region
>Steps to be added - for eu-fr2 region

## Cleanup the Remote Agents Setup
Follow the given steps to cleanup the Remote Agents Setup

`ibmcloud schematics destroy --id <WORKSPACE_ID_remoteagent_runtime_services_workspace>`

`ibmcloud schematics workspace delete --id <WORKSPACE_ID_remoteagent_runtime_services_workspace>`

`ibmcloud schematics destroy --id <WORKSPACE_ID_remoteagent_infra_workspace>`

`ibmcloud schematics workspace delete --id <WORKSPACE_ID_remoteagent_infra_workspace>`


## Troubleshooting
>create/update/delete timeouts - 120m default

