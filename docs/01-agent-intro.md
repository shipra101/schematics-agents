# Schematics Agents

**Schematics Agents** is a new experimental feature introduced by IBM Cloud Schematics that allows users to run automation workloads (Terraform, Ansible) on their own cloud infrastructure, thereby providing them more flexibility and control. 

The primary drivers for this feature are:

- I want to use Schematics & Satellite to deploy & configure my hybrid cloud resources (private cloud resources, private data center resources, other public cloud resources).
- I want Schematics to securely connect-to and manage my hybrid cloud infrastructure - using Terraform, Ansible, and other automation tools - to perform deployment, configuration, and day-2 operations.
- I do not want to wait in a shared Schematics queue, to run my automation.
- I want to configure my own time-restrictions while running the automation.
- I want a dedicated infrastructure to run my automation, and the ability to scale-up or scale-down the capacity depending on the automation workloads.
- I want the ability to fine-tune the Network policies (ingress, egress rules), used by Schematics to connect to my hybrid cloud infrastructure.
- I want flexibility to use my own softwares (and versions), in conjunction with automation engine provided by the Schematics runtime.

## Architecture

The following figure illustrates the components of Schematics Agent, and how it works with Schematics and your Cloud infrastructure.

![Agent bluering](agent-blueprint.png)

In order to run Schematics Agents in your Account, you have to setup the following 
1. Agent infrastructure components:
   * VPC
   * IBM Container Service (IKS) on VPC
   * Cloud Object Storage
   * IBM Log Analysis
2. Agent runtime service components
   * Schematics runtime services (Job Runner, Runtime-job)
   * Logging agents

Note: 
> Currently, the experimental feature requires the manual setup and configuration of the Schematics Agent.  
> In addition, the Agent infrastructure is deployed using the automation included in this package.

## Setup the Schematics Agents in your IBM Cloud Account

You can use the `Terraform automation` to setup the Schematics Agent.  It consists of two parts:
1. Provision and prepare the IBM Cloud infrastructure 
   * Multi-zone IKS Cluster on VPC
   * COS, COS buckets
   * Logging instance
2. Deploy Schematics Agents on the target infrastructure
   * Job runner
   * Terraform runtime-job
   * Ansible runtime-job (coming soon)
   
You can use Schematics workspaces, to run these Terraform automation:
1. Schematics Agents **Infrastructure Workspace**
2. Schematics Agents Runtime **Services Workspace**

### Use the Agent.tar file

The Terraform automation to deploy the `Agents Infrastructure` & `Agents Runtime Services` is packaged into a Agent.tar file.  Follow this guide - [04-agent-workspaces-using-tar-templates](https://github.com/Cloud-Schematics/schematics-agents/blob/main/docs/04-agent-workspaces-using-tar-templates.md) to use this tar file and create the `Schematics Agents Infrastructure Workspace` & `Schematics Agents Runtime Services Workspace`.  Further, you can use these workspaces the provision the Schematics Agent components.

### Use the Agent terraform templates

If you have access to the [Git repo to the Terraform template for Schematics Agent](https://github.com/Cloud-Schematics/schematics-agents/tree/main/templates), then follow these guides:
1. Create `Schematics Agents Infrastructure Workspace` - use this guide [02-agent-infrastructure-workspace](https://github.com/Cloud-Schematics/schematics-agents/blob/main/docs/02-agent-infrastructure-workspace.md)
2. Create `Schematics Agents Runtime Services Workspace` - use this guide [03-agent-service-workspace](https://github.com/Cloud-Schematics/schematics-agents/blob/main/docs/03-agent-service-workspace.md)

Further, you can use these workspace the provision the Schematics Agent components.

## Timeline
This Experimental / Internal Beta - is planned for January 2022.

