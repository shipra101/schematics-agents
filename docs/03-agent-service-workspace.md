# Schematics Agents - Runtime Service setup

## Introduction

Schematics Agent is an Experimental feature, this guide describes the steps to deploy Schematics Agents micro-services on the infrastructure created in previous [step](https://github.com/Cloud-Schematics/schematics-agents/blob/main/docs/02-agent-infrastructure-workspace.md) .

## Summary of steps

* Use the terraform template to create a `Schematics Agents Runtime Services Workspace`.
* Use the `Schematics Agents Runtime Services Workspace` to deploy the Schematics Agent microservices.

## Pre-req
* The `Schematics Agents Infrastructure Workspace` must be `ACTIVE` - Refer to [02-agent-infrastructure-workspace.md](https://github.com/Cloud-Schematics/schematics-agents/blob/main/docs/02-agent-infrastructure-workspace.md).
* You must have the required permissions to deploy microservices on the IKS cluster
* Make a note of the Resource Group ID in which the infrastructre resources were provisioned in previous step. To find the resource group ID: 
  - navigate to https://cloud.ibm.com/account/resource-groups. 
  - in the Resource groups page, you will observe the ID for the cluster's resource group name.
* Make note of `cluster_id` for the IKS Cluster provisioned in previous step. The Agents will be deployed onto this cluster
  - To find the cluster ID, navigate to https://cloud.ibm.com/kubernetes/clusters and click on the target cluster (eg: `agent-iks`). 
  - In the cluster's `Details` section, you will observe the  `Cluster ID` value. In the same `Details`, please make a note of the `Resource Group` name. 
* Make note of the LogDNA Ingestion Key from the LogDNA instance provisioned, as part of previous step
  - To find the logdna ingestion key, navigate to https://cloud.ibm.com/observe/logging and click on the target Logging instance (eg: `agent-logdna`). 
  - In the Logging instance Details Overview tab, select `Actions` dropdown > `View Key` > `Ingestion Key for agent-logdna`
* Make note of your Account Id and API Key associated with this account in test.cloud.ibm.com (Stage / YS1)
  - To find your stage account API Key, navigate to https://test.cloud.ibm.com/iam/apikeys > `My Cloud API Keys` View.
  - To find your stage account ID, navigate to https://test.cloud.ibm.com/account/settings > Account ID
* Access to IBM Cloud production account is sufficient, to access the Schematics Agent container images (jobrunner and job12) from the Container Registry `icr.io/schematics-remote`

## Expected outcome

The following Schematics Agent runtime resources will be provisioned in the **IKS Cluster**:
1. namespaces: 
   - schematics-job-runtime
   - schematics-runtime
   - schematics-ibm-observe
2. deployments:
   - jobrunner (schematics-job-runtime namespace)
   - job12 (schematics-runtime namespace)
3. daemonsets:
   - logdna-agent (schematics-ibm-observe namespace)
4. secrets:
   - schematics-jobrunner-image-secret (schematics-job-runtime namespace)
   - schematics-job12-image-secret (schematics-runtime namespace)
   - logdna-agent-token (schematics-ibm-observe namespace)
5. configmaps:
   - schematics-jobrunner-config (schematics-job-runtime namespace)
   - schematics-job12-config (schematics-runtime namespace)
   - schematics-logdna-agent-config (schematics-ibm-observe namespace)
6. services:
   - job-runner-loadbalancer (schematics-job-runtime namespace)
   - job-service-12-clusterip (schematics-runtime namespace)
7. serviceaccount:
   - logdna-agent (schematics-ibm-observe namespace)
8. cluster role and bindings:
   - logdna-agent (schematics-ibm-observe namespace)

## Steps:

1. **Create a new `Schematics Agents Runtime Service Workspace`**
   1. Login to IBM Cloud - https://cloud.ibm.com/
   2. Navigate to Schematics > Workspaces Create : https://cloud.ibm.com/schematics/workspaces/create
      - Select existing template - https://github.com/Cloud-Schematics/schematics-agents/tree/main/templates/service
      - Select Terraform Version - `terraform_v0.13`
      - Click `Next`
      - Enter a Workspace Name - `schematics-service-workspace` (example)
      - Click `Next`
      - Click `Create`
      - You will be redirected to the Workspace `schematics-service-workspace` page.
   3. Workspace `schematics-service-workspace` page 
      - Navigate to the **Jobs** tab > *Workspace creation successful.* 
      - Note that the Workspace status will now be `INACTIVE`.
   4. Workspace `schematics-service-workspace` page 
      - Navigate to the **Settings** tab > Edit the input variables as shown in the table.

| Input variables      | Description                             | Example             |
|----------------------|-----------------------------------------|---------------------|
| cluster_id      | enter the IKS Cluster ID created as part of the Infrastructure Workspace. |   |
| resource_group_name | enter the Resource Group **Name** where the IKS Cluster is provisioned. |   |
| profile_id | The IBM Cloud IAM Trusted Profile ID which provides authorization for agents to process jobs. More info can be found [here](https://cloud.ibm.com/docs/account?topic=account-create-trusted-profile&interface=ui) | |
| schematics_endpoint_location            | Location of the schematics endpoint. This location is used to connect your agent with schematics service. The valid locations are us/eu/us-south/us-east/eu-de/eu-gb. | us |
| logdna_name         | Name of the IBM Log Analysis service instance, used to send the agent logs. |  | 
| ibmcloud_api_key            | The IBM Cloud API Key used to deploy the schematics agent resources. If not provided, resources will be deployed using the logged in user credentials. |  |

1. **Provision the `Schematics Agents Runtime Service`**
   1. Run Schematics Workspace plan: In the Workspace `schematics-agent-service-workspace` page 
      - Click `Generate Plan` button on the top right corner of the page
      - Open the **Jobs** tab > *Generate plan successful. 18 resources to add* 
   2. Run Schematics Workspace apply: In the Workspace `schematics-agent-service-workspace` page 
      - Click `Apply Plan` button on the top right corner of the page
      - Open the **Jobs** tab > Wait for terraform apply job to complete. 
        > Note: It will take about 10 to 15 minutes.
      - Review the **Jobs** tab > *Apply plan successful.* 
   3. In the Workspace `schematics-agent-service-workspace` settings page, the Workspace status will now be `ACTIVE`.
  
2. **Review the provisioned `Schematics Agents Runtime Service`**
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
>Steps to be added - for non-default RG and eu-fr2 Schematics API endpoint.

## Cleanup the Agents Runtime Services
Follow the given steps to cleanup the Agents Runtime Services
1. Open the Schematics Workspace - https://cloud.ibm.com/schematics/workspaces/<workspace_id_schematics-service-workspace>
2. Select `Actions` > `Destroy resources` > "Type the name of workspace" > Click `Destroy`
3. Workspace `schematics-service-workspace` page > **Jobs** tab
    - Wait for terraform destroy job to complete. It will take about 10 to 15 minutes.
    - Workspace `schematics-service-workspace` page > **Jobs** tab > *Destroy successful.* 
4. Note that the Workspace status will now be `INACTIVE`.
5. Select `Actions` > `Delete workspace` > "Type the name of workspace" > Click `Delete`

## Troubleshooting




