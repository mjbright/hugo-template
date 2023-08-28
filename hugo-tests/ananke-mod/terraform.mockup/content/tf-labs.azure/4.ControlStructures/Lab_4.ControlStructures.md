---
title:  Lab 4.ControlStructures
date:   1673274898
weight: 40
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we learn how to create and use terraform list data structures. We will learn now to create them and how to extract individual elements of the lists.

We will also show how we can output all values of each list.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf, vars.tf

The contents of main.tf should be:


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
    


The contents of resources.tf should be as below:


```bash
cat resources.tf
```

    resource "aws_vpc" "main_vpc" {
      cidr_block       = var.vpc_cidr
      instance_tenancy = "default"
    
      tags = {
        Name     = "Main"
        Location = "London"
        LabName  = "4.ControlStructures"
      }
    }
    
    resource "aws_subnet" "vpc_subnets" {
      count = length(var.aws_availability_zones)
    
      vpc_id            = aws_vpc.main_vpc.id
    
      cidr_block        = var.vpc_subnet_cidr[count.index]
    
      availability_zone = var.aws_availability_zones[count.index]
    
      tags = {
        Name    = "subnet-${count.index+1}"
        LabName = "4.ControlStructures"
      }
    }


**Note**: the use of the **count** special attribute in the *aws_subnet* definition above

The contents of vars.tf should be as shown below:

**Note**: However in case of

- "*Value (us-west-1X) for parameter availabilityZone is invalid*"
type of error message, remove that availability_zone value from the map in var.tf

Due to a current error (unavailability of the zone) for us-west-1a, we have removed us-west-1a from the map.

- "Value (us-west-1a) for parameter availabilityZone is invalid"



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## New resource types

Note that in these files we have defined resource types that we have not previously seen
- aws_vpc - Previously when we created VMs we did not define the VPC so a default VPC was created for us
  - A VPC is a Virtual Private Cloud which allows our VM instances to be in a partitioned private network space
- aws_subnet - We define the subnet addressing to be used in our VPC



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
      default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
    }
    variable "ami_instance" {
      default = "ami-0ac019f4fcb7cb7e6"
    }
    variable "ami_instance_type" {
      default = "t2.micro"
    }
    variable "aws_availability_zones" {
      type = list
    
      # Remove us-west-1a:
      # default = ["us-west-1a","us-west-1b","us-west-1c"]
      default = ["us-west-1b","us-west-1c"]
    }


Create also an outputs.tf file containing:


```bash
cat outputs.tf
```

    output subnets { value = aws_subnet.vpc_subnets[*].cidr_block }
    output zones   { value = aws_subnet.vpc_subnets[*].availability_zone }


<!-- No longer necessary now with linked accounts - Note: For each student, change the CIDR for the VPC and subnets to a unique value! -->


### 4. Initialize the config


```bash
terraform init
```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.0"...
    - Installing hashicorp/aws v4.49.0...
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


### 5. Plan the changes


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
          + cidr_block                                     = "192.168.100.0/24"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName"  = "4.ControlStructures"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.100.0/24",
          + "192.168.101.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.


**Verify** the proposed actions that terraform will take.

### 6. Apply the config


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
          + cidr_block                                     = "192.168.100.0/24"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName"  = "4.ControlStructures"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.100.0/24",
          + "192.168.101.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    aws_vpc.main_vpc: Creating...
    aws_vpc.main_vpc: Creation complete after 3s [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Creating...
    aws_subnet.vpc_subnets[0]: Creating...
    aws_subnet.vpc_subnets[0]: Creation complete after 1s [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Creation complete after 1s [id=subnet-03dac58cee0dd0ff5]
    
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


Assuming that this works correctly, AWS create a VPC and two subnets - **ONLY** if both availability_zones are in fact available. 

<!-- Check this with the AWS console. -->

**Note**: You may get a **vpc limit reached** error message.

To work around this change the value of the region variable in vars.tf.

Once you have successfully applied the config, move onto the next step.

### 7. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>

### 8. Re-Apply the config

If we re-apply the config nothing changes


```bash
terraform apply 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


### 9. Tainting resources

Now let us try *tainting* a resource and redoing the apply

We would apply a taint if we knew that the resource has some problem independent of Terraform.

Tainting a resource marks it for deletion/creation at the next apply


```bash
terraform taint aws_subnet.vpc_subnets[0]
```

    Resource instance aws_subnet.vpc_subnets[0] has been marked as tainted.


Now redo the apply, but *refuse* the apply when prompted, type "no" or ctrl-C.


We can undo the effect of taint with untaint:


```bash
terraform untaint aws_subnet.vpc_subnets[0]
```

    Resource instance aws_subnet.vpc_subnets[0] has been successfully untainted.


Now redo the apply, and note that no changes would be made


```bash
terraform apply 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


### 10. Clean up


```bash
terraform destroy 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-0fb8e127d9a35f71e" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1b" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az3" [90m-> [90mnull
          - cidr_block                                     = "192.168.100.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-0fb8e127d9a35f71e" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4.ControlStructures"
              - "Name"    = "subnet-1"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Name"        = "subnet-1"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[1] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-03dac58cee0dd0ff5" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1c" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az1" [90m-> [90mnull
          - cidr_block                                     = "192.168.101.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-03dac58cee0dd0ff5" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4.ControlStructures"
              - "Name"    = "subnet-2"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Name"        = "subnet-2"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
        }
    
      # aws_vpc.main_vpc will be destroyed
      - resource "aws_vpc" "main_vpc" {
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:vpc/vpc-0e3b272622a64a4fd" [90m-> [90mnull
          - assign_generated_ipv6_cidr_block     = false [90m-> [90mnull
          - cidr_block                           = "192.168.0.0/16" [90m-> [90mnull
          - default_network_acl_id               = "acl-0656485f2b0e4f211" [90m-> [90mnull
          - default_route_table_id               = "rtb-02b576cb0d84522a8" [90m-> [90mnull
          - default_security_group_id            = "sg-04d5ecca7ae2e9766" [90m-> [90mnull
          - dhcp_options_id                      = "dopt-5f798839" [90m-> [90mnull
          - enable_classiclink                   = false [90m-> [90mnull
          - enable_classiclink_dns_support       = false [90m-> [90mnull
          - enable_dns_hostnames                 = false [90m-> [90mnull
          - enable_dns_support                   = true [90m-> [90mnull
          - enable_network_address_usage_metrics = false [90m-> [90mnull
          - id                                   = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
          - instance_tenancy                     = "default" [90m-> [90mnull
          - ipv6_netmask_length                  = 0 [90m-> [90mnull
          - main_route_table_id                  = "rtb-02b576cb0d84522a8" [90m-> [90mnull
          - owner_id                             = "816376574968" [90m-> [90mnull
          - tags                                 = {
              - "LabName"  = "4.ControlStructures"
              - "Location" = "London"
              - "Name"     = "Main"
            } [90m-> [90mnull
          - tags_all                             = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Location"    = "London"
              - "Name"        = "Main"
            } [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 3 to destroy.
    
    Changes to Outputs:
      - subnets = [
          - "192.168.100.0/24",
          - "192.168.101.0/24",
        ] [90m-> [90mnull
      - zones   = [
          - "us-west-1b",
          - "us-west-1c",
        ] [90m-> [90mnull
    aws_subnet.vpc_subnets[0]: Destroying... [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Destroying... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[1]: Destruction complete after 1s
    aws_subnet.vpc_subnets[0]: Destruction complete after 2s
    aws_vpc.main_vpc: Destroying... [id=vpc-0e3b272622a64a4fd]
    aws_vpc.main_vpc: Destruction complete after 0s
    
    Destroy complete! Resources: 3 destroyed.
    


To destroy the formerly created AWS vpc, and all subnets.

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this exercise we used the count special attribute to create multiple *aws_subnet* resources,
1 per availabiity_zone.



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab4





<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 1:** Template Directives & String Interpolation

Consider how using Template directives allow to build up an interpolated string where each string contains the
- public_ip
- public_dns
- private_ip
of the *aws_instance* resource

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/new-template-syntax



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 2:** "for" Expressions

Modify the previous output to convert the availability zone to upper case

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/for-expressions

<hr/>

<!-- Why does this no longer work ??
<img src="/images/ThickBlueBar.png" />
<img src="/images/LOGO.jpg" width=200 />
-->

<img src="../images/ThickBlueBar.png" />
<img src="../images/LOGO.jpg" width=200 />


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we learn how to create and use terraform list data structures. We will learn now to create them and how to extract individual elements of the lists.

We will also show how we can output all values of each list.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf, vars.tf

The contents of main.tf should be:


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
    


The contents of resources.tf should be as below:


```bash
cat resources.tf
```

    resource "aws_vpc" "main_vpc" {
      cidr_block       = var.vpc_cidr
      instance_tenancy = "default"
    
      tags = {
        Name     = "Main"
        Location = "London"
        LabName  = "4.ControlStructures"
      }
    }
    
    resource "aws_subnet" "vpc_subnets" {
      count = length(var.aws_availability_zones)
    
      vpc_id            = aws_vpc.main_vpc.id
    
      cidr_block        = var.vpc_subnet_cidr[count.index]
    
      availability_zone = var.aws_availability_zones[count.index]
    
      tags = {
        Name    = "subnet-${count.index+1}"
        LabName = "4.ControlStructures"
      }
    }


**Note**: the use of the **count** special attribute in the *aws_subnet* definition above

The contents of vars.tf should be as shown below:

**Note**: However in case of

- "*Value (us-west-1X) for parameter availabilityZone is invalid*"
type of error message, remove that availability_zone value from the map in var.tf

Due to a current error (unavailability of the zone) for us-west-1a, we have removed us-west-1a from the map.

- "Value (us-west-1a) for parameter availabilityZone is invalid"



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## New resource types

Note that in these files we have defined resource types that we have not previously seen
- aws_vpc - Previously when we created VMs we did not define the VPC so a default VPC was created for us
  - A VPC is a Virtual Private Cloud which allows our VM instances to be in a partitioned private network space
- aws_subnet - We define the subnet addressing to be used in our VPC



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
      default = ["192.168.100.0/24","192.168.101.0/24","192.168.102.0/24"]
    }
    variable "ami_instance" {
      default = "ami-0ac019f4fcb7cb7e6"
    }
    variable "ami_instance_type" {
      default = "t2.micro"
    }
    variable "aws_availability_zones" {
      type = list
    
      # Remove us-west-1a:
      # default = ["us-west-1a","us-west-1b","us-west-1c"]
      default = ["us-west-1b","us-west-1c"]
    }


Create also an outputs.tf file containing:


```bash
cat outputs.tf
```

    output subnets { value = aws_subnet.vpc_subnets[*].cidr_block }
    output zones   { value = aws_subnet.vpc_subnets[*].availability_zone }


<!-- No longer necessary now with linked accounts - Note: For each student, change the CIDR for the VPC and subnets to a unique value! -->


### 4. Initialize the config


```bash
terraform init
```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.0"...
    - Installing hashicorp/aws v4.49.0...
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


### 5. Plan the changes


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
          + cidr_block                                     = "192.168.100.0/24"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName"  = "4.ControlStructures"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.100.0/24",
          + "192.168.101.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Note: You didn't use the -out option to save this plan, so Terraform can't
    guarantee to take exactly these actions if you run "terraform apply" now.


**Verify** the proposed actions that terraform will take.

### 6. Apply the config


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
          + cidr_block                                     = "192.168.100.0/24"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-1"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName" = "4.ControlStructures"
              + "Name"    = "subnet-2"
            }
          + tags_all                                       = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
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
              + "LabName"  = "4.ControlStructures"
              + "Location" = "London"
              + "Name"     = "Main"
            }
          + tags_all                             = {
              + "Environment" = "Terraform Introduction"
              + "LabName"     = "4.ControlStructures"
              + "Location"    = "London"
              + "Name"        = "Main"
            }
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + subnets = [
          + "192.168.100.0/24",
          + "192.168.101.0/24",
        ]
      + zones   = [
          + "us-west-1b",
          + "us-west-1c",
        ]
    aws_vpc.main_vpc: Creating...
    aws_vpc.main_vpc: Creation complete after 3s [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Creating...
    aws_subnet.vpc_subnets[0]: Creating...
    aws_subnet.vpc_subnets[0]: Creation complete after 1s [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Creation complete after 1s [id=subnet-03dac58cee0dd0ff5]
    
    Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


Assuming that this works correctly, AWS create a VPC and two subnets - **ONLY** if both availability_zones are in fact available. 

<!-- Check this with the AWS console. -->

**Note**: You may get a **vpc limit reached** error message.

To work around this change the value of the region variable in vars.tf.

Once you have successfully applied the config, move onto the next step.

### 7. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>

### 8. Re-Apply the config

If we re-apply the config nothing changes


```bash
terraform apply 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


### 9. Tainting resources

Now let us try *tainting* a resource and redoing the apply

We would apply a taint if we knew that the resource has some problem independent of Terraform.

Tainting a resource marks it for deletion/creation at the next apply


```bash
terraform taint aws_subnet.vpc_subnets[0]
```

    Resource instance aws_subnet.vpc_subnets[0] has been marked as tainted.


Now redo the apply, but *refuse* the apply when prompted, type "no" or ctrl-C.


We can undo the effect of taint with untaint:


```bash
terraform untaint aws_subnet.vpc_subnets[0]
```

    Resource instance aws_subnet.vpc_subnets[0] has been successfully untainted.


Now redo the apply, and note that no changes would be made


```bash
terraform apply 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    subnets = [
      "192.168.100.0/24",
      "192.168.101.0/24",
    ]
    zones = [
      "us-west-1b",
      "us-west-1c",
    ]


### 10. Clean up


```bash
terraform destroy 
```

    aws_vpc.main_vpc: Refreshing state... [id=vpc-0e3b272622a64a4fd]
    aws_subnet.vpc_subnets[1]: Refreshing state... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[0]: Refreshing state... [id=subnet-0fb8e127d9a35f71e]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_subnet.vpc_subnets[0] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-0fb8e127d9a35f71e" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1b" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az3" [90m-> [90mnull
          - cidr_block                                     = "192.168.100.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-0fb8e127d9a35f71e" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4.ControlStructures"
              - "Name"    = "subnet-1"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Name"        = "subnet-1"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
        }
    
      # aws_subnet.vpc_subnets[1] will be destroyed
      - resource "aws_subnet" "vpc_subnets" {
          - arn                                            = "arn:aws:ec2:us-west-1:816376574968:subnet/subnet-03dac58cee0dd0ff5" [90m-> [90mnull
          - assign_ipv6_address_on_creation                = false [90m-> [90mnull
          - availability_zone                              = "us-west-1c" [90m-> [90mnull
          - availability_zone_id                           = "usw1-az1" [90m-> [90mnull
          - cidr_block                                     = "192.168.101.0/24" [90m-> [90mnull
          - enable_dns64                                   = false [90m-> [90mnull
          - enable_resource_name_dns_a_record_on_launch    = false [90m-> [90mnull
          - enable_resource_name_dns_aaaa_record_on_launch = false [90m-> [90mnull
          - id                                             = "subnet-03dac58cee0dd0ff5" [90m-> [90mnull
          - ipv6_native                                    = false [90m-> [90mnull
          - map_customer_owned_ip_on_launch                = false [90m-> [90mnull
          - map_public_ip_on_launch                        = false [90m-> [90mnull
          - owner_id                                       = "816376574968" [90m-> [90mnull
          - private_dns_hostname_type_on_launch            = "ip-name" [90m-> [90mnull
          - tags                                           = {
              - "LabName" = "4.ControlStructures"
              - "Name"    = "subnet-2"
            } [90m-> [90mnull
          - tags_all                                       = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Name"        = "subnet-2"
            } [90m-> [90mnull
          - vpc_id                                         = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
        }
    
      # aws_vpc.main_vpc will be destroyed
      - resource "aws_vpc" "main_vpc" {
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:vpc/vpc-0e3b272622a64a4fd" [90m-> [90mnull
          - assign_generated_ipv6_cidr_block     = false [90m-> [90mnull
          - cidr_block                           = "192.168.0.0/16" [90m-> [90mnull
          - default_network_acl_id               = "acl-0656485f2b0e4f211" [90m-> [90mnull
          - default_route_table_id               = "rtb-02b576cb0d84522a8" [90m-> [90mnull
          - default_security_group_id            = "sg-04d5ecca7ae2e9766" [90m-> [90mnull
          - dhcp_options_id                      = "dopt-5f798839" [90m-> [90mnull
          - enable_classiclink                   = false [90m-> [90mnull
          - enable_classiclink_dns_support       = false [90m-> [90mnull
          - enable_dns_hostnames                 = false [90m-> [90mnull
          - enable_dns_support                   = true [90m-> [90mnull
          - enable_network_address_usage_metrics = false [90m-> [90mnull
          - id                                   = "vpc-0e3b272622a64a4fd" [90m-> [90mnull
          - instance_tenancy                     = "default" [90m-> [90mnull
          - ipv6_netmask_length                  = 0 [90m-> [90mnull
          - main_route_table_id                  = "rtb-02b576cb0d84522a8" [90m-> [90mnull
          - owner_id                             = "816376574968" [90m-> [90mnull
          - tags                                 = {
              - "LabName"  = "4.ControlStructures"
              - "Location" = "London"
              - "Name"     = "Main"
            } [90m-> [90mnull
          - tags_all                             = {
              - "Environment" = "Terraform Introduction"
              - "LabName"     = "4.ControlStructures"
              - "Location"    = "London"
              - "Name"        = "Main"
            } [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 3 to destroy.
    
    Changes to Outputs:
      - subnets = [
          - "192.168.100.0/24",
          - "192.168.101.0/24",
        ] [90m-> [90mnull
      - zones   = [
          - "us-west-1b",
          - "us-west-1c",
        ] [90m-> [90mnull
    aws_subnet.vpc_subnets[0]: Destroying... [id=subnet-0fb8e127d9a35f71e]
    aws_subnet.vpc_subnets[1]: Destroying... [id=subnet-03dac58cee0dd0ff5]
    aws_subnet.vpc_subnets[1]: Destruction complete after 1s
    aws_subnet.vpc_subnets[0]: Destruction complete after 2s
    aws_vpc.main_vpc: Destroying... [id=vpc-0e3b272622a64a4fd]
    aws_vpc.main_vpc: Destruction complete after 0s
    
    Destroy complete! Resources: 3 destroyed.
    


To destroy the formerly created AWS vpc, and all subnets.

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this exercise we used the count special attribute to create multiple *aws_subnet* resources,
1 per availabiity_zone.



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab4





<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 1:** Template Directives & String Interpolation

Consider how using Template directives allow to build up an interpolated string where each string contains the
- public_ip
- public_dns
- private_ip
of the *aws_instance* resource

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/new-template-syntax



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal 2:** "for" Expressions

Modify the previous output to convert the availability zone to upper case

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/for-expressions

<hr/>

<!-- Why does this no longer work ??
<img src="../../../static/images/ThickBlueBar.png" />
<img src="../../../static/images/LOGO.jpg" width=200 />
-->

<img src="../images/ThickBlueBar.png" />
<img src="../images/LOGO.jpg" width=200 />


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



