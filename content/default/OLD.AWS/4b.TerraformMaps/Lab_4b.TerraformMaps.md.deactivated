---
title:  Lab 4b.TerraformMaps
date:   1673275420
weight: 42
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we learn how to create and use terraform maps. Maps are key/value pairs which we can create and look up as we need to in our templates.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4b’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf vars.tf.

The main.tf file should contain:

The provider.tf file should contain:


```bash
cat provider.tf
```

    
    terraform {
      required_version = ">= 1.1.0"
    
      required_providers {
        aws = {
          version = "~> 4.0"
        }
      }
    }
    
    provider "aws" {
      region = var.region
    
      default_tags {
        tags = {
          Environment = "Terraform Introduction"
        }
      }
    }
    


The resources.tf file should contain:


```bash
cat resources.tf
```

    
    resource "aws_vpc" "main_vpc" {
      cidr_block       = var.vpc_cidr
      instance_tenancy = "default"
    
      tags = {
        Name           = "Main"
        Location       = "London"
        LabName        = "4b.TerraformMaps"
      }
    }
    
    resource "aws_subnet" "vpc_subnets" {
      count = length(var.vpc_subnet_cidr)
    
      vpc_id             = aws_vpc.main_vpc.id
    
      #cidr_block        = element(var.vpc_subnet_cidr,count.index)
      cidr_block         = var.vpc_subnet_cidr[count.index]
    
      #availability_zone = element(var.aaz[var.region],count.index)
      availability_zone  = var.aaz[var.region][count.index]
    
      tags = {
        Name = "subnet-${count.index+1}"
        LabName = "4b.TerraformMaps"
      }
    }


and your vars.tf file should contain:


```bash
cat vars.tf
```

    
    variable "region" {
      default = "us-west-1"
    }
    variable "vpc_cidr" {
      default = "192.168.0.0/16"
    }
    variable "vpc_subnet_cidr" {
      type = list
      # Reduced to 2-elements each due to non-availability of us-west-1a:
      #default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
      default = ["192.168.101.0/24","192.168.102.0/24"]
    }
    variable "ami_instance" {
      type = map
      default = {
        "us-east-1" = "ami-0ac019f4fcb7cb7e6"
        "us-east-2" = "ami-0f65671a86f061fcd"
        "us-west-1" = "ami-063aa838bd7631e0b"
      }
    }
    variable "ami_instance_type" {
      default = "t2.micro"
    }
    variable "aaz" {
      type = map
      default = {
        #"us-east-1" = ["us-east-1a","us-east-1b","us-east-1c"]
        #"us-east-2" = ["us-east-2a","us-east-2b","us-east-2c"]
        #"us-west-1" = ["us-west-1a","us-west-1b","us-west-1c"]
    
        # Reduced to 2-elements each due to non-availability of us-west-1a:
        #"us-east-1" = ["us-east-1b","us-east-1c"]
        #"us-east-2" = ["us-east-2b","us-east-2c"]
        "us-west-1" = ["us-west-1b","us-west-1c"]
      }
    } 


You may copy the outputs.tf file you used for the previous lab to see the output.

<!-- data "aws_availability_zones" "aaz" {} -->

### 4. Study the configuration files

Study the configuration files, taking the time to understand

* the use of the "vpc_subnet_cidr" list variable

* the use of the "ami_instance" map variable

* the use of the "aaz" map variable

- why we need to modify the list/map dimensions when an availability zone is not available

### 5. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>

![](graph.svg)

### 6. Initialize the configuration

This time we will set the TF_LOG variable to TRACE to see debugging output: ```TF_LOG=TRACE terraform init```


```bash
TF_LOG=TRACE terraform init
```

    2023-01-09T14:44:37.219Z [INFO]  Terraform version: 1.3.7
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/go-tfe v1.9.0
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/hcl/v2 v2.15.0
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/terraform-config-inspect v0.0.0-20210209133302-4fd17a0faac2
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/terraform-svchost v0.0.0-20200729002733-f050f53b9734
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/zclconf/go-cty v1.12.1
    2023-01-09T14:44:37.219Z [INFO]  Go runtime version: go1.19.4
    2023-01-09T14:44:37.219Z [INFO]  CLI args: []string{"terraform", "init"}
    2023-01-09T14:44:37.219Z [TRACE] Stdout is a terminal of width 80
    2023-01-09T14:44:37.219Z [TRACE] Stderr is a terminal of width 80
    2023-01-09T14:44:37.219Z [TRACE] Stdin is a terminal
    2023-01-09T14:44:37.219Z [DEBUG] Attempting to open CLI config file: /home/student/.terraformrc
    2023-01-09T14:44:37.219Z [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /home/student/.terraform.d/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /home/student/.local/share/terraform/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins
    2023-01-09T14:44:37.220Z [INFO]  CLI command args: []string{"init"}
    
    Initializing the backend...
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
    2023-01-09T14:44:37.227Z [DEBUG] New state was assigned lineage "f09f94a4-3674-ef40-02a9-a8311b6dd837"
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: instantiated backend of type <nil>
    2023-01-09T14:44:37.227Z [DEBUG] checking for provisioner in "."
    2023-01-09T14:44:37.228Z [DEBUG] checking for provisioner in "/home/student/bin"
    2023-01-09T14:44:37.228Z [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
    2023-01-09T14:44:37.228Z [TRACE] backend/local: state manager for workspace "default" will:
     - read initial snapshot from terraform.tfstate
     - write new snapshots to terraform.tfstate
     - create any backup at terraform.tfstate.backup
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: read nil snapshot
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.0"...
    2023-01-09T14:44:37.228Z [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
    2023-01-09T14:44:37.228Z [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
    2023-01-09T14:44:37.341Z [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
    2023-01-09T14:44:37.341Z [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: scanning directory /home/student/dot.terraform/providers
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v4.49.0 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.2.3 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 4.49.0
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.2.3
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
    2023-01-09T14:44:37.410Z [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/4.49.0/download/linux/amd64
    2023-01-09T14:44:37.410Z [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/4.49.0/download/linux/amd64
    2023-01-09T14:44:37.474Z [DEBUG] GET https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS
    2023-01-09T14:44:37.474Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS
    2023-01-09T14:44:37.557Z [DEBUG] GET https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS.72D7468F.sig
    2023-01-09T14:44:37.557Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS.72D7468F.sig
    - Installing hashicorp/aws v4.49.0...
    2023-01-09T14:44:37.573Z [TRACE] providercache.Dir.InstallPackage: installing registry.terraform.io/hashicorp/aws v4.49.0 from https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_linux_amd64.zip
    2023-01-09T14:44:37.573Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_linux_amd64.zip
    2023-01-09T14:44:38.641Z [DEBUG] Provider signed by 34365D9472D7468F HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>
    2023-01-09T14:44:40.792Z [TRACE] providercache.fillMetaCache: scanning directory /home/student/dot.terraform/providers
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v4.49.0 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.2.3 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 4.49.0
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.2.3
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
    - Installed hashicorp/aws v4.49.0 (signed by HashiCorp)
    
    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.


This command initializes the terraform directory structure.

Take the time to look at the trace output to see what the *init* process does and where it looks for and stores provider plugin or module files.

This can be particularly useful when build or installing third-party provider plugins manually - to debug possible failure to find the appropriate binaries.

### 7.  Preview the configuration


```bash
terraform plan
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1b"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.101.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-1"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_subnet.vpc_subnets[1] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1c"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.102.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-2"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_vpc.main_vpc will be created
      + resource "aws_vpc" "main_vpc" {
          + arn                                  = (known after apply)
          + cidr_block                           = "192.168.0.0/16"
          + default_network_acl_id               = (known after apply)
          + default_route_table_id               = (known after apply)
          + default_security_group_id            = (known after apply)
          + dhcp_options_id                      = (known after apply)
          + enable_classiclink                   = (known after apply)
          + enable_classiclink_dns_support       = (known after apply)
          + enable_dns_hostnames                 = (known after apply)
          + enable_dns_support                   = true
          + enable_network_address_usage_metrics = (known after apply)
          + id                                   = (known after apply)
          + instance_tenancy                     = "default"
          + ipv6_association_id                  = (known after apply)
          + ipv6_cidr_block                      = (known after apply)
          + ipv6_cidr_block_network_border_group = (known after apply)
          + main_route_table_id                  = (known after apply)
          + owner_id                             = (known after apply)
          + tags                                 = {
              + "LabName"  = "4b.TerraformMaps"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.101.0/24",
          + "192.168.102.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.


**verify** the actions that terraform will take.

### 8. Apply the configuration


```bash
terraform apply 
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1b"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.101.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-1"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_subnet.vpc_subnets[1] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1c"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.102.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-2"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_vpc.main_vpc will be created
      + resource "aws_vpc" "main_vpc" {
          + arn                                  = (known after apply)
          + cidr_block                           = "192.168.0.0/16"
          + default_network_acl_id               = (known after apply)
          + default_route_table_id               = (known after apply)
          + default_security_group_id            = (known after apply)
          + dhcp_options_id                      = (known after apply)
          + enable_classiclink                   = (known after apply)
          + enable_classiclink_dns_support       = (known after apply)
          + enable_dns_hostnames                 = (known after apply)
          + enable_dns_support                   = true
          + enable_network_address_usage_metrics = (known after apply)
          + id                                   = (known after apply)
          + instance_tenancy                     = "default"
          + ipv6_association_id                  = (known after apply)
          + ipv6_cidr_block                      = (known after apply)
          + ipv6_cidr_block_network_border_group = (known after apply)
          + main_route_table_id                  = (known after apply)
          + owner_id                             = (known after apply)
          + tags                                 = {
              + "LabName"  = "4b.TerraformMaps"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.101.0/24",
          + "192.168.102.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    aws_vpc.main_vpc: Creating...
    aws_vpc.main_vpc: Creation complete after 3s [id=vpc-0a27f3377fe36f60e]
    aws_subnet.vpc_subnets[1]: Creating...
    aws_subnet.vpc_subnets[0]: Creating...
    aws_subnet.vpc_subnets[1]: Creation complete after 1s [id=subnet-0ff96eff4a1656bbd]
    aws_subnet.vpc_subnets[0]: Creation complete after 2s [id=subnet-063d030c0be1e1b6e]
    
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.101.0/24",
      "192.168.102.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


Assuming that this works correctly, the AWS Provider will create a VPC, and 2 subnets located in 2 different
availability zones, and an ami instance running on each subnet.

### 9. Create some instances using the vpcs

#### Known error to be fixed ...

Getting error: ```Error launching source instance: InvalidParameter: Security group sg-07cbbd1042f3c81b3 and subnet subnet-2c6ba676 belong to different networks.```


Now add some new "aws_instance" resources, i.e. VMs, using count to create several.

Output the assigned public_ips of the VMs

Output also a combined output of public_ip, public_dns, private_ip for each VM of the form:
- "public address: <public_ip>[<public_dns>] private address: <private_ip>"

You should use the "*for*" expression to achieve this

#### There is an error in the above config - work in progress (regression)

We've achieved most of the lab, which is around the use of Terraform Maps

### 10. Investigate the *terraform state* sub-command

You can list the resources available in the current state using the ```terraform state list``` command.

Look at the state of one of the listed resources using command ```terraform state show <resource>```, e.g.
- ```terraform state show aws_vpc.main_vpc```
- ```terraform state show aws_instance.example[0]```

### 11. Cleanup


```bash
terraform destroy 
```

    tls_private_key.mykey: Refreshing state... [id=e92e6d88710e7dd7c9bde48de0d8b282862feeef]
    aws_key_pair.generated_key: Refreshing state... [id=LAB4b-key]
    aws_vpc.main_vpc: Refreshing state... [id=vpc-0a27f3377fe36f60e]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-063d030c0be1e1b6e]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-0ff96eff4a1656bbd]
    aws_security_group.secgroup-ssh: Refreshing state... [id=sg-049d574d73c3307d1]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_key_pair.generated_key will be destroyed
      - resource "aws_key_pair" "generated_key" {
          - arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/LAB4b-key" [90m-> [90mnull
          - fingerprint = "6c:68:e1:3f:3d:5c:6f:85:29:56:68:74:e5:8a:76:0b" [90m-> [90mnull
          - id          = "LAB4b-key" [90m-> [90mnull
          - key_name    = "LAB4b-key" [90m-> [90mnull
          - key_pair_id = "key-066bc08332e1c1422" [90m-> [90mnull
          - key_type    = "rsa" [90m-> [90mnull
          - public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==" [90m-> [90mnull
          - tags        = {} [90m-> [90mnull
          - tags_all    = {
              - "Environment" = "Terraform Introduction"
            } [90m-> [90mnull
        }
    
      # aws_security_group.secgroup-ssh will be destroyed
      - resource "aws_security_group" "secgroup-ssh" {
          - arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-049d574d73c3307d1" [90m-> [90mnull
          - description            = "Managed by Terraform" [90m-> [90mnull
          - egress                 = [] [90m-> [90mnull
          - id                     = "sg-049d574d73c3307d1" [90m-> [90mnull
          - ingress                = [
              - {
                  - cidr_blocks      = [
                      - "0.0.0.0/0",
                    ]
                  - description      = ""
                  - from_port        = 22
                  - ipv6_cidr_blocks = []
                  - prefix_list_ids  = []
                  - protocol         = "tcp"
                  - security_groups  = []
                  - self             = false
                  - to_port          = 22
                },
            ] [90m-> [90mnull
          - name                   = "simple security group - for ssh Ingress only" [90m-> [90mnull
          - owner_id               = "816376574968" [90m-> [90mnull
          - revoke_rules_on_delete = false [90m-> [90mnull
          - tags                   = {} [90m-> [90mnull
          - tags_all               = {
              - "Environment" = "Terraform Introduction"
            } [90m-> [90mnull
          - vpc_id                 = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[0] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-063d030c0be1e1b6e" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1b" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az3" [90m-> [90mnull
          - cidr_block                                     = "192.168.101.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-063d030c0be1e1b6e" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4b.TerraformMaps"
              - "Name"    = "subnet-1"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Name"        = "subnet-1"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[1] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-0ff96eff4a1656bbd" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1c" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az1" [90m-> [90mnull
          - cidr_block                                     = "192.168.102.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-0ff96eff4a1656bbd" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4b.TerraformMaps"
              - "Name"    = "subnet-2"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Name"        = "subnet-2"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_vpc.main_vpc will be destroyed
      - resource "aws_vpc" "main_vpc" {
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:vpc/vpc-0a27f3377fe36f60e" [90m-> [90mnull
          - assign_generated_ipv6_cidr_block     = false [90m-> [90mnull
          - cidr_block                           = "192.168.0.0/16" [90m-> [90mnull
          - default_network_acl_id               = "acl-05166db12af599180" [90m-> [90mnull
          - default_route_table_id               = "rtb-022cae4b8c3aa0070" [90m-> [90mnull
          - default_security_group_id            = "sg-04a9d2223ddc1e8b4" [90m-> [90mnull
          - dhcp_options_id                      = "dopt-5f798839" [90m-> [90mnull
          - enable_classiclink                   = false [90m-> [90mnull
          - enable_classiclink_dns_support       = false [90m-> [90mnull
          - enable_dns_hostnames                 = false [90m-> [90mnull
          - enable_dns_support                   = true [90m-> [90mnull
          - enable_network_address_usage_metrics = false [90m-> [90mnull
          - id                                   = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
          - instance_tenancy                     = "default" [90m-> [90mnull
          - ipv6_netmask_length                  = 0 [90m-> [90mnull
          - main_route_table_id                  = "rtb-022cae4b8c3aa0070" [90m-> [90mnull
          - owner_id                             = "816376574968" [90m-> [90mnull
          - tags                                 = {
              - "LabName"  = "4b.TerraformMaps"
              - "Location" = "London"
              - "Name"     = "Main"
            } [90m-> [90mnull
          - tags_all                             = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Location"    = "London"
              - "Name"        = "Main"
            } [90m-> [90mnull
        }
    
      # tls_private_key.mykey will be destroyed
      - resource "tls_private_key" "mykey" {
          - algorithm                     = "RSA" [90m-> [90mnull
          - ecdsa_curve                   = "P224" [90m-> [90mnull
          - id                            = "e92e6d88710e7dd7c9bde48de0d8b282862feeef" [90m-> [90mnull
          - private_key_openssh           = (sensitive value)
          - private_key_pem               = (sensitive value)
          - private_key_pem_pkcs8         = (sensitive value)
          - public_key_fingerprint_md5    = "77:f5:82:d8:4d:d6:cb:2e:b8:f9:eb:bb:50:28:63:63" [90m-> [90mnull
          - public_key_fingerprint_sha256 = "SHA256:i96LNXbxY+yN3vDfwweK2LH2a9wY6IrwCcH2QawVJ5k" [90m-> [90mnull
          - public_key_openssh            = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==
            EOT [90m-> [90mnull
          - public_key_pem                = <<-EOT
                -----BEGIN PUBLIC KEY-----
                MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA1jttBmUDpwEohhmCJh50
                CgkJSyiBv1Lac97NJZmAZC8HJndEvX16kUVbz4EHwbUTW5/UFCRLjK97UcE8INfs
                GCHkjlJQTqYUXh+nAw6B5tBQojCfl0SsfMNy6r/iWmwpigLxm/yn2j3VC1e0ICia
                Uo62ug7NpPhZbG0fbkNrruF5kvqSSlCLRDu/kcG30TWdKJ5tU63b7rN+jWaOm3ct
                9totJPaCB4Nbprw+pfMdcUFOgCWSp5tHK67KL8on08Q29Q32n8xBwXCaNM7ni2kb
                xP2DluF33al0DuL23C0Rgep9s5sL+MKdzaXh9GRjNF/OsObSXap/QtA9TQQGLfSs
                6/7jeiAgZCgSF7AJhFm1r7yXNwarjl01tXf++QvrsGoJZnDRY5WrPEptuRuLW1hk
                PURBJysYMY4cbV9rbY8lSxd2Dib6W74nsuFJ71pgA2xqfYVzV8qyqPaXDVXVvUqi
                y3UnHz4ubtbpHFTwhqTE/Ye/elXBsFlNjaqugOporxsQ+yneYjEOh3oSRxvjjmdL
                vegxNaV0teSZBRE3o+dfYWX22tspa8Zkfq2CClAe9pey6sufC77PILq5vFmuY2S1
                DyO2lKQ/mPWKNssr8+xwIOM98PqzzZCMI1sdMusdbKOF4ONHslhAzdpcYjjTrDVf
                lQ+/HKjkiuXX2s3pH3CI/4MCAwEAAQ==
                -----END PUBLIC KEY-----
            EOT [90m-> [90mnull
          - rsa_bits                      = 4096 [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 6 to destroy.
    
    Changes to Outputs:
      - ssh_pem_key     = (sensitive value)
      - ssh_rsa_pub_key = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==
        EOT [90m-> [90mnull
    aws_security_group.secgroup-ssh: Destroying... [id=sg-049d574d73c3307d1]
    aws_subnet.vpc_subnets[1]: Destroying... [id=subnet-0ff96eff4a1656bbd]
    aws_subnet.vpc_subnets[0]: Destroying... [id=subnet-063d030c0be1e1b6e]
    aws_key_pair.generated_key: Destroying... [id=LAB4b-key]
    aws_key_pair.generated_key: Destruction complete after 1s
    tls_private_key.mykey: Destroying... [id=e92e6d88710e7dd7c9bde48de0d8b282862feeef]
    tls_private_key.mykey: Destruction complete after 0s
    aws_subnet.vpc_subnets[1]: Destruction complete after 1s
    aws_subnet.vpc_subnets[0]: Destruction complete after 1s
    aws_security_group.secgroup-ssh: Destruction complete after 2s
    aws_vpc.main_vpc: Destroying... [id=vpc-0a27f3377fe36f60e]
    aws_vpc.main_vpc: Destruction complete after 1s
    
    Destroy complete! Resources: 6 destroyed.
    


To destroy the formerly created AWS vpc, and all subnets.

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of the *map* type.

We used this type to map from
- region to ami image
- region to availability zones

We then created some VM instances and output their subnet, zone information



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab4b




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 1:** Dynamic Blocks

- Add a security group to your VMs, using a dynamic block to specify each ingress rule to allow incoming traffic on ports 22 and 8080
- Investigate the state of the dynamic block you created
- Verify that you can ssh into your instances

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/dynamic-blocks-and-splat-expressions for some hints

<hr/>
<!-- ![](/images/LOGO_v2_CROPPED.jpg)
<img src="/images/LOGO_v2_CROPPED.jpg" width="200" /> -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we learn how to create and use terraform maps. Maps are key/value pairs which we can create and look up as we need to in our templates.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4b’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf vars.tf.

The main.tf file should contain:

The provider.tf file should contain:


```bash
cat provider.tf
```

    
    terraform {
      required_version = ">= 1.1.0"
    
      required_providers {
        aws = {
          version = "~> 4.0"
        }
      }
    }
    
    provider "aws" {
      region = var.region
    
      default_tags {
        tags = {
          Environment = "Terraform Introduction"
        }
      }
    }
    


The resources.tf file should contain:


```bash
cat resources.tf
```

    
    resource "aws_vpc" "main_vpc" {
      cidr_block       = var.vpc_cidr
      instance_tenancy = "default"
    
      tags = {
        Name           = "Main"
        Location       = "London"
        LabName        = "4b.TerraformMaps"
      }
    }
    
    resource "aws_subnet" "vpc_subnets" {
      count = length(var.vpc_subnet_cidr)
    
      vpc_id             = aws_vpc.main_vpc.id
    
      #cidr_block        = element(var.vpc_subnet_cidr,count.index)
      cidr_block         = var.vpc_subnet_cidr[count.index]
    
      #availability_zone = element(var.aaz[var.region],count.index)
      availability_zone  = var.aaz[var.region][count.index]
    
      tags = {
        Name = "subnet-${count.index+1}"
        LabName = "4b.TerraformMaps"
      }
    }


and your vars.tf file should contain:


```bash
cat vars.tf
```

    
    variable "region" {
      default = "us-west-1"
    }
    variable "vpc_cidr" {
      default = "192.168.0.0/16"
    }
    variable "vpc_subnet_cidr" {
      type = list
      # Reduced to 2-elements each due to non-availability of us-west-1a:
      #default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
      default = ["192.168.101.0/24","192.168.102.0/24"]
    }
    variable "ami_instance" {
      type = map
      default = {
        "us-east-1" = "ami-0ac019f4fcb7cb7e6"
        "us-east-2" = "ami-0f65671a86f061fcd"
        "us-west-1" = "ami-063aa838bd7631e0b"
      }
    }
    variable "ami_instance_type" {
      default = "t2.micro"
    }
    variable "aaz" {
      type = map
      default = {
        #"us-east-1" = ["us-east-1a","us-east-1b","us-east-1c"]
        #"us-east-2" = ["us-east-2a","us-east-2b","us-east-2c"]
        #"us-west-1" = ["us-west-1a","us-west-1b","us-west-1c"]
    
        # Reduced to 2-elements each due to non-availability of us-west-1a:
        #"us-east-1" = ["us-east-1b","us-east-1c"]
        #"us-east-2" = ["us-east-2b","us-east-2c"]
        "us-west-1" = ["us-west-1b","us-west-1c"]
      }
    } 


You may copy the outputs.tf file you used for the previous lab to see the output.

<!-- data "aws_availability_zones" "aaz" {} -->

### 4. Study the configuration files

Study the configuration files, taking the time to understand

* the use of the "vpc_subnet_cidr" list variable

* the use of the "ami_instance" map variable

* the use of the "aaz" map variable

- why we need to modify the list/map dimensions when an availability zone is not available

### 5. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>

![](graph.svg)

### 6. Initialize the configuration

This time we will set the TF_LOG variable to TRACE to see debugging output: ```TF_LOG=TRACE terraform init```


```bash
TF_LOG=TRACE terraform init
```

    2023-01-09T14:44:37.219Z [INFO]  Terraform version: 1.3.7
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/go-tfe v1.9.0
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/hcl/v2 v2.15.0
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/terraform-config-inspect v0.0.0-20210209133302-4fd17a0faac2
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/hashicorp/terraform-svchost v0.0.0-20200729002733-f050f53b9734
    2023-01-09T14:44:37.219Z [DEBUG] using github.com/zclconf/go-cty v1.12.1
    2023-01-09T14:44:37.219Z [INFO]  Go runtime version: go1.19.4
    2023-01-09T14:44:37.219Z [INFO]  CLI args: []string{"terraform", "init"}
    2023-01-09T14:44:37.219Z [TRACE] Stdout is a terminal of width 80
    2023-01-09T14:44:37.219Z [TRACE] Stderr is a terminal of width 80
    2023-01-09T14:44:37.219Z [TRACE] Stdin is a terminal
    2023-01-09T14:44:37.219Z [DEBUG] Attempting to open CLI config file: /home/student/.terraformrc
    2023-01-09T14:44:37.219Z [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /home/student/.terraform.d/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /home/student/.local/share/terraform/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
    2023-01-09T14:44:37.219Z [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins
    2023-01-09T14:44:37.220Z [INFO]  CLI command args: []string{"init"}
    
    Initializing the backend...
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
    2023-01-09T14:44:37.227Z [DEBUG] New state was assigned lineage "f09f94a4-3674-ef40-02a9-a8311b6dd837"
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
    2023-01-09T14:44:37.227Z [TRACE] Meta.Backend: instantiated backend of type <nil>
    2023-01-09T14:44:37.227Z [DEBUG] checking for provisioner in "."
    2023-01-09T14:44:37.228Z [DEBUG] checking for provisioner in "/home/student/bin"
    2023-01-09T14:44:37.228Z [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
    2023-01-09T14:44:37.228Z [TRACE] backend/local: state manager for workspace "default" will:
     - read initial snapshot from terraform.tfstate
     - write new snapshots to terraform.tfstate
     - create any backup at terraform.tfstate.backup
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
    2023-01-09T14:44:37.228Z [TRACE] statemgr.Filesystem: read nil snapshot
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.0"...
    2023-01-09T14:44:37.228Z [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
    2023-01-09T14:44:37.228Z [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
    2023-01-09T14:44:37.341Z [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
    2023-01-09T14:44:37.341Z [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: scanning directory /home/student/dot.terraform/providers
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v4.49.0 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.2.3 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 4.49.0
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.2.3
    2023-01-09T14:44:37.410Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
    2023-01-09T14:44:37.410Z [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/4.49.0/download/linux/amd64
    2023-01-09T14:44:37.410Z [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/4.49.0/download/linux/amd64
    2023-01-09T14:44:37.474Z [DEBUG] GET https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS
    2023-01-09T14:44:37.474Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS
    2023-01-09T14:44:37.557Z [DEBUG] GET https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS.72D7468F.sig
    2023-01-09T14:44:37.557Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_SHA256SUMS.72D7468F.sig
    - Installing hashicorp/aws v4.49.0...
    2023-01-09T14:44:37.573Z [TRACE] providercache.Dir.InstallPackage: installing registry.terraform.io/hashicorp/aws v4.49.0 from https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_linux_amd64.zip
    2023-01-09T14:44:37.573Z [TRACE] HTTP client GET request to https://releases.hashicorp.com/terraform-provider-aws/4.49.0/terraform-provider-aws_4.49.0_linux_amd64.zip
    2023-01-09T14:44:38.641Z [DEBUG] Provider signed by 34365D9472D7468F HashiCorp Security (hashicorp.com/security) <security@hashicorp.com>
    2023-01-09T14:44:40.792Z [TRACE] providercache.fillMetaCache: scanning directory /home/student/dot.terraform/providers
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v4.49.0 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/local v2.2.3 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/tls v4.0.4 for linux_amd64 at /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 4.49.0
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/local/2.2.3/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/local 2.2.3
    2023-01-09T14:44:40.793Z [TRACE] providercache.fillMetaCache: including /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/tls/4.0.4/linux_amd64 as a candidate package for registry.terraform.io/hashicorp/tls 4.0.4
    - Installed hashicorp/aws v4.49.0 (signed by HashiCorp)
    
    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.


This command initializes the terraform directory structure.

Take the time to look at the trace output to see what the *init* process does and where it looks for and stores provider plugin or module files.

This can be particularly useful when build or installing third-party provider plugins manually - to debug possible failure to find the appropriate binaries.

### 7.  Preview the configuration


```bash
terraform plan
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1b"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.101.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-1"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_subnet.vpc_subnets[1] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1c"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.102.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-2"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_vpc.main_vpc will be created
      + resource "aws_vpc" "main_vpc" {
          + arn                                  = (known after apply)
          + cidr_block                           = "192.168.0.0/16"
          + default_network_acl_id               = (known after apply)
          + default_route_table_id               = (known after apply)
          + default_security_group_id            = (known after apply)
          + dhcp_options_id                      = (known after apply)
          + enable_classiclink                   = (known after apply)
          + enable_classiclink_dns_support       = (known after apply)
          + enable_dns_hostnames                 = (known after apply)
          + enable_dns_support                   = true
          + enable_network_address_usage_metrics = (known after apply)
          + id                                   = (known after apply)
          + instance_tenancy                     = "default"
          + ipv6_association_id                  = (known after apply)
          + ipv6_cidr_block                      = (known after apply)
          + ipv6_cidr_block_network_border_group = (known after apply)
          + main_route_table_id                  = (known after apply)
          + owner_id                             = (known after apply)
          + tags                                 = {
              + "LabName"  = "4b.TerraformMaps"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.101.0/24",
          + "192.168.102.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.


**verify** the actions that terraform will take.

### 8. Apply the configuration


```bash
terraform apply 
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1b"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.101.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-1"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_subnet.vpc_subnets[1] will be created
      + resource "aws_subnet" "vpc_subnets" {
          + arn                                            = (known after apply)
          + assign_ipv6_address_on_creation                = false
          + availability_zone                              = "us-west-1c"
          + availability_zone_id                           = (known after apply)
          + cidr_block                                     = "192.168.102.0/24"
          + enable_dns64                                   = false
          + enable_resource_name_dns_a_record_on_launch    = false
          + enable_resource_name_dns_aaaa_record_on_launch = false
          + id                                             = (known after apply)
          + ipv6_cidr_block_association_id                 = (known after apply)
          + ipv6_native                                    = false
          + map_public_ip_on_launch                        = false
          + owner_id                                       = (known after apply)
          + private_dns_hostname_type_on_launch            = (known after apply)
          + tags                                           = {
              + "LabName" = "4b.TerraformMaps"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Name"        = "subnet-2"
            }
          + vpc_id                                         = (known after apply)
        }
    
      # aws_vpc.main_vpc will be created
      + resource "aws_vpc" "main_vpc" {
          + arn                                  = (known after apply)
          + cidr_block                           = "192.168.0.0/16"
          + default_network_acl_id               = (known after apply)
          + default_route_table_id               = (known after apply)
          + default_security_group_id            = (known after apply)
          + dhcp_options_id                      = (known after apply)
          + enable_classiclink                   = (known after apply)
          + enable_classiclink_dns_support       = (known after apply)
          + enable_dns_hostnames                 = (known after apply)
          + enable_dns_support                   = true
          + enable_network_address_usage_metrics = (known after apply)
          + id                                   = (known after apply)
          + instance_tenancy                     = "default"
          + ipv6_association_id                  = (known after apply)
          + ipv6_cidr_block                      = (known after apply)
          + ipv6_cidr_block_network_border_group = (known after apply)
          + main_route_table_id                  = (known after apply)
          + owner_id                             = (known after apply)
          + tags                                 = {
              + "LabName"  = "4b.TerraformMaps"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4b.TerraformMaps"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.101.0/24",
          + "192.168.102.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    aws_vpc.main_vpc: Creating...
    aws_vpc.main_vpc: Creation complete after 3s [id=vpc-0a27f3377fe36f60e]
    aws_subnet.vpc_subnets[1]: Creating...
    aws_subnet.vpc_subnets[0]: Creating...
    aws_subnet.vpc_subnets[1]: Creation complete after 1s [id=subnet-0ff96eff4a1656bbd]
    aws_subnet.vpc_subnets[0]: Creation complete after 2s [id=subnet-063d030c0be1e1b6e]
    
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.101.0/24",
      "192.168.102.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


Assuming that this works correctly, the AWS Provider will create a VPC, and 2 subnets located in 2 different
availability zones, and an ami instance running on each subnet.

### 9. Create some instances using the vpcs

#### Known error to be fixed ...

Getting error: ```Error launching source instance: InvalidParameter: Security group sg-07cbbd1042f3c81b3 and subnet subnet-2c6ba676 belong to different networks.```


Now add some new "aws_instance" resources, i.e. VMs, using count to create several.

Output the assigned public_ips of the VMs

Output also a combined output of public_ip, public_dns, private_ip for each VM of the form:
- "public address: <public_ip>[<public_dns>] private address: <private_ip>"

You should use the "*for*" expression to achieve this

#### There is an error in the above config - work in progress (regression)

We've achieved most of the lab, which is around the use of Terraform Maps

### 10. Investigate the *terraform state* sub-command

You can list the resources available in the current state using the ```terraform state list``` command.

Look at the state of one of the listed resources using command ```terraform state show <resource>```, e.g.
- ```terraform state show aws_vpc.main_vpc```
- ```terraform state show aws_instance.example[0]```

### 11. Cleanup


```bash
terraform destroy 
```

    tls_private_key.mykey: Refreshing state... [id=e92e6d88710e7dd7c9bde48de0d8b282862feeef]
    aws_key_pair.generated_key: Refreshing state... [id=LAB4b-key]
    aws_vpc.main_vpc: Refreshing state... [id=vpc-0a27f3377fe36f60e]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-063d030c0be1e1b6e]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-0ff96eff4a1656bbd]
    aws_security_group.secgroup-ssh: Refreshing state... [id=sg-049d574d73c3307d1]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_key_pair.generated_key will be destroyed
      - resource "aws_key_pair" "generated_key" {
          - arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/LAB4b-key" [90m-> [90mnull
          - fingerprint = "6c:68:e1:3f:3d:5c:6f:85:29:56:68:74:e5:8a:76:0b" [90m-> [90mnull
          - id          = "LAB4b-key" [90m-> [90mnull
          - key_name    = "LAB4b-key" [90m-> [90mnull
          - key_pair_id = "key-066bc08332e1c1422" [90m-> [90mnull
          - key_type    = "rsa" [90m-> [90mnull
          - public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==" [90m-> [90mnull
          - tags        = {} [90m-> [90mnull
          - tags_all    = {
              - "Environment" = "Terraform Introduction"
            } [90m-> [90mnull
        }
    
      # aws_security_group.secgroup-ssh will be destroyed
      - resource "aws_security_group" "secgroup-ssh" {
          - arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-049d574d73c3307d1" [90m-> [90mnull
          - description            = "Managed by Terraform" [90m-> [90mnull
          - egress                 = [] [90m-> [90mnull
          - id                     = "sg-049d574d73c3307d1" [90m-> [90mnull
          - ingress                = [
              - {
                  - cidr_blocks      = [
                      - "0.0.0.0/0",
                    ]
                  - description      = ""
                  - from_port        = 22
                  - ipv6_cidr_blocks = []
                  - prefix_list_ids  = []
                  - protocol         = "tcp"
                  - security_groups  = []
                  - self             = false
                  - to_port          = 22
                },
            ] [90m-> [90mnull
          - name                   = "simple security group - for ssh Ingress only" [90m-> [90mnull
          - owner_id               = "816376574968" [90m-> [90mnull
          - revoke_rules_on_delete = false [90m-> [90mnull
          - tags                   = {} [90m-> [90mnull
          - tags_all               = {
              - "Environment" = "Terraform Introduction"
            } [90m-> [90mnull
          - vpc_id                 = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[0] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-063d030c0be1e1b6e" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1b" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az3" [90m-> [90mnull
          - cidr_block                                     = "192.168.101.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-063d030c0be1e1b6e" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4b.TerraformMaps"
              - "Name"    = "subnet-1"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Name"        = "subnet-1"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[1] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-0ff96eff4a1656bbd" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1c" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az1" [90m-> [90mnull
          - cidr_block                                     = "192.168.102.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-0ff96eff4a1656bbd" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4b.TerraformMaps"
              - "Name"    = "subnet-2"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Name"        = "subnet-2"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
        }
    
      # aws_vpc.main_vpc will be destroyed
      - resource "aws_vpc" "main_vpc" {
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:vpc/vpc-0a27f3377fe36f60e" [90m-> [90mnull
          - assign_generated_ipv6_cidr_block     = false [90m-> [90mnull
          - cidr_block                           = "192.168.0.0/16" [90m-> [90mnull
          - default_network_acl_id               = "acl-05166db12af599180" [90m-> [90mnull
          - default_route_table_id               = "rtb-022cae4b8c3aa0070" [90m-> [90mnull
          - default_security_group_id            = "sg-04a9d2223ddc1e8b4" [90m-> [90mnull
          - dhcp_options_id                      = "dopt-5f798839" [90m-> [90mnull
          - enable_classiclink                   = false [90m-> [90mnull
          - enable_classiclink_dns_support       = false [90m-> [90mnull
          - enable_dns_hostnames                 = false [90m-> [90mnull
          - enable_dns_support                   = true [90m-> [90mnull
          - enable_network_address_usage_metrics = false [90m-> [90mnull
          - id                                   = "vpc-0a27f3377fe36f60e" [90m-> [90mnull
          - instance_tenancy                     = "default" [90m-> [90mnull
          - ipv6_netmask_length                  = 0 [90m-> [90mnull
          - main_route_table_id                  = "rtb-022cae4b8c3aa0070" [90m-> [90mnull
          - owner_id                             = "816376574968" [90m-> [90mnull
          - tags                                 = {
              - "LabName"  = "4b.TerraformMaps"
              - "Location" = "London"
              - "Name"     = "Main"
            } [90m-> [90mnull
          - tags_all                             = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4b.TerraformMaps"
              - "Location"    = "London"
              - "Name"        = "Main"
            } [90m-> [90mnull
        }
    
      # tls_private_key.mykey will be destroyed
      - resource "tls_private_key" "mykey" {
          - algorithm                     = "RSA" [90m-> [90mnull
          - ecdsa_curve                   = "P224" [90m-> [90mnull
          - id                            = "e92e6d88710e7dd7c9bde48de0d8b282862feeef" [90m-> [90mnull
          - private_key_openssh           = (sensitive value)
          - private_key_pem               = (sensitive value)
          - private_key_pem_pkcs8         = (sensitive value)
          - public_key_fingerprint_md5    = "77:f5:82:d8:4d:d6:cb:2e:b8:f9:eb:bb:50:28:63:63" [90m-> [90mnull
          - public_key_fingerprint_sha256 = "SHA256:i96LNXbxY+yN3vDfwweK2LH2a9wY6IrwCcH2QawVJ5k" [90m-> [90mnull
          - public_key_openssh            = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==
            EOT [90m-> [90mnull
          - public_key_pem                = <<-EOT
                -----BEGIN PUBLIC KEY-----
                MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA1jttBmUDpwEohhmCJh50
                CgkJSyiBv1Lac97NJZmAZC8HJndEvX16kUVbz4EHwbUTW5/UFCRLjK97UcE8INfs
                GCHkjlJQTqYUXh+nAw6B5tBQojCfl0SsfMNy6r/iWmwpigLxm/yn2j3VC1e0ICia
                Uo62ug7NpPhZbG0fbkNrruF5kvqSSlCLRDu/kcG30TWdKJ5tU63b7rN+jWaOm3ct
                9totJPaCB4Nbprw+pfMdcUFOgCWSp5tHK67KL8on08Q29Q32n8xBwXCaNM7ni2kb
                xP2DluF33al0DuL23C0Rgep9s5sL+MKdzaXh9GRjNF/OsObSXap/QtA9TQQGLfSs
                6/7jeiAgZCgSF7AJhFm1r7yXNwarjl01tXf++QvrsGoJZnDRY5WrPEptuRuLW1hk
                PURBJysYMY4cbV9rbY8lSxd2Dib6W74nsuFJ71pgA2xqfYVzV8qyqPaXDVXVvUqi
                y3UnHz4ubtbpHFTwhqTE/Ye/elXBsFlNjaqugOporxsQ+yneYjEOh3oSRxvjjmdL
                vegxNaV0teSZBRE3o+dfYWX22tspa8Zkfq2CClAe9pey6sufC77PILq5vFmuY2S1
                DyO2lKQ/mPWKNssr8+xwIOM98PqzzZCMI1sdMusdbKOF4ONHslhAzdpcYjjTrDVf
                lQ+/HKjkiuXX2s3pH3CI/4MCAwEAAQ==
                -----END PUBLIC KEY-----
            EOT [90m-> [90mnull
          - rsa_bits                      = 4096 [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 6 to destroy.
    
    Changes to Outputs:
      - ssh_pem_key     = (sensitive value)
      - ssh_rsa_pub_key = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWO20GZQOnASiGGYImHnQKCQlLKIG/Utpz3s0lmYBkLwcmd0S9fXqRRVvPgQfBtRNbn9QUJEuMr3tRwTwg1+wYIeSOUlBOphReH6cDDoHm0FCiMJ+XRKx8w3Lqv+JabCmKAvGb/KfaPdULV7QgKJpSjra6Ds2k+FlsbR9uQ2uu4XmS+pJKUItEO7+RwbfRNZ0onm1Trdvus36NZo6bdy322i0k9oIHg1umvD6l8x1xQU6AJZKnm0crrsovyifTxDb1DfafzEHBcJo0zueLaRvE/YOW4XfdqXQO4vbcLRGB6n2zmwv4wp3NpeH0ZGM0X86w5tJdqn9C0D1NBAYt9Kzr/uN6ICBkKBIXsAmEWbWvvJc3BquOXTW1d/75C+uwaglmcNFjlas8Sm25G4tbWGQ9REEnKxgxjhxtX2ttjyVLF3YOJvpbviey4UnvWmADbGp9hXNXyrKo9pcNVdW9SqLLdScfPi5u1ukcVPCGpMT9h796VcGwWU2Nqq6A6mivGxD7Kd5iMQ6HehJHG+OOZ0u96DE1pXS15JkFETej519hZfba2ylrxmR+rYIKUB72l7Lqy58Lvs8gurm8Wa5jZLUPI7aUpD+Y9Yo2yyvz7HAg4z3w+rPNkIwjWx0y6x1so4Xg40eyWEDN2lxiONOsNV+VD78cqOSK5dfazekfcIj/gw==
        EOT [90m-> [90mnull
    aws_security_group.secgroup-ssh: Destroying... [id=sg-049d574d73c3307d1]
    aws_subnet.vpc_subnets[1]: Destroying... [id=subnet-0ff96eff4a1656bbd]
    aws_subnet.vpc_subnets[0]: Destroying... [id=subnet-063d030c0be1e1b6e]
    aws_key_pair.generated_key: Destroying... [id=LAB4b-key]
    aws_key_pair.generated_key: Destruction complete after 1s
    tls_private_key.mykey: Destroying... [id=e92e6d88710e7dd7c9bde48de0d8b282862feeef]
    tls_private_key.mykey: Destruction complete after 0s
    aws_subnet.vpc_subnets[1]: Destruction complete after 1s
    aws_subnet.vpc_subnets[0]: Destruction complete after 1s
    aws_security_group.secgroup-ssh: Destruction complete after 2s
    aws_vpc.main_vpc: Destroying... [id=vpc-0a27f3377fe36f60e]
    aws_vpc.main_vpc: Destruction complete after 1s
    
    Destroy complete! Resources: 6 destroyed.
    


To destroy the formerly created AWS vpc, and all subnets.

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of the *map* type.

We used this type to map from
- region to ami image
- region to availability zones

We then created some VM instances and output their subnet, zone information



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab4b




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 1:** Dynamic Blocks

- Add a security group to your VMs, using a dynamic block to specify each ingress rule to allow incoming traffic on ports 22 and 8080
- Investigate the state of the dynamic block you created
- Verify that you can ssh into your instances

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/dynamic-blocks-and-splat-expressions for some hints

<hr/>
<!-- ![](../../../static/images/LOGO_v2_CROPPED.jpg)
<img src="../../../static/images/LOGO_v2_CROPPED.jpg" width="200" /> -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



