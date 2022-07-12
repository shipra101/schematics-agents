# schematics-agents

The IBM Cloud Schematics Agents extends Schematics ability to reach your private, or on-premises, infrastructure. Integrate the Schematics Agents running in your private network to the IBM Cloud Schematics service to provision, configure, and operate your private or on-premise cloud cluster resources without any time, network, or software restrictions.

This Agent repository helps users to provision the infrastructure required for agent and deploys the services on the 
provisioned infrastructure.


# Prerequisites

1. Make sure that you are [assigned the correct permissions](https://cloud.ibm.com/docs/schematics?topic=schematics-access) to
    create the workspace and deploy resources.
2. Make sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/vpc?topic=vpc-managing-user-permissions-for-vpc-resources) to
    create and work with VPC infrastructure and you are [assigned the
    correct
    permissions](https://cloud.ibm.com/docs/schematics?topic=schematics-access) to
    create the workspace and deploy resources.
3. Make sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/containers?topic=containers-access_reference) to
    create and work with IBM Cloud Cluster.
4. Make sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/log-analysis?topic=log-analysis-iam) to
    create and work with IBM Log Analysis.
5. Make sure that you have the [required IBM Cloud IAM
    permissions](https://cloud.ibm.com/docs/activity-tracker?topic=activity-tracker-iam) to
    create and work with IBM Activity tracker.
6. The terraform version should be ~> 1.0
7. The terraform ibm provider version should be ~> 1.42


# Agents Deployment

This repository has tf configuration for Agent Infrastructure and service.

```
├── templates
|   └── infrastructure
|   └── service
```

### Infrastructure
    
This is an terraform configuration which provisions Agent Infrastructure on IBM Cloud.
A collection of services that will provisioned on IBM Cloud. Here are the list of services
- VPC
- IBM VPC Cluster
- IBM Log Analysis
- Activity Tracker

Link this repository to the schematics workspace and run `Generate Plan` and `Apply Plan` to create the agent infrastructure.
    

### Service

This contains terraform configuration which deploys Agent services on Infrastructure.
A collection of Agent-related microservices deployed on the Agent Infrastructure.  It is composed of the following microservices
    - Sandbox
    - runtime-job
    - Job runner
    
Link this repository to the schematics workspace and run `Generate Plan` and `Apply Plan` to deploy the agent services the agent infrastructure.

# Inputs

| name | description | type | required | default | sensitive |
| ---------- | -------- | -------------- | ---------- | ----------- | ----------- |
| agent_prefix | You will use this prefix, for vpc, cluster and  observability. (Max length 27 chars) |  |  | my-project |  |
| location | Location of the agent infrastructure.  Note: For Beta, the agent must be deployed in a freshly provisioned VPC, IKS Cluster, Log Analysis instance. |  |  | us-south |  |
| resource_group_name | Name of resource group used where agent infrastructure was provisioned. | string | &check; | |  |
| tags | A list of tags for the agent infrastructure | list(string) | | my-project:agent | |
| ibmcloud_api_key | The IBM Cloud API Key used to provision the schematics agent infrastructure resources. If not provided, then resources will be provisioned in currently logged in user account. | string | | | &check; |
| agent_name | Name of the agent. | string | | my-project | |
| location| Location of the agent services.  It must be the same as the agent infrastructure/cluster location. | string | | us-south | |
| resource_group_name | Name of resource group used where agent infrastructure was provisioned. | string | &check; | | |
| profile_id | The IBM Cloud IAM Trusted Profile ID which provides authorization for agents to process jobs. More info can be found [here](https://cloud.ibm.com/docs/account?topic=account-create-trusted-profile&interface=ui) | string | &check; | | &check; |
| schematics_endpoint_location | Location of the schematics endpoint. This location is used to connect your agent with schematics service. The valid locations are us/eu/us-south/us-east/eu-de/eu-gb | string | | us-south | |
| cluster_id | ID of the cluster used to run the agent service. | string | &check; | | |
| logdna_name | Name of the IBM Log Analysis service instance, used to send the agent logs. | string | &check; | | |
| ibmcloud_api_key | The IBM Cloud API Key used to deploy the schematics agent resources. If not provided, resources will be deployed using the logged in user credentials. | string | | | &check; |

# Next Steps

You have completed the Agent connection to your Schematics service instance.

    - Now, you need to Use an Agent to bind the Agent to your Workspace, in order to run the IaC automation in your cluster.
