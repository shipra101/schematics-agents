# IBM Cloud Kubernetes Cluster

This module creates a Kubernetes cluster with one worker pool of 3 zones, one worker in each zone.

## Module Variables

Name                    | Type         | Description                                                                                                   | Default
----------------------- | ------------ | ------------------------------------------------------------------------------------------------------------- | ----------------------
create_cluster          | bool         | Enable this to provision VPC cluster. | true
prefix                  | string       | A unique identifier need to provision resources. Must begin with a letter | my-project
region                  | string       | Region where resources will be created | us-south
resource_group_id       | string       | ID of the resource group where instances will be created | 
tags                    | list(string) | A list of tags to be added to resources   | [ "my-project:agent" ]
worker_pools            | list(object) | List of maps describing worker pools       | []
cos_id | string         | ID of COS instance | null
kms_guid       | string       | GUID of Key Protect Instance    | null
key_id | string | GUID of User Managed Key | null
machine_type | string | The flavor of VPC worker node to use for your cluster. Use `ibmcloud ks flavors` to find flavors for a region. | bx2.4x16
workers_per_zone | number | Number of workers to provision in each subnet | 1
kube_version | string | Specify the Kubernetes version, including the major.minor version. To see available versions, run `ibmcloud ks versions`. | 4.9.21_openshift
wait_till | string | To avoid long wait times when you run your Terraform code, you can specify the stage when you want Terraform to mark the cluster resource creation as completed. Depending on what stage you choose, the cluster creation might not be fully completed and continues to run in the background. However, your Terraform code can continue to run without waiting for the cluster to be fully created. Supported args are `MasterNodeReady`, `OneWorkerNodeReady`, and `IngressReady` | IngressReady


## Example Usage

```hcl-terraform
module "vpc_cluster" {
  create_cluster = var.create_cluster
  source         = "./cluster"
  # Account Variables
  prefix            = var.prefix
  region            = var.region
  resource_group_id = data.ibm_resource_group.resource_group.id
  # VPC Variables
  vpc_id  = module.multizone_vpc[0].vpc_id
  subnets = module.multizone_vpc[0].subnet_tier_list["vpc"]
  # Cluster Variables
  machine_type     = var.machine_type
  workers_per_zone = var.workers_per_zone
  kube_version     = var.kube_version #local.latest
  tags             = var.tags
  worker_pools     = var.worker_pools
}
```
