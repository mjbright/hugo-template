---
title:  Lab 7b.TerraformModules-from-github.com
date:   1673290992
weight: 71
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Lab 7b - Using Terraform Modules from github.com



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

In this exercise, we will take a look at the example module:

https://github.com/mjbright/terraform-modules/tree/master/latest-ubuntu-ami

which allows to look up the latest "bionic" ubuntu ami.




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab7b’ underneath the labs directory.
### 2. Change into the directory.

### 3. Create a main.tf for the root-module which will call out to the '*latest-ubuntu-ami*' module

This module refers to "github.com/" as source and so will pull the code down from Github.

The module will be stored in our ~/dot.terraform directory - if our TF_DATA_DIR environment variable is set to that value.

Create a main.tf file there should containing:


```bash
cat main.tf
```

    
    provider "aws" {
        region = var.region
    }
    
    variable "region" {
        description = "the AWS region to use"
    }
    
    variable ami_instance {
        default = "unset"
    }
    
    module "latest-ubuntu-ami" {
        # Reference module latest-ubuntu-ami in github repo github.com/mjbright/terraform-modules
        # NOTE: double-slash to reference subdirectory of the repo:  //modules/latest-ubuntu-ami
        source = "github.com/mjbright/terraform-modules//modules/latest-ubuntu-ami"
        
        # translates to:
        #   git::https://github.com/mjbright/terraform-modules.git
        # To verify try:
        #     rm -rf /home/student/dot.terraform/modules
        #     TF_LOG=trace terraform init |& grep fetch
        
        region = var.region
    }
    
    resource "aws_instance" "example" {
        ami = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS
    
        instance_type = "t2.micro"
        vpc_security_group_ids = [aws_security_group.secgroup-user10.id]
    }
    
    resource "aws_security_group" "secgroup-user10" {
        name = "simple security group - user10"
    
        # Enable incoming ssh connection:
        ingress {
            from_port   = "22"
            to_port     = "22"
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    
    output ami_instance {
      value = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS
    }
    


#### terraform.tfvars

We will also create a terraform.tfvars file to provide a value for the region to use:


```bash
cat terraform.tfvars
```

    
    region="us-west-1"
    


#### Root module

The above  is our root-module which makes a **call** to the 
    "*latest-ubuntu-ami*" module.

### 4. Initialize the root config

To use this module we must first download the module from github - this is done automatically for us when we call either ```terraform get``` or ```terraform init```

**Note:** ```terraform get``` differs in that it downloads modules, but not the Provider plugin.

#### terraform get

Let's perform a ```terraform get``` just to see this in action - it is not a ```necessary``` step as we will perform ```terraform init``` after anyway.

#### terraform init


```bash
terraform init
```

    Initializing modules...
    Downloading git::https://github.com/mjbright/terraform-modules.git for latest-ubuntu-ami...
    - latest-ubuntu-ami in /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami
    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding latest version of hashicorp/aws...
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


### 5. Study the module source files

Now that we have performed ```terraform init``` we see that the module was downloaded from github.com for us and was placed under the ```~/dot.terraform/modules/``` folder.

**Note:** the github repository is ```github.com/mjbright/terraform-modules/``` but we specified a path of ```github.com/mjbright/terraform-modules/latest-ubuntu-ami``` where our module source is located - there could be multiple module sources in that repository.

Look at the files under ```~/dot.terraform/modules/latest-ubuntu-ami/latest-ubuntu-ami```


```bash
find $TF_DATA_DIR/modules/latest-ubuntu-ami/modules
```

    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/main.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/tls_private_key.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/variables.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/setup.sh
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/main.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/data_aws_ami.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/README.md
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_route53_record.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/etc_hosts_delta.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail_key_pair.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/locals.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/data_aws_ami.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail_ports.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_route53_record.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_aws_instance.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/etc_hosts_delta.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_aws_key_pair.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/locals.tf



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/main.tf
```

    
    data "aws_ami" "latest_ubuntu_bionic" {
      most_recent = true
    
      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
      }
    
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    
      owners = ["099720109477"] # Canonical
    }
    
    



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/vars.tf
```

    
    variable "region" { }
    
    



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/outputs.tf
```

    
    output  "amis_latest_ubuntu_bionic_LTS" { value = data.aws_ami.latest_ubuntu_bionic.id }
    


The output value *"amis_latest_ubuntu_bionic_LTS"* will obtain the latest bionic ubuntu image for your region, which was obtained from the "*aws_ami*" data source of the "*aws*" provider.


### 6.  Applying the 'root module' configuration

Apply the configuration and you should see at the end of the apply the ami-instance which was selected for your region.



```bash
terraform apply 
```

    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Reading...
    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Read complete after 1s [id=ami-05bdaab9cff831ca7]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be created
      + resource "aws_instance" "example" {
          + ami                                  = "ami-05bdaab9cff831ca7"
          + arn                                  = (known after apply)
          + associate_public_ip_address          = (known after apply)
          + availability_zone                    = (known after apply)
          + cpu_core_count                       = (known after apply)
          + cpu_threads_per_core                 = (known after apply)
          + disable_api_stop                     = (known after apply)
          + disable_api_termination              = (known after apply)
          + ebs_optimized                        = (known after apply)
          + get_password_data                    = false
          + host_id                              = (known after apply)
          + host_resource_group_arn              = (known after apply)
          + iam_instance_profile                 = (known after apply)
          + id                                   = (known after apply)
          + instance_initiated_shutdown_behavior = (known after apply)
          + instance_state                       = (known after apply)
          + instance_type                        = "t2.micro"
          + ipv6_address_count                   = (known after apply)
          + ipv6_addresses                       = (known after apply)
          + key_name                             = (known after apply)
          + monitoring                           = (known after apply)
          + outpost_arn                          = (known after apply)
          + password_data                        = (known after apply)
          + placement_group                      = (known after apply)
          + placement_partition_number           = (known after apply)
          + primary_network_interface_id         = (known after apply)
          + private_dns                          = (known after apply)
          + private_ip                           = (known after apply)
          + public_dns                           = (known after apply)
          + public_ip                            = (known after apply)
          + secondary_private_ips                = (known after apply)
          + security_groups                      = (known after apply)
          + source_dest_check                    = true
          + subnet_id                            = (known after apply)
          + tags_all                             = (known after apply)
          + tenancy                              = (known after apply)
          + user_data                            = (known after apply)
          + user_data_base64                     = (known after apply)
          + user_data_replace_on_change          = false
          + vpc_security_group_ids               = (known after apply)
    
          + capacity_reservation_specification {
              + capacity_reservation_preference = (known after apply)
    
              + capacity_reservation_target {
                  + capacity_reservation_id                 = (known after apply)
                  + capacity_reservation_resource_group_arn = (known after apply)
                }
            }
    
          + ebs_block_device {
              + delete_on_termination = (known after apply)
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + snapshot_id           = (known after apply)
              + tags                  = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = (known after apply)
              + volume_type           = (known after apply)
            }
    
          + enclave_options {
              + enabled = (known after apply)
            }
    
          + ephemeral_block_device {
              + device_name  = (known after apply)
              + no_device    = (known after apply)
              + virtual_name = (known after apply)
            }
    
          + maintenance_options {
              + auto_recovery = (known after apply)
            }
    
          + metadata_options {
              + http_endpoint               = (known after apply)
              + http_put_response_hop_limit = (known after apply)
              + http_tokens                 = (known after apply)
              + instance_metadata_tags      = (known after apply)
            }
    
          + network_interface {
              + delete_on_termination = (known after apply)
              + device_index          = (known after apply)
              + network_card_index    = (known after apply)
              + network_interface_id  = (known after apply)
            }
    
          + private_dns_name_options {
              + enable_resource_name_dns_a_record    = (known after apply)
              + enable_resource_name_dns_aaaa_record = (known after apply)
              + hostname_type                        = (known after apply)
            }
    
          + root_block_device {
              + delete_on_termination = (known after apply)
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + tags                  = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = (known after apply)
              + volume_type           = (known after apply)
            }
        }
    
      # aws_security_group.secgroup-user10 will be created
      + resource "aws_security_group" "secgroup-user10" {
          + arn                    = (known after apply)
          + description            = "Managed by Terraform"
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = [
              + {
                  + cidr_blocks      = [
                      + "0.0.0.0/0",
                    ]
                  + description      = ""
                  + from_port        = 22
                  + ipv6_cidr_blocks = []
                  + prefix_list_ids  = []
                  + protocol         = "tcp"
                  + security_groups  = []
                  + self             = false
                  + to_port          = 22
                },
            ]
          + name                   = "simple security group - user10"
          + name_prefix            = (known after apply)
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags_all               = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
    Plan: 2 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + ami_instance = "ami-05bdaab9cff831ca7"
    aws_security_group.secgroup-user10: Creating...
    aws_security_group.secgroup-user10: Creation complete after 3s [id=sg-018669c5177c7e214]
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Still creating... [30s elapsed]
    aws_instance.example: Creation complete after 34s [id=i-0b9cca4fc26840125]
    
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    ami_instance = "ami-05bdaab9cff831ca7"


### 8. Cleanup

To destroy the formerly created AWS instance.


```bash
terraform destroy 
```

    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Reading...
    aws_security_group.secgroup-user10: Refreshing state... [id=sg-018669c5177c7e214]
    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Read complete after 1s [id=ami-05bdaab9cff831ca7]
    aws_instance.example: Refreshing state... [id=i-0b9cca4fc26840125]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be destroyed
      - resource "aws_instance" "example" {
          - ami                                  = "ami-05bdaab9cff831ca7" [90m-> [90mnull
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-0b9cca4fc26840125" [90m-> [90mnull
          - associate_public_ip_address          = true [90m-> [90mnull
          - availability_zone                    = "us-west-1c" [90m-> [90mnull
          - cpu_core_count                       = 1 [90m-> [90mnull
          - cpu_threads_per_core                 = 1 [90m-> [90mnull
          - disable_api_stop                     = false [90m-> [90mnull
          - disable_api_termination              = false [90m-> [90mnull
          - ebs_optimized                        = false [90m-> [90mnull
          - get_password_data                    = false [90m-> [90mnull
          - hibernation                          = false [90m-> [90mnull
          - id                                   = "i-0b9cca4fc26840125" [90m-> [90mnull
          - instance_initiated_shutdown_behavior = "stop" [90m-> [90mnull
          - instance_state                       = "running" [90m-> [90mnull
          - instance_type                        = "t2.micro" [90m-> [90mnull
          - ipv6_address_count                   = 0 [90m-> [90mnull
          - ipv6_addresses                       = [] [90m-> [90mnull
          - monitoring                           = false [90m-> [90mnull
          - primary_network_interface_id         = "eni-0a51de6d13eab21fa" [90m-> [90mnull
          - private_dns                          = "ip-172-31-19-209.us-west-1.compute.internal" [90m-> [90mnull
          - private_ip                           = "172.31.19.209" [90m-> [90mnull
          - public_dns                           = "ec2-54-177-223-218.us-west-1.compute.amazonaws.com" [90m-> [90mnull
          - public_ip                            = "54.177.223.218" [90m-> [90mnull
          - secondary_private_ips                = [] [90m-> [90mnull
          - security_groups                      = [
              - "simple security group - user10",
            ] [90m-> [90mnull
          - source_dest_check                    = true [90m-> [90mnull
          - subnet_id                            = "subnet-01f855549f3efdd85" [90m-> [90mnull
          - tags                                 = {} [90m-> [90mnull
          - tags_all                             = {} [90m-> [90mnull
          - tenancy                              = "default" [90m-> [90mnull
          - user_data_replace_on_change          = false [90m-> [90mnull
          - vpc_security_group_ids               = [
              - "sg-018669c5177c7e214",
            ] [90m-> [90mnull
    
          - capacity_reservation_specification {
              - capacity_reservation_preference = "open" [90m-> [90mnull
            }
    
          - credit_specification {
              - cpu_credits = "standard" [90m-> [90mnull
            }
    
          - enclave_options {
              - enabled = false [90m-> [90mnull
            }
    
          - maintenance_options {
              - auto_recovery = "default" [90m-> [90mnull
            }
    
          - metadata_options {
              - http_endpoint               = "enabled" [90m-> [90mnull
              - http_put_response_hop_limit = 1 [90m-> [90mnull
              - http_tokens                 = "optional" [90m-> [90mnull
              - instance_metadata_tags      = "disabled" [90m-> [90mnull
            }
    
          - private_dns_name_options {
              - enable_resource_name_dns_a_record    = false [90m-> [90mnull
              - enable_resource_name_dns_aaaa_record = false [90m-> [90mnull
              - hostname_type                        = "ip-name" [90m-> [90mnull
            }
    
          - root_block_device {
              - delete_on_termination = true [90m-> [90mnull
              - device_name           = "/dev/sda1" [90m-> [90mnull
              - encrypted             = false [90m-> [90mnull
              - iops                  = 100 [90m-> [90mnull
              - tags                  = {} [90m-> [90mnull
              - throughput            = 0 [90m-> [90mnull
              - volume_id             = "vol-019fad3031132552d" [90m-> [90mnull
              - volume_size           = 8 [90m-> [90mnull
              - volume_type           = "gp2" [90m-> [90mnull
            }
        }
    
      # aws_security_group.secgroup-user10 will be destroyed
      - resource "aws_security_group" "secgroup-user10" {
          - arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-018669c5177c7e214" [90m-> [90mnull
          - description            = "Managed by Terraform" [90m-> [90mnull
          - egress                 = [] [90m-> [90mnull
          - id                     = "sg-018669c5177c7e214" [90m-> [90mnull
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
          - name                   = "simple security group - user10" [90m-> [90mnull
          - owner_id               = "816376574968" [90m-> [90mnull
          - revoke_rules_on_delete = false [90m-> [90mnull
          - tags                   = {} [90m-> [90mnull
          - tags_all               = {} [90m-> [90mnull
          - vpc_id                 = "vpc-0c4ad4047839bc08f" [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    
    Changes to Outputs:
      - ami_instance = "ami-05bdaab9cff831ca7" [90m-> [90mnull
    aws_instance.example: Destroying... [id=i-0b9cca4fc26840125]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 10s elapsed]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 20s elapsed]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 30s elapsed]
    aws_instance.example: Destruction complete after 31s
    aws_security_group.secgroup-user10: Destroying... [id=sg-018669c5177c7e214]
    aws_security_group.secgroup-user10: Destruction complete after 1s
    
    Destroy complete! Resources: 2 destroyed.
    




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

- In this section we saw another example of using modules

In this case we specfified a github.com repository as our module source.

The module uses a data_source to obtain a lastest ubuntu aws ami image according to our criteria

<!--



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal:** Change region/ami

Run terraform apply with a different region, e.g. us-east-1, to verify that a different ami is proposed

```TF_VAR_region=us-east-1 terraform apply```
-->



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Stretch Goals



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 1. Modify the module

... you're way ahead of the pack ... try this ...

Clone the module definition using ```git clone https://github.com/mjbright/terraform-modules/``` and place this under a local module directory, then modify your config to use this new module
- git clone the repo
- move the source to modules/mymodule
- modify the module definition to take extra input variables:
  - *release*  : to pull a specific Ubuntu release
  - *num_vms*  : to specify how many instances to create
  - *key_pair* : to pass a tls_private key to use

For *'release'*, you should be able to pass an argument like "focal-20.04", "bionic-18.04", "trusty-14.04" and return a candidate ami



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 2. Create your own module

Create your own module to
- Create your own module to create multiple file instances
- experiment with passing different arguments to the module
- experiment with recuperating output values from the module
- add features such as
  - calculating file checksums
  - create a zip archive file
- Create your own github repository containing the module
- Use the module directly from github - as described at https://www.terraform.io/docs/language/modules/sources.html#github



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 3. Investigate AWS Modules

- Investigate the AWS Modules here: https://registry.terraform.io/namespaces/terraform-aws-modules
- Create EC2 instances using: https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]




<hr/>
<!-- ![](/images/LOGO_v2_CROPPED.jpg) -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Lab 7b - Using Terraform Modules from github.com



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

In this exercise, we will take a look at the example module:

https://github.com/mjbright/terraform-modules/tree/master/latest-ubuntu-ami

which allows to look up the latest "bionic" ubuntu ami.




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab7b’ underneath the labs directory.
### 2. Change into the directory.

### 3. Create a main.tf for the root-module which will call out to the '*latest-ubuntu-ami*' module

This module refers to "github.com/" as source and so will pull the code down from Github.

The module will be stored in our ~/dot.terraform directory - if our TF_DATA_DIR environment variable is set to that value.

Create a main.tf file there should containing:


```bash
cat main.tf
```

    
    provider "aws" {
        region = var.region
    }
    
    variable "region" {
        description = "the AWS region to use"
    }
    
    variable ami_instance {
        default = "unset"
    }
    
    module "latest-ubuntu-ami" {
        # Reference module latest-ubuntu-ami in github repo github.com/mjbright/terraform-modules
        # NOTE: double-slash to reference subdirectory of the repo:  //modules/latest-ubuntu-ami
        source = "github.com/mjbright/terraform-modules//modules/latest-ubuntu-ami"
        
        # translates to:
        #   git::https://github.com/mjbright/terraform-modules.git
        # To verify try:
        #     rm -rf /home/student/dot.terraform/modules
        #     TF_LOG=trace terraform init |& grep fetch
        
        region = var.region
    }
    
    resource "aws_instance" "example" {
        ami = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS
    
        instance_type = "t2.micro"
        vpc_security_group_ids = [aws_security_group.secgroup-user10.id]
    }
    
    resource "aws_security_group" "secgroup-user10" {
        name = "simple security group - user10"
    
        # Enable incoming ssh connection:
        ingress {
            from_port   = "22"
            to_port     = "22"
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
    
    output ami_instance {
      value = module.latest-ubuntu-ami.amis_latest_ubuntu_bionic_LTS
    }
    


#### terraform.tfvars

We will also create a terraform.tfvars file to provide a value for the region to use:


```bash
cat terraform.tfvars
```

    
    region="us-west-1"
    


#### Root module

The above  is our root-module which makes a **call** to the 
    "*latest-ubuntu-ami*" module.

### 4. Initialize the root config

To use this module we must first download the module from github - this is done automatically for us when we call either ```terraform get``` or ```terraform init```

**Note:** ```terraform get``` differs in that it downloads modules, but not the Provider plugin.

#### terraform get

Let's perform a ```terraform get``` just to see this in action - it is not a ```necessary``` step as we will perform ```terraform init``` after anyway.

#### terraform init


```bash
terraform init
```

    Initializing modules...
    Downloading git::https://github.com/mjbright/terraform-modules.git for latest-ubuntu-ami...
    - latest-ubuntu-ami in /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami
    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding latest version of hashicorp/aws...
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


### 5. Study the module source files

Now that we have performed ```terraform init``` we see that the module was downloaded from github.com for us and was placed under the ```~/dot.terraform/modules/``` folder.

**Note:** the github repository is ```github.com/mjbright/terraform-modules/``` but we specified a path of ```github.com/mjbright/terraform-modules/latest-ubuntu-ami``` where our module source is located - there could be multiple module sources in that repository.

Look at the files under ```~/dot.terraform/modules/latest-ubuntu-ami/latest-ubuntu-ami```


```bash
find $TF_DATA_DIR/modules/latest-ubuntu-ami/modules
```

    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/main.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/tls_private_key.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/variables.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/azure-instances/setup.sh
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/main.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/data_aws_ami.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/data-aws-ami/README.md
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_route53_record.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/etc_hosts_delta.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail_key_pair.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/locals.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/data_aws_ami.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-lightsail/resources_aws_lightsail_ports.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_route53_record.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_aws_instance.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/vars.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/etc_hosts_delta.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/resources_aws_key_pair.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/outputs.tf
    /home/student/dot.terraform/modules/latest-ubuntu-ami/modules/aws-instances/locals.tf



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/main.tf
```

    
    data "aws_ami" "latest_ubuntu_bionic" {
      most_recent = true
    
      filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
      }
    
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
    
      owners = ["099720109477"] # Canonical
    }
    
    



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/vars.tf
```

    
    variable "region" { }
    
    



```bash
cat $TF_DATA_DIR/modules/latest-ubuntu-ami/modules/latest-ubuntu-ami/outputs.tf
```

    
    output  "amis_latest_ubuntu_bionic_LTS" { value = data.aws_ami.latest_ubuntu_bionic.id }
    


The output value *"amis_latest_ubuntu_bionic_LTS"* will obtain the latest bionic ubuntu image for your region, which was obtained from the "*aws_ami*" data source of the "*aws*" provider.


### 6.  Applying the 'root module' configuration

Apply the configuration and you should see at the end of the apply the ami-instance which was selected for your region.



```bash
terraform apply 
```

    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Reading...
    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Read complete after 1s [id=ami-05bdaab9cff831ca7]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be created
      + resource "aws_instance" "example" {
          + ami                                  = "ami-05bdaab9cff831ca7"
          + arn                                  = (known after apply)
          + associate_public_ip_address          = (known after apply)
          + availability_zone                    = (known after apply)
          + cpu_core_count                       = (known after apply)
          + cpu_threads_per_core                 = (known after apply)
          + disable_api_stop                     = (known after apply)
          + disable_api_termination              = (known after apply)
          + ebs_optimized                        = (known after apply)
          + get_password_data                    = false
          + host_id                              = (known after apply)
          + host_resource_group_arn              = (known after apply)
          + iam_instance_profile                 = (known after apply)
          + id                                   = (known after apply)
          + instance_initiated_shutdown_behavior = (known after apply)
          + instance_state                       = (known after apply)
          + instance_type                        = "t2.micro"
          + ipv6_address_count                   = (known after apply)
          + ipv6_addresses                       = (known after apply)
          + key_name                             = (known after apply)
          + monitoring                           = (known after apply)
          + outpost_arn                          = (known after apply)
          + password_data                        = (known after apply)
          + placement_group                      = (known after apply)
          + placement_partition_number           = (known after apply)
          + primary_network_interface_id         = (known after apply)
          + private_dns                          = (known after apply)
          + private_ip                           = (known after apply)
          + public_dns                           = (known after apply)
          + public_ip                            = (known after apply)
          + secondary_private_ips                = (known after apply)
          + security_groups                      = (known after apply)
          + source_dest_check                    = true
          + subnet_id                            = (known after apply)
          + tags_all                             = (known after apply)
          + tenancy                              = (known after apply)
          + user_data                            = (known after apply)
          + user_data_base64                     = (known after apply)
          + user_data_replace_on_change          = false
          + vpc_security_group_ids               = (known after apply)
    
          + capacity_reservation_specification {
              + capacity_reservation_preference = (known after apply)
    
              + capacity_reservation_target {
                  + capacity_reservation_id                 = (known after apply)
                  + capacity_reservation_resource_group_arn = (known after apply)
                }
            }
    
          + ebs_block_device {
              + delete_on_termination = (known after apply)
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + snapshot_id           = (known after apply)
              + tags                  = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = (known after apply)
              + volume_type           = (known after apply)
            }
    
          + enclave_options {
              + enabled = (known after apply)
            }
    
          + ephemeral_block_device {
              + device_name  = (known after apply)
              + no_device    = (known after apply)
              + virtual_name = (known after apply)
            }
    
          + maintenance_options {
              + auto_recovery = (known after apply)
            }
    
          + metadata_options {
              + http_endpoint               = (known after apply)
              + http_put_response_hop_limit = (known after apply)
              + http_tokens                 = (known after apply)
              + instance_metadata_tags      = (known after apply)
            }
    
          + network_interface {
              + delete_on_termination = (known after apply)
              + device_index          = (known after apply)
              + network_card_index    = (known after apply)
              + network_interface_id  = (known after apply)
            }
    
          + private_dns_name_options {
              + enable_resource_name_dns_a_record    = (known after apply)
              + enable_resource_name_dns_aaaa_record = (known after apply)
              + hostname_type                        = (known after apply)
            }
    
          + root_block_device {
              + delete_on_termination = (known after apply)
              + device_name           = (known after apply)
              + encrypted             = (known after apply)
              + iops                  = (known after apply)
              + kms_key_id            = (known after apply)
              + tags                  = (known after apply)
              + throughput            = (known after apply)
              + volume_id             = (known after apply)
              + volume_size           = (known after apply)
              + volume_type           = (known after apply)
            }
        }
    
      # aws_security_group.secgroup-user10 will be created
      + resource "aws_security_group" "secgroup-user10" {
          + arn                    = (known after apply)
          + description            = "Managed by Terraform"
          + egress                 = (known after apply)
          + id                     = (known after apply)
          + ingress                = [
              + {
                  + cidr_blocks      = [
                      + "0.0.0.0/0",
                    ]
                  + description      = ""
                  + from_port        = 22
                  + ipv6_cidr_blocks = []
                  + prefix_list_ids  = []
                  + protocol         = "tcp"
                  + security_groups  = []
                  + self             = false
                  + to_port          = 22
                },
            ]
          + name                   = "simple security group - user10"
          + name_prefix            = (known after apply)
          + owner_id               = (known after apply)
          + revoke_rules_on_delete = false
          + tags_all               = (known after apply)
          + vpc_id                 = (known after apply)
        }
    
    Plan: 2 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + ami_instance = "ami-05bdaab9cff831ca7"
    aws_security_group.secgroup-user10: Creating...
    aws_security_group.secgroup-user10: Creation complete after 3s [id=sg-018669c5177c7e214]
    aws_instance.example: Creating...
    aws_instance.example: Still creating... [10s elapsed]
    aws_instance.example: Still creating... [20s elapsed]
    aws_instance.example: Still creating... [30s elapsed]
    aws_instance.example: Creation complete after 34s [id=i-0b9cca4fc26840125]
    
    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    ami_instance = "ami-05bdaab9cff831ca7"


### 8. Cleanup

To destroy the formerly created AWS instance.


```bash
terraform destroy 
```

    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Reading...
    aws_security_group.secgroup-user10: Refreshing state... [id=sg-018669c5177c7e214]
    module.latest-ubuntu-ami.data.aws_ami.latest_ubuntu_bionic: Read complete after 1s [id=ami-05bdaab9cff831ca7]
    aws_instance.example: Refreshing state... [id=i-0b9cca4fc26840125]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be destroyed
      - resource "aws_instance" "example" {
          - ami                                  = "ami-05bdaab9cff831ca7" [90m-> [90mnull
          - arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-0b9cca4fc26840125" [90m-> [90mnull
          - associate_public_ip_address          = true [90m-> [90mnull
          - availability_zone                    = "us-west-1c" [90m-> [90mnull
          - cpu_core_count                       = 1 [90m-> [90mnull
          - cpu_threads_per_core                 = 1 [90m-> [90mnull
          - disable_api_stop                     = false [90m-> [90mnull
          - disable_api_termination              = false [90m-> [90mnull
          - ebs_optimized                        = false [90m-> [90mnull
          - get_password_data                    = false [90m-> [90mnull
          - hibernation                          = false [90m-> [90mnull
          - id                                   = "i-0b9cca4fc26840125" [90m-> [90mnull
          - instance_initiated_shutdown_behavior = "stop" [90m-> [90mnull
          - instance_state                       = "running" [90m-> [90mnull
          - instance_type                        = "t2.micro" [90m-> [90mnull
          - ipv6_address_count                   = 0 [90m-> [90mnull
          - ipv6_addresses                       = [] [90m-> [90mnull
          - monitoring                           = false [90m-> [90mnull
          - primary_network_interface_id         = "eni-0a51de6d13eab21fa" [90m-> [90mnull
          - private_dns                          = "ip-172-31-19-209.us-west-1.compute.internal" [90m-> [90mnull
          - private_ip                           = "172.31.19.209" [90m-> [90mnull
          - public_dns                           = "ec2-54-177-223-218.us-west-1.compute.amazonaws.com" [90m-> [90mnull
          - public_ip                            = "54.177.223.218" [90m-> [90mnull
          - secondary_private_ips                = [] [90m-> [90mnull
          - security_groups                      = [
              - "simple security group - user10",
            ] [90m-> [90mnull
          - source_dest_check                    = true [90m-> [90mnull
          - subnet_id                            = "subnet-01f855549f3efdd85" [90m-> [90mnull
          - tags                                 = {} [90m-> [90mnull
          - tags_all                             = {} [90m-> [90mnull
          - tenancy                              = "default" [90m-> [90mnull
          - user_data_replace_on_change          = false [90m-> [90mnull
          - vpc_security_group_ids               = [
              - "sg-018669c5177c7e214",
            ] [90m-> [90mnull
    
          - capacity_reservation_specification {
              - capacity_reservation_preference = "open" [90m-> [90mnull
            }
    
          - credit_specification {
              - cpu_credits = "standard" [90m-> [90mnull
            }
    
          - enclave_options {
              - enabled = false [90m-> [90mnull
            }
    
          - maintenance_options {
              - auto_recovery = "default" [90m-> [90mnull
            }
    
          - metadata_options {
              - http_endpoint               = "enabled" [90m-> [90mnull
              - http_put_response_hop_limit = 1 [90m-> [90mnull
              - http_tokens                 = "optional" [90m-> [90mnull
              - instance_metadata_tags      = "disabled" [90m-> [90mnull
            }
    
          - private_dns_name_options {
              - enable_resource_name_dns_a_record    = false [90m-> [90mnull
              - enable_resource_name_dns_aaaa_record = false [90m-> [90mnull
              - hostname_type                        = "ip-name" [90m-> [90mnull
            }
    
          - root_block_device {
              - delete_on_termination = true [90m-> [90mnull
              - device_name           = "/dev/sda1" [90m-> [90mnull
              - encrypted             = false [90m-> [90mnull
              - iops                  = 100 [90m-> [90mnull
              - tags                  = {} [90m-> [90mnull
              - throughput            = 0 [90m-> [90mnull
              - volume_id             = "vol-019fad3031132552d" [90m-> [90mnull
              - volume_size           = 8 [90m-> [90mnull
              - volume_type           = "gp2" [90m-> [90mnull
            }
        }
    
      # aws_security_group.secgroup-user10 will be destroyed
      - resource "aws_security_group" "secgroup-user10" {
          - arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-018669c5177c7e214" [90m-> [90mnull
          - description            = "Managed by Terraform" [90m-> [90mnull
          - egress                 = [] [90m-> [90mnull
          - id                     = "sg-018669c5177c7e214" [90m-> [90mnull
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
          - name                   = "simple security group - user10" [90m-> [90mnull
          - owner_id               = "816376574968" [90m-> [90mnull
          - revoke_rules_on_delete = false [90m-> [90mnull
          - tags                   = {} [90m-> [90mnull
          - tags_all               = {} [90m-> [90mnull
          - vpc_id                 = "vpc-0c4ad4047839bc08f" [90m-> [90mnull
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    
    Changes to Outputs:
      - ami_instance = "ami-05bdaab9cff831ca7" [90m-> [90mnull
    aws_instance.example: Destroying... [id=i-0b9cca4fc26840125]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 10s elapsed]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 20s elapsed]
    aws_instance.example: Still destroying... [id=i-0b9cca4fc26840125, 30s elapsed]
    aws_instance.example: Destruction complete after 31s
    aws_security_group.secgroup-user10: Destroying... [id=sg-018669c5177c7e214]
    aws_security_group.secgroup-user10: Destruction complete after 1s
    
    Destroy complete! Resources: 2 destroyed.
    




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

- In this section we saw another example of using modules

In this case we specfified a github.com repository as our module source.

The module uses a data_source to obtain a lastest ubuntu aws ami image according to our criteria

<!--



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal:** Change region/ami

Run terraform apply with a different region, e.g. us-east-1, to verify that a different ami is proposed

```TF_VAR_region=us-east-1 terraform apply```
-->



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Stretch Goals



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 1. Modify the module

... you're way ahead of the pack ... try this ...

Clone the module definition using ```git clone https://github.com/mjbright/terraform-modules/``` and place this under a local module directory, then modify your config to use this new module
- git clone the repo
- move the source to modules/mymodule
- modify the module definition to take extra input variables:
  - *release*  : to pull a specific Ubuntu release
  - *num_vms*  : to specify how many instances to create
  - *key_pair* : to pass a tls_private key to use

For *'release'*, you should be able to pass an argument like "focal-20.04", "bionic-18.04", "trusty-14.04" and return a candidate ami



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 2. Create your own module

Create your own module to
- Create your own module to create multiple file instances
- experiment with passing different arguments to the module
- experiment with recuperating output values from the module
- add features such as
  - calculating file checksums
  - create a zip archive file
- Create your own github repository containing the module
- Use the module directly from github - as described at https://www.terraform.io/docs/language/modules/sources.html#github



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Stretch Goal 3. Investigate AWS Modules

- Investigate the AWS Modules here: https://registry.terraform.io/namespaces/terraform-aws-modules
- Create EC2 instances using: https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]




<hr/>
<!-- ![](../../../static/images/LOGO_v2_CROPPED.jpg) -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />
