---
title: 'Lab 5. Terraform data sources'
date: 2019-02-11T19:27:37+10:00
weight: 100
---


## Background:
Here we learn how to use data sources to get data directly from third parties, rather than defining it ourselves.

## Tasks:
### 1. Make a directory called ‘lab5’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf, vars.tf

The main.tf file should contain:

```tf
provider "aws" {
    region = var.region
}
```

The vars.tf file should contain:
```tf
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
data "aws_availability_zones" "aaz" {}
```
The resources.tf file should contain:
```tf
resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    tags = {
        Name = "Main"
        Location = "London"
    }
}
resource "aws_subnet" "vpc_subnets" {
    count = length(var.vpc_subnet_cidr)
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = element(var.vpc_subnet_cidr,count.index)
    availability_zone = element(data.aws_availability_zones.aaz.names,count.index)
    tags = {
        Name = "subnet-${count.index+1}"
    }
}
```

<!-- NO LONGER NEEDED with linked accounts:
  Note: For each student, change the CIDR for the VPC and subnets to a unique value!
-->

### 4. Output the availability zones data source

Create an outputs.tf
 to show the available "*availability_zones*" from the provider

```tf

output  "aazs"    { value = data.aws_availability_zones.aaz.names }
```

### 5. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>



### 6. Initialize the configuration

```sh
> terraform init
```

Note that the ‘>’ refers to the bash shell prompt and is not part of the command.

This command initializes the terraform directory structure.

### 7.  Preview the configuration


```sh
> terraform plan
```

This should print out what actions terraform will take.

### 8. Apply the configuration

```sh
> terraform apply
```

Assuming that this works correctly, AWS create a VPC, three subnets located in three

different availabilitgy zones, and an ami instance running on each subnet.

### 9. Investigate other data sources available in the AWS resources

Go to https://www.terraform.io/docs/providers/aws/

From there you will need to look for specific services/data sources, e.g.

- "Select "EC2" in the left-hand menu
  - collapse the "Resource" sub-menu
  - expand the "Data Sources" sub-menu
  - look at the example data sources, e.g. aws_instance
  - Write a configuration to create an aws_instance (a VM!)
    - add a tag to identify the instance
  - In the same configuration find your own instance using aws_instance:
    - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance
    - look for running instances and set a filter on
      - the ami_id you are using
      - the tag you are using
  - Experiment with other data sources

### 10. Cleanup

#### Investigating the terraform.tfstate files before & after running *terraform destroy*

Before we destroy our configuration first investigate the terraform.tfstate and it's backup file terraform.tfstate.backup

```sh
ls -al terraform.tfstate*

wc l terraform.tfstate*

more terraform.tfstate
```

Now destroy the configuration of formerly created AWS vpc, and all subnets.

```sh
> terraform destroy
```

Now let's investigate the terraform.tfstate files again

```sh
ls -al terraform.tfstate*

wc l terraform.tfstate*
```

Look at the backuped up state:
```sh
more terraform.tfstate.backup
```

Look at the new empty state:
```sh
more terraform.tfstate.backup
```


