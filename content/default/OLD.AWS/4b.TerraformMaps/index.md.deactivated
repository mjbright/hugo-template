---
title: 'Lab 4b. Terraform maps'
date: 2019-02-11T19:27:37+10:00
weight: 100
---


## Background:

Here, we learn how to create and use terraform maps. Maps are key/value pairs which we can create and look up as we need to in our templates.

## Tasks:
### 1. Make a directory called ‘lab4b’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, resources.tf vars.tf.

The main.tf file should contain:

```tf
provider "aws" {
    region = var.region
}
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

    #cidr_block = element(var.vpc_subnet_cidr,count.index)
    cidr_block = var.vpc_subnet_cidr[count.index]

    #availability_zone = element(var.aaz[var.region],count.index)
    availability_zone = var.aaz[var.region][count.index]

    tags = {
        Name = "subnet-${count.index+1}"
    }
}
```

and your vars.tf file should contain:

```tf
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
``` 

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


### 6. Initialize the configuration

This time we will set the TF_LOG variable to TRACE to see debugging output.

```bash
> TF_LOG=TRACE terraform init
```

Note that the ‘>’ refers to the bash shell prompt and is not part of the command.

This command initializes the terraform directory structure.

Take the time to look at the trace output to see what the *init* process does and where it looks for and stores provider plugin or module files.

This can be particularly useful when build or installing third-party provider plugins manually - to debug possible failure to find the appropriate binaries.

### 7.  Preview the configuration


```bash
> terraform plan
```

This should print out what actions terraform will take.

### 8. Apply the configuration

```bash
> terraform apply
```

Assuming that this works correctly, the AWS Provider will create a VPC, and 3 subnets located in 3 different
availability zones, and an ami instance running on each subnet.

### 9. Create some instances using the vpcs

Now add some new "aws_instance" resources, i.e. VMs, using count to create several.

Output the assigned public_ips of the VMs

Output also a combined output of public_ip, public_dns, private_ip for each VM of the form:
- "public address: <public_ip>[<public_dns>] private address: <private_ip>"

You should use the "*for*" expression to achieve this

### 10. Investigate the *terraform state* sub-command

You can list the resources available in the current state using the ```terraform state list``` command.

Look at the state of one of the listed resources using command ```terraform state show <resource>```, e.g.
- ```terraform state show aws_vpc.main_vpc```
- ```terraform state show aws_instance.example[0]```


### 11. Cleanup

```bash
> terraform destroy
```

To destroy the formerly created AWS vpc, and all subnets.

<hr/>

# Summary

In this Exercise we looked at the use of the *map* type.

We used this type to map from
- region to ami image
- region to availability zones

We then created some VM instances and output their

# **Stretch Goal 1:** Dynamic Blocks

- Add a security group to your VMs, using a dynamic block to specify each ingress rule to allow incoming traffic on ports 22 and 8080
- Investigate the state of the dynamic block you created
- Verify that you can ssh into your instances

You might want to refer to https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples/dynamic-blocks-and-splat-expressions for some hints




