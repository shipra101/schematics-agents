# IBM Cloud Logging and Monitoring

This module creates a LogDNA instance and a Sysdig Instance in a single region in a resource group. This module can optionally also provision activity tracker.

## Module Variables

Name                    | Type         | Description                                                                                                   | Default
----------------------- | ------------ | ------------------------------------------------------------------------------------------------------------- | ----------------------
enable_observability    | bool         | True to create new Observability Services. False if Observability Service instances are already existing. | |
prefix                  | string       | A unique identifier need to provision resources. Must begin with a letter                                     | my-project
region                  | string       | Region where resources will be created                                                                        | us-south
resource_group_id       | string       | ID of the resource group where instances will be created                                                      | 
tags                    | list(string) | A list of tags to be added to 
logdna_plan             | string       | Type of logdna and activity tracker plan. Can be `14-day`, `30-day`, `7-day`, or `hipaa-30-day`               | 7-day
create_activity_tracker | bool         | Create activity tracker. Only one instance of activity tracker can be provisioned per region in each account. | false
service_endpoints       | string       | Service endpoints. Can be `public`, `private`, or `public-and-private`                                        | private

## Example Usage

```hcl-terraform
module observability {
    source = "./observability"

    prefix                  = var.prefix
    region                  = var.loation
    resource_group_id       = data.ibm_resource_group.resource_group.id
    tags                    = var.tags
    sysdig_plan             = var.sysdig_plan
    logdna_plan             = var.logdna_plan
    create_activity_tracker = var.create_activity_tracker
}
```
