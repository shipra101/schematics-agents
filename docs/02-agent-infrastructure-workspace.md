# Schematics Agents - Infrastructure setup

## Introduction

Schematics Agent is an Experimental feature, this guide describes the steps to setup your Cloud account and resources before deploying the Agent micro-services.

## Summary of steps

* Use the terraform template to create a `Schematics Agents Infrastructure Workspace`.
* Use the `Schematics Agents Infrastructure Workspace` to provision the cloud resources.

## Pre-req
- Your IBM Cloud Account must be a Paid Account, in order to provision resources like VPC and IKS Cluster.
- You must have permissions to provision these cloud resources - VPC, IKS, COS, COS bucket, Logging service
- Make a note of the corresponding Resource Group Name and Resource Group ID, where you would like to create the infrastructure resources

## Expected outcome:

The following IBM Cloud resources will be provisioned in your IBM Cloud Account, in the `us-south` region

* cos_instance
* cos_key
* cos_bucket
* logdna_instance
* logdna_key
* vpc (gen2)
* public_gateways (to attach to vpc - 1 per zone)
* subnets (to attach to vpc - 1 per zone)
* vpc_kubernetes_cluster

Note:
> In this experimental feature of Schematics Agent, it is possible to reuse an existing IKS cluster on VPC in your account.

## Steps:

1. **Create a new `Schematics Agents Infrastructure Workspace`**
   1. Login to IBM Cloud - https://cloud.ibm.com/
   2. Navigate to Schematics > Workspaces Create : https://cloud.ibm.com/schematics/workspaces/create
      - Specify Template - https://github.ibm.com/schematics-solution/schematics-remote-agents/tree/docs/templates/infrastructure
      - Select Terraform Version - `terraform_v0.13`
      - Click `Next`
      - Enter a Workspace Name - `schematics-agent-infra-workspace` (example)
      - Click `Next`
      - Click `Create`
      - You will be redirected to the Workspace `schematics-agent-infra-workspace` page.
   3. Workspace `schematics-agent-infra-workspace` page 
      - Navigate to **Jobs** tab > *Workspace creation successful.* 
      - Note that the Workspace status will now be `INACTIVE`.
   4. Workspace `schematics-agent-infra-workspace` page 
      - Navigate to **Settings** tab > Edit the workspace input variables as shown in the table

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


2. **Provision the `Schematics Agents Infrastructure`**
   1. Run Schematics Workspace plan:  In the Workspace `schematics-agent-infra-workspace` page 
      - Click `Generate Plan` button on the top right corner of the page
      - Open the **Jobs** tab > *Generate plan successful. 13 resources to add* 
   2. Run Schematics Workspace apply:  In the Workspace `schematics-agent-infra-workspace` page 
      - Click `Apply Plan` button on the top right corner of the page
      - Open the **Jobs** tab > Wait for terraform apply job to complete. 
        > Note: It will take about 35 to 45 minutes if VPC & IKS Cluster creation is set to `true`
      - Review the logs in the **Jobs** tab > *Apply plan successful.* 
   3. In the Workspace `schematics-agent-infra-workspace` settings page, the Workspace status will now be `ACTIVE`.
  
3. **Review the provisioned `Schematics Agents Infrastructure`**
   1. Navigate to the IBM Cloud Resources Page - https://cloud.ibm.com/resources
   2. Filter by tags - `schematics:<workspace_ID>`
   3. Verify Resources
      - VPC Infrastructure : `remoteagent-vpc` > Status: `Available`
      - Services and Software : `remoteagent-logdna` > Status: `Active`
      - Storage: `remoteagent-cos` > Status: `Active`
      - Clusters: `remoteagent-iks` > Status: `Normal`

## How to provision in EU-FR2 region
>Steps to be added - for eu-fr2 region

## Cleanup the Remote Agents Infrastructure
Follow the given steps to cleanup the Remote Agents Infrastructure
1. Open the Schematics Workspace - https://cloud.ibm.com/schematics/workspaces/<workspace_id_schematics-agent-infra-workspace>
2. Select `Actions` > `Destroy resources` > "Type the name of workspace" > Click `Destroy`
3. Workspace `schematics-agent-infra-workspace` page > **Jobs** tab
    - Wait for terraform destroy job to complete. It will take about 15 to 20 minutes.
    - Workspace `schematics-agent-infra-workspace` page > **Jobs** tab > *Destroy successful.* 
4. Note that the Workspace status will now be `INACTIVE`.
5. Select `Actions` > `Delete workspace` > "Type the name of workspace" > Click `Delete`

## Troubleshooting
>create/update/delete timeouts - 120m default

