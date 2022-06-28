# IBM Cloud Schematics Agent Services

This is an terraform configuration which deploys Agent services on Infrastructure.

## What will this do?

This is a Terraform configuration that will deploy Agent Services
- Sandbox
- runtime
- Job runner
 
Link this repository to the schematics workspace and run `Generate Plan` and `Apply Plan` to deploy the agent services the agent infrastructure.


## Prerequisites

1. Make sure that you are [assigned the correct permissions](https://cloud.ibm.com/docs/schematics?topic=schematics-access) to
    create the workspace and deploy resources.
2. The terraform version should be ~> 1.0
3. The terraform ibm provider  version should be ~> 1.42

## Inputs

| name | description | type | required | default | sensitive |
| ---------- | -------- | -------------- | ---------- | ----------- | ----------- |
| agent_name | Name of the agent. | string | | my-project | |
| location| Location of the agent services.  It must be the same as the agent infrastructure/cluster location. | string | | us-south | |
| resource_group_name | Name of resource group used where agent infrastructure was provisioned. | string | &check; | | |
| profile_id | The IBM Cloud IAM Trusted Profile ID which provides authorization for agents to process jobs. More info can be found [here](https://cloud.ibm.com/docs/account?topic=account-create-trusted-profile&interface=ui) | string | &check; | | &check; |
| schematics_endpoint_location | Location of the schematics endpoint. This location is used to connect your agent with schematics service. The valid locations are us/eu/us-south/us-east/eu-de/eu-gb | string | | us-south | |
| cluster_id | ID of the cluster used to run the agent service. | string | &check; | | |
| logdna_name | Name of the IBM Log Analysis service instance, used to send the agent logs. | string | &check; | | |
| ibmcloud_api_key | The IBM Cloud API Key used to deploy the schematics agent resources. If not provided, resources will be deployed using the logged in user credentials. | string | | | &check; |


## How to deploy Agent Services using Schematics

1.  From the IBM Cloud menu
    select [Schematics](https://cloud.ibm.com/schematics/overview).
       - enter the URL of this example in the Schematics examples Github repository.
       - Click Next
       - Enter a name for your workspace.
       - Select the Terraform version: Terraform 1.0 or higher
       - Click Next to review   
       - Click Create to create your workspace.
2.  On the workspace **Settings** page, 
     - In the **Input variables** section, review the default input
        variables and provide alternatives if desired. The only
        mandatory parameter is the name given to the Resource group.
      - Click **Save changes**.

4.  From the workspace **Settings** page, click **Generate plan** 
5.  Click **View log** to review the log files of your Terraform
    execution plan.
6.  Apply your Terraform template by clicking **Apply plan**.
7.  Review the log file to ensure that no errors occurred during the
    provisioning, modification, or deletion process.
