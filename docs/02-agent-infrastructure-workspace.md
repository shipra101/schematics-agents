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
      - Specify Template - https://github.com/Cloud-Schematics/schematics-agents/tree/main/templates/infrastructure
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
| agent_prefix          | You will use this prefix, for vpc, cluster and  observability. (Max length 27 chars) | `my-project` |
| location    | Location of the agent infrastructure.  Note: For Beta, the agent must be deployed in a freshly provisioned VPC, IKS Cluster, Log Analysis instance. | `us-south` |
| resource_group_name  | enter name of Resource Group where infrastructure resources will be provisioned. | | 
| tags           |  A list of tags for the agent infrastructure | my-project:agent | 
| ibmcloud_api_key             | The IBM Cloud API Key used to provision the schematics agent infrastructure resources. If not provided, then resources will be provisioned in currently logged in user account. | |

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
      - VPC Infrastructure : `agent-vpc` > Status: `Available`
      - Services and Software : `agent-logdna` > Status: `Active`
      - Storage: `agent-cos` > Status: `Active`
      - Clusters: `agent-iks` > Status: `Normal`

## How to provision in EU-FR2 region
>Steps to be added - for eu-fr2 region

## Cleanup the Agents Infrastructure
Follow the given steps to cleanup the Agents Infrastructure
1. Open the Schematics Workspace - https://cloud.ibm.com/schematics/workspaces/<workspace_id_schematics-agent-infra-workspace>
2. Select `Actions` > `Destroy resources` > "Type the name of workspace" > Click `Destroy`
3. Workspace `schematics-agent-infra-workspace` page > **Jobs** tab
    - Wait for terraform destroy job to complete. It will take about 15 to 20 minutes.
    - Workspace `schematics-agent-infra-workspace` page > **Jobs** tab > *Destroy successful.* 
4. Note that the Workspace status will now be `INACTIVE`.
5. Select `Actions` > `Delete workspace` > "Type the name of workspace" > Click `Delete`

## Troubleshooting
>create/update/delete timeouts - 120m default

