---
title:  Lab 2. Workflow
date:   1673270227
weight: 20
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]







<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Terraform Workflow



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Background:
You should already have the following:

1. A login to the Amazon AWS EC2 *Bastion* instance running Ubuntu Linux



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 1.1 Saving disk space (ONLY NEEDED IF RUNNING ON A SHARED VM)

**Note:** to save disk space you can now remove the terraform binary and use the one located at ```/usr/local/bin/terraform```.
You may need to run 'hash -r' in your bash/zsh shell so that the binary is now found in that location.

**Note:** Also please run the command ```export TF_DATA_DIR=~/dot.terraform``` and add this file into your ```~/.bashrc``` file.  This will avoid making a local copy of the huge AWS provider in each labs directory which we use.

*IFF* you have environment variable **TF_DATA_DIR** set to ~/dot.terraform then *terraform init* will download plugins and modules to that directory.

This is recommended as this will avoid having many many copies of the 163MBy aws provider in *.terraform* littered across all labs directories for each user.

Add the line
```export TF_DATA_DIR=~/dot.terraform```

<!--
Using either

- A ssh command-line client using the provided ```.pem``` key
- Putty, or compatible, line client using the provided ```.ppk``` key
-->

<!--
**Note** that you will have to change the name of the instance to one provided to you by the instructor. 
-->





<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.1 Create the Terraform configuration

### 1. Make a directory called ‘labs’ underneath the home directory.
### 2. Change into the directory.
### 3. Make a directory called lab2, change to that directory




```bash
mkdir -p ~/labs/lab2
cd ~/labs/lab2
```



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2.1.1 Create a file named amis.tf

Create amis.tf with the content shown below.

In the file we define one variable of type map which is assigned a default value mapping the AWS region (string) to an AMI image (string).

the keys of a map are always of type *string*, declaring map(*string*) declares that the values returned by the map will be of type *string*

**Note**: we do not need to specify the type here, but it is good practice.


```bash
cat amis.tf
```

    variable "ami_instance" {
        description = "A mapping from AWS region to Amazon Machine Image"
        type = map(string)
        
        default = {
            "eu-north-1"     = "ami-0567220a328fe4fee"
            "ap-south-1"     = "ami-0237472cf337d9529"
            "eu-west-3"      = "ami-0df03c7641cf41947"
            "eu-west-2"      = "ami-00f94dc949fea2adf"
            "eu-west-1"      = "ami-0e41581acd7dedd99"
            "ap-northeast-2" = "ami-0f4362c71ffaf7759"
            "ap-northeast-1" = "ami-0d5db3e2a1b98ca94"
            "sa-east-1"      = "ami-0065a65613972a22a"
            "ca-central-1"   = "ami-0dbe45195223e250b"
            "ap-southeast-1" = "ami-0c199cae95cea87f0"
            "ap-southeast-2" = "ami-0c0483bc96aef8b2f"
            "eu-central-1"   = "ami-040a1551f9c9d11ad"
            "us-east-1"      = "ami-0d5ae5525eb033d0a"
            "us-east-2"      = "ami-0a7f2b5b6b87eaa1b"
            "us-west-1"      = "ami-00a3e4424e9ab3e56"
            "us-west-2"      = "ami-09c6723c6c24250c9"
        }
    }




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2.1.2 Create the main.tf

In this example we will use
- a map type to map from the AWS region we are using to the particular ami (*Amazon Machine Image*) to use for our *aws_instance*
- an automatcally generated **TLS** key

**Note**: In this example we will
- use the automatically generated **TLS** key to then create an **aws_key_pair** resource.
- extract rsa_pub and pem keys
- use the pem key to connect to our instance using ssh

Later we will see how we can connect using an existing ssh key pair

**Note:** Although presented as a single file here, you are recommended to break it up into separate files e.g. provider.tf, main.tf, variables.tf and outputs.tf

Create the file with the following content:


```bash
cat main.tf
```

    
    terraform {
      required_version = ">= 1.3.0"
    
      required_providers {
        aws = {
          version = "~> 4.40"
        }
      }
    }
    
    provider "aws" {
        region = var.region
    }
    
    variable "region" {
        description = "The region to use"
    }
    
    # NOTE: The AWS 'key pair' is the public/private key pair which
    #       can be used to enable connectivity to EC2 instances
    variable "key_name" {
        description = "The name of the AWS 'key pair' to create"
        default = "my_key"
    }
    
    # An aws_instance is an 'AWS EC2' resource: a virtual machine
    # In our config we can refer to this instance as:
    #     aws_instance.example
    resource "aws_instance" "example" {
        ami = lookup(var.ami_instance,var.region)
        #ami = "ami-0e81aa4c57820bb57"
        instance_type = "t2.micro"
        
        tags = { LabName = "2.Workflow" }
        key_name      = aws_key_pair.generated_key.key_name
    }
    
    # Create a TLS private key  resource
    resource "tls_private_key" "mykey" {
        algorithm = "RSA"
        rsa_bits  = 4096
    }
    
    # Create an AWS 'key pair' resource usable for ssh from the TLS private key
    resource "aws_key_pair" "generated_key" {
        key_name   = var.key_name
        public_key = tls_private_key.mykey.public_key_openssh
    }
    
    
    output  "ssh_rsa_pub_key" { value = tls_private_key.mykey.public_key_openssh }
    
    # NOTE: we mark this element as sensitive information,
    #       to be able to output the value
    output  "ssh_pem_key"     {
      value = tls_private_key.mykey.private_key_pem
      sensitive = true
    }
    
    output  "public_ip"       { value = aws_instance.example.public_ip }
    


Note that you can also use the ```terraform fmt``` command to ```prettify``` your code - by setting indentation correctly.

The command lists the Terraform files it modifies.


```bash
terraform fmt
```

    amis.tf
    main.tf




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.2 Initialize the provider

#### Refer to the init documentation

First refer to the documentation at https://www.terraform.io/docs/commands/init.html.

Investigate the options to this command.


### Set TF_DATA_DIR

Add the entry
```export TF_DATA_DIR=~/dot.terraform```

to the end of your .bashrc file

Source the file ```source ~/.bashrc``` and re-perform ```terraform init```

**Note**: If that environment variable is not set and exported then a new *.terraform* directory will have been created in the directory where you ran *terraform init*.

But the Provider is large - currently more than ```200 MBytes``` so we would prefer to download the provider in a common location, rather than as a sub-directory of each Terraform configuration we create.

#### Terraform init

Run the following command:

This command initializes the terraform directory structure.

You will see output similar to the following showing, note that

- Terraform detected that "*aws*" is specified as a provider and so downloads the appropriate *provider plugin*.



```bash
terraform init
```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.40"...
    - Finding latest version of hashicorp/tls...
    - Installing hashicorp/tls v4.0.4...
    - Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
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


We can see that the aws provider plugin has been downloaded into the ~/dot.terraform folder

(where some older versions may also be present)


```bash
 find ~/dot.terraform -iname '*aws*'

```

    /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64/terraform-provider-aws_v4.49.0_x5




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.3. Run a Terraform plan

#### Refer to the plan documentation

First refer to the documentation at https://www.terraform.io/docs/commands/plan.html.

Investigate the options to this command.

#### Terraform plan

Note that in the above configuration we set the region to the '*region*' variable.

We also declare that variable but we don't give it a value.

So we will find that when we perform a ```terraform plan``` or ```terraform apply``` we are prompted to provide a value for var.region.

Note that the ```description``` used (```The region to use```) in the ```region``` variable definition is used as the prompt for the value below:

```
terraform plan
var.region
  The region to use

  Enter a value:
  ```

You will be prompted to enter a value for the *region* variable as we gave it no value in our aws.tf file.

Type *us-west-1* and press *&lt;ENTER&gt;*

**Note**: alternatively we could have invoked terraform as, ```terraform plan -var region=us-west-1```, passing in the variable value

### Terraform plan actions

- *Terraform plan* will first examine the state of the components managed by this Terraform workspace - as defined in your ```*.tf``` configuration
- It will then update the ```terraform.tfstate``` file to represent this actual state.
- It will then compare the configuration which represents the *desired state* with the *actual state*
- It will report to you any differences
- It will not *apply* or make any changes

#### Reviewing the plan output

This should print out what actions terraform will take.

Look at the output and in particular the *summary line*:

```
Plan: 1 to add, 0 to change, 0 to destroy
```

It is important to know when deploying real infrastructure what changes are to be made, the summary line can be a quick indicator that something might not be as you expect.

When in production, a line of the form

Plan: 0 to add, 10 to change, **31 to destroy**

might make you **think twice!!**

But don't worry a *terraform plan* is safe and will not apply any changes.

#### Adding a default value to the *region* variable

Tired of being prompted to enter a value for the *region* variable?

Let's set a default value in our *main.tf* configuration file. Modify the variable definition as follows in that file:

```
variable "region" {
    description = "The region to use"
    default="us-west-1"
}
```

#### Saving the plan output

We can re-run the plan command as many times as we like, it will always compare the current state of the system with your configuration.

We can also save the output using the *-out* option, e.g. as


```bash
terraform plan -out plan.out
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be created
      + resource "aws_instance" "example" {
          + ami                                  = "ami-00a3e4424e9ab3e56"
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
          + key_name                             = "my_key"
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
          + tags                                 = {
              + "LabName" = "2.Workflow"
            }
          + tags_all                             = {
              + "LabName" = "2.Workflow"
            }
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
    
      # aws_key_pair.generated_key will be created
      + resource "aws_key_pair" "generated_key" {
          + arn             = (known after apply)
          + fingerprint     = (known after apply)
          + id              = (known after apply)
          + key_name        = "my_key"
          + key_name_prefix = (known after apply)
          + key_pair_id     = (known after apply)
          + key_type        = (known after apply)
          + public_key      = (known after apply)
          + tags_all        = (known after apply)
        }
    
      # tls_private_key.mykey will be created
      + resource "tls_private_key" "mykey" {
          + algorithm                     = "RSA"
          + ecdsa_curve                   = "P224"
          + id                            = (known after apply)
          + private_key_openssh           = (sensitive value)
          + private_key_pem               = (sensitive value)
          + private_key_pem_pkcs8         = (sensitive value)
          + public_key_fingerprint_md5    = (known after apply)
          + public_key_fingerprint_sha256 = (known after apply)
          + public_key_openssh            = (known after apply)
          + public_key_pem                = (known after apply)
          + rsa_bits                      = 4096
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + public_ip       = (known after apply)
      + ssh_pem_key     = (sensitive value)
      + ssh_rsa_pub_key = (known after apply)
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Saved the plan to: plan.out
    
    To perform exactly these actions, run the following command to apply:
        terraform apply "plan.out"


**Note**: The generated plan.out file is a binary file intended to be used as an optional parameter to the *terraform apply* comand.



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.4. Apply the configuration

#### Refer to the apply documentation

First refer to the documentation at https://www.terraform.io/docs/commands/apply.html.

Investigate the options to this command.

#### Terraform apply

Now apply this config as before

Assuming that this works correctly, AWS will create a new VM instance

**Note**: We could also use the plan.out file we created earlier using the command *terraform apply plan.out*

**Warning**: The plan.out file will only be valid until the next state-modification, i.e. ```terraform apply``` or ```terraform destroy```.  After such a command the plan.out file should not be reused as it is no longer valid - terraform *should* detect this and refuse to apply the plan.

The *apply* will first build a *plan*, unless a plan file was provided

It will then inform you of the changes to be made, with a *summary line* as before, but this time you will be asked if you want to apply the changes.

You should see something like:

```
Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

If that looks fine to you we can proceed, type *yes* and then *&lt;ENTER&gt;*.

Terraform will then use the *aws provider plugin* to create the appropriate resources - in this case an EC2 virtual machine, taking 20 seconds or so.

```
aws_instance.example: Creating...
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Still creating... [20s elapsed]
aws_instance.example: Creation complete after 22s [id=i-0be7b55b802975868]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.5. Re-apply the configuration

Now let's re-run the apply to see what happens.

You should see something like:


```bash
terraform apply 
```

    tls_private_key.mykey: Refreshing state... [id=8ec77021b97cac2bebfc2551824fdeaaf9359299]
    aws_key_pair.generated_key: Refreshing state... [id=my_key]
    aws_instance.example: Refreshing state... [id=i-01e0aa7b482e69908]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT


Note that this time nothing changes - why is that?



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.6. Inspect the terraform.tfstate file


```bash
 cat terraform.tfstate

```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 5,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {
        "public_ip": {
          "value": "13.57.185.56",
          "type": "string"
        },
        "ssh_pem_key": {
          "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
          "type": "string",
          "sensitive": true
        },
    ....


What information does it contain?

What format is this file in?

Well since it's in that format we can parse it using jq, e.g. to get the private ip address of the VM:


```bash
jq -M '.resources[].instances[].attributes.private_ip' terraform.tfstate
```

    "172.31.29.108"
    null
    null


The above matches also on resources not of type "*aws_instance*".

We can select only the "*aws_instance*" resources by detecting the presence of the *ami* attribute (Amazon Machine Image) as shown below:


```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes.private_ip' \
    terraform.tfstate 
```

    "172.31.29.108"


Below are some more examples:


```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes.public_ip'\
    terraform.tfstate 
```

    "13.57.185.56"



```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes |
  .public_dns'\
    terraform.tfstate 
```

    "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"



```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes |
  { public_dns, public_ip, private_ip }' \
    terraform.tfstate
```

    {
      "public_dns": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
      "public_ip": "13.57.185.56",
      "private_ip": "172.31.29.108"
    }


Of course there are other *terraform* ways to obtain this information


```bash
terraform output
```

    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT



```bash
terraform show
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-01e0aa7b482e69908"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-01e0aa7b482e69908"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-01fe4ed51b2e080d7"
        private_dns                          = "ip-172-31-29-108.us-west-1.compute.internal"
        private_ip                           = "172.31.29.108"
        public_dns                           = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.185.56"
        secondary_private_ips                = []
        security_groups                      = [
            "default",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-07e7db9f93d86103e",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-062272a8c172bfbcd"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }
    
    # aws_key_pair.generated_key:
    resource "aws_key_pair" "generated_key" {
        arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key"
        fingerprint = "31:07:72:7c:21:09:58:62:f3:53:c7:6f:ef:a6:a1:05"
        id          = "my_key"
        key_name    = "my_key"
        key_pair_id = "key-0fde9c933239986df"
        key_type    = "rsa"
        public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ=="
        tags        = {}
        tags_all    = {}
    }
    
    # tls_private_key.mykey:
    resource "tls_private_key" "mykey" {
        algorithm                     = "RSA"
        ecdsa_curve                   = "P224"
        id                            = "8ec77021b97cac2bebfc2551824fdeaaf9359299"
        private_key_openssh           = (sensitive value)
        private_key_pem               = (sensitive value)
        private_key_pem_pkcs8         = (sensitive value)
        public_key_fingerprint_md5    = "55:2b:31:bb:16:a9:b3:c1:35:df:38:e6:11:64:af:8e"
        public_key_fingerprint_sha256 = "SHA256:2W9TUM5xWaBqados7kQUnR5P6Z0mAZ7LqXL4i5ttHek"
        public_key_openssh            = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
        EOT
        public_key_pem                = <<-EOT
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAowH8NyOxTtaItgPko4uk
            hVnBnOlx7WhBGm0pCxZ51CYVYLjde3W919QWjD0bMh6pj6EIOun95ZJTIO1BIn4+
            WZNWjWJwtZS5pZhlOvb5aU1RviMGyegjEK/qyN9ZHLddLr1Fx/DR4OQyxVAe+X6Z
            g2WkyZc5XzyLjuPhope3cpJ5DrGFKnlJyHngoKwdOyk/vQcZOxvo8kiHzzfA9l2B
            hitoY5TFp9yvxomuJQ7XypmhIP+eCimApmWK+U1HDP3tXbaJnW+8RIsGBkrCaINq
            kmHWzNXtq+UrFgWT/eebyMYOWdQ9lL7zrBomC/D3oxb0JKc919FvfMVXcMKuCEKS
            Qu7CtdyS0EA6NAT5+HU0PrmB8X2wmXPuRSmBTgF5avMgKd3kbxC13ENLrPe1u8HM
            axOpaKKWUEyj74xHI07M2E7V1p2f3YOPD4m/T+3P3TNsFlypwb983wHkRZ3LOlEQ
            oNSZ0CI5Gm343Vz+6WjapazyiGDiLzxBgdBj7mHzco1F+RsMdowBIRTPQsTtwkR4
            R5MxgZaIiMrAWPpVQ6whrtZk+VAG2isgKJFeFByaF4cDTRkPBHgt0YXsT9Airut5
            5v+lhsxhbem5NYF7f72xn+7toU+5z2AwxMd4tgC+IX43ZJUVXoNlFjDR88c+ScI7
            qsz101OBufGcHLqxueGfsw0CAwEAAQ==
            -----END PUBLIC KEY-----
        EOT
        rsa_bits                      = 4096
    }
    
    
    Outputs:
    
    public_ip = "13.57.185.56"
    ssh_pem_key = (sensitive value)
    ssh_rsa_pub_key = <<-EOT
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    EOT



```bash
terraform state list
```

    aws_instance.example
    aws_key_pair.generated_key
    tls_private_key.mykey



```bash
terraform state show aws_instance.example
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-01e0aa7b482e69908"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-01e0aa7b482e69908"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-01fe4ed51b2e080d7"
        private_dns                          = "ip-172-31-29-108.us-west-1.compute.internal"
        private_ip                           = "172.31.29.108"
        public_dns                           = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.185.56"
        secondary_private_ips                = []
        security_groups                      = [
            "default",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-07e7db9f93d86103e",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-062272a8c172bfbcd"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }



```bash
grep public_ip terraform.tfstate
```

        "public_ip": {
                "associate_public_ip_address": true,
                "public_ip": "13.57.185.56",



```bash
terraform show | grep "^public_ip"
```

    public_ip = "13.57.185.56"


would have got us the information in a more direct but less programmatic manner


### 11. Connecting to your VM

#### Get the public address of your VM using one of the above methods




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.  Connect to the VM



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.1  Create & use a key pair in the VM config

We could refer to an existing ```AWS key pair``` to allow connection using ssh.

In our example we had Terraform create the ```TLS private key``` and ```AWS key pair``` for us.

This is very convenient and will allow us to create/destroy the key pair along with any other resources of this config.

We can obtain the keypem using the ```ssh_pem_key``` output we declared:

``` terraform output ssh_pem_key | grep -v EOT > key.pem
chmod 600 key.pem```

### Create a key.pem ```local_file``` resource

or a better way would be to create a local file with this value, we can do this by adding a ```local_file``` resource into our configuration

Add the following lines, then perform a ```terraform plan``` and ```terraform apply``` - note in doing so that a single new resource, the ```local_file``` resource will be added:

```resource "local_file" "pem_key" {
  filename        = "key.pem"
  content         = tls_private_key.mykey.private_key_pem
  file_permission = 0600
}```




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.2  Connect to the VM


Try to connect to that address from the bastion using the ssh client, using the provided vm.pem key:


```bash
pwd
ls -al key.pem
```

    /home/student/labs/lab2
    -rw------- 1 student student 3243 Jan  9 13:51 key.pem



```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP uptime
```

    ssh: connect to host 13.57.185.56 port 22: Connection timed out




### ssh connection timeout !!

**Note**: The connection times out ... because we haven't opened port 22 yet ... as we didn't create an *AWS* security group yet 

**Note:** By default AWS doesn't allow any incoming or outgoing traffic, which is a good best practice.  With this ```least privilege``` security approach we must explicitly create a ```security group``` specifying which tcp/udp ports are to be enabled for ```ingress``` and ```traffic```

### 12. Edit the file main.tf

Add the following lines to create a security group allowing incoming ```SSH``` traffic on port 22:


```bash

```

    resource "aws_security_group" "secgroup-ssh" {
      name = "simple security group - for ssh Ingress only"
    
      # Enable incoming ssh connection:
      ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    


also add the following line into the "aws_instance" resource definition:

```
vpc_security_group_ids = [aws_security_group.secgroup-ssh.id]
```




Then perform a ```terraform apply```.

Note the summary line of the proposed changes:

```
tls_private_key.mykey: Refreshing state... [id=77d192e85f856403494c160f78933012b0f02c8c]
aws_key_pair.generated_key: Refreshing state... [id=my_key]
aws_instance.example: Refreshing state... [id=i-05331b82bf9a7ad2f]
aws_security_group.secgroup-ssh: Creating...
aws_security_group.secgroup-ssh: Creation complete after 5s [id=sg-0058898a0755cdd94]
aws_instance.example: Modifying... [id=i-05331b82bf9a7ad2f]
aws_instance.example: Modifications complete after 6s [id=i-05331b82bf9a7ad2f]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.
```

Note that the ```security group``` is added, and that the ```aws_instance``` is changed (without needing to destroy/recreate the VM)

```Plan: 1 to add, 1 to change, 0 to destroy.```


```bash
terraform output public_ip 

IP=$( terraform output public_ip  | sed 's/"//g' )
```

    "13.57.185.56"


Note that this does not replace our VM instance already created, it makes a change to the instance resource and adds a new EC2 security group resource.


Now try again to connect to the public address.

This time you should be prompted with

```Are you sure you want to continue connecting (yes/no)?```

Answer 'yes' and you should then be connected to the VM.


```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP uptime
```

     14:01:17 up 35 min,  0 users,  load average: 0.00, 0.00, 0.00



```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP \
  'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'
```

    hostname[ip-172-31-29-108]: Linux/4.15.0-1052-aws 14:01:22 up 35 min, 0 users, load average: 0.00, 0.00, 0.00


**Success !!**

### 13. Specifying output variables

Now let's see how we can output specific variables

Add the following lines to the *main.tf* file:


```bash

```

    output  "private_ip"    { value = aws_instance.example.private_ip }
    output  "public_dns"    { value = aws_instance.example.public_dns }


Re-run ```terraform apply```, you should see the output fields on the console.

### terraform output

At any time we can view the ```outputs``` using the ```terraform output``` command:

**Note:** the terraform output command only reads the outputs from the ```terraform.tfstate```, so it is possible that the values are out of date if the configuration has ```drifted```, e.g. if someone has deleted an AWS resource bypassing ```terraform```.


```bash
terraform output
```

    private_ip = "172.31.29.108"
    public_dns = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT


Look at the new terraform.state file, you should see the output fields there also in json format.

Perform a ```diff terraform.tfstate terraform.tfstate.backup``` to see the difference.

We can also use Python to extract those fields explicitly from the json-formated *terraform.tfstate* file:


```bash
python3 -c \
  'import sys, json;
print(json.dumps(json.load(sys.stdin)["outputs"],indent=2))' \
  < terraform.tfstate
```

    {
      "private_ip": {
        "value": "172.31.29.108",
        "type": "string"
      },
      "public_dns": {
        "value": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
        "type": "string"
      },
      "public_ip": {
        "value": "13.57.185.56",
        "type": "string"
      },
      "ssh_pem_key": {
        "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
        "type": "string",
        "sensitive": true
      },
      "ssh_rsa_pub_key": {
        "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==\n",
        "type": "string"
      }
    }


or you may use the *jq* tool:


```bash
jq -M '.outputs' terraform.tfstate
```

    {
      "private_ip": {
        "value": "172.31.29.108",
        "type": "string"
      },
      "public_dns": {
        "value": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
        "type": "string"
      },
      "public_ip": {
        "value": "13.57.185.56",
        "type": "string"
      },
      "ssh_pem_key": {
        "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
        "type": "string",
        "sensitive": true
      },
      "ssh_rsa_pub_key": {
        "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==\n",
        "type": "string"
      }
    }


Later we will see how we can execute commands using provisioners, which we could also use to output specific information.

### 14. using an existing ssh key file

Previously we saw how we could auto-generate a *TLS key* and then an *aws_key_pair* resource allowing us to connect to our VM using ssh.

Those keys are part of the resources managed from Terraform and will be destroyed when the config is destroyed.

In this section we will look at how we can use and existing ssh key file, or aws_key_pair, indepedently of this Terraform configuration.

#### Remove the tls_private_key definition and outputs

We will not auto-generate the TLS key this time so we will

- Remove the resource from the main.tf file.
- Remove also the 2 output lines for "*ssh_rsa_pub_key*" "*ssh_pem_key*" which can no longer be used.
- Delete the local mykey.pem file

#### Modify the public_key attribute setting

We will now modify the aws_key_pair definition resource to obtain the public_key definition from a local file:

```
    public_key = file("~/.ssh/id_rsa.pub")
```

Change also the name of the *aws_key_pair* resource by changing the *default* value of the *key_name* variable to me "*my_rsa_key*"

**Note:** You may need to generate the ssh key first - do this with command:

```ssh-keygen -t rsa -N ''```

#### Taint the ```aws_instance``` resource

We need to destroy/re-create the ```aws_instance``` resource.

We can do this by using ```terraform destroy``` then ```terraform apply``` but this would destroy/recreate all resources of the configuration.

We can avoid this by either
- Performing the destroy only on ```aws_instance.example``` as ```terraform destroy -target aws_instance.example``` before performing ```terraform apply```
- ```Tainting``` the ```aws_instance.example``` so that it will be recreated at the next ```terraform apply```

Taint the resource using commands:
```terraform taint aws_instance.example```

#### Re-apply the configuration

**Note:** You may need to remove the ```local_file``` ```pem_key``` resource you created earlier

Run ```terraform apply``` with this new configuration.

**Note:**
- that the *tls-private-key* resource is deleted
- The *aws_key_pair* and *aws_instance* resources are destroyed and then re-created

#### Connect to the VM using the local key

Note that the new instance will have changed IP address.

set the IP variable to that value and try to connect using the following ssh command.

**Note** that now we use the ~/.ssh/id_rsa **private_key**


You will again be prompted to accept the key (for the known_hosts file):

```
Are you sure you want to continue connecting (yes/no)?
```

Answer 'yes' and you should then be connected to the VM.


```bash
ssh -i ~/.ssh/id_rsa -o ConnectTimeout=4 ubuntu@"13.57.20.240" \
    uptime
```

     14:07:04 up 1 min,  0 users,  load average: 0.27, 0.09, 0.03



```bash
ssh -i ~/.ssh/id_rsa -o ConnectTimeout=4 ubuntu@"13.57.20.240" \
    'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'
```

    hostname[ip-172-31-16-89]: Linux/4.15.0-1052-aws 14:07:08 up 1 min, 0 users, load average: 0.27, 0.09, 0.03


**Success !!**


### 15. Tagging resources

We can also add tags to resources, using literal strings or variables or data sources.

Note that the tags we specified earlier are associated with our VM instance.

You can verify this using either
- aws ec2 describe-instances
- /usr/local/bin/get_instances.sh

e.g.

```
/usr/local/bin/get_instances.sh
{"id":"i-0e5fe7594eed0330d","image":"ami-00a3e4424e9ab3e56","state":"running","Tags":[{"Key":"LabName","Value":"2.Workflow"}],"LaunchTime":"2021-02-02T13:55:01.000Z"}
```

Apply this new configuration and then compare the tfstate with the backup.
You should see that the tags have been added to the resource state.


### 16. Create a graph of resources in the current config
We can generate a graphviz format file representing the graph of resources represented by the current configuration.
**Note:** We speak here of the configuration as represented by the group of .tf files, not the actual state


```bash
terraform graph
```

    digraph {
    	compound = "true"
    	newrank = "true"
    	subgraph "root" {
    		"[root] aws_instance.example (expand)" [label = "aws_instance.example", shape = "box"]
    		"[root] aws_key_pair.generated_key (expand)" [label = "aws_key_pair.generated_key", shape = "box"]
    		"[root] aws_security_group.secgroup-ssh (expand)" [label = "aws_security_group.secgroup-ssh", shape = "box"]
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"]" [label = "provider[\"registry.terraform.io/hashicorp/aws\"]", shape = "diamond"]
    		"[root] var.ami_instance" [label = "var.ami_instance", shape = "note"]
    		"[root] var.key_name" [label = "var.key_name", shape = "note"]
    		"[root] var.region" [label = "var.region", shape = "note"]
    		"[root] aws_instance.example (expand)" -> "[root] aws_key_pair.generated_key (expand)"
    		"[root] aws_instance.example (expand)" -> "[root] aws_security_group.secgroup-ssh (expand)"
    		"[root] aws_instance.example (expand)" -> "[root] var.ami_instance"
    		"[root] aws_key_pair.generated_key (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
    		"[root] aws_key_pair.generated_key (expand)" -> "[root] var.key_name"
    		"[root] aws_security_group.secgroup-ssh (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
    		"[root] output.private_ip (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] output.public_dns (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] output.public_ip (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)" -> "[root] aws_instance.example (expand)"
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"]" -> "[root] var.region"
    		"[root] root" -> "[root] output.private_ip (expand)"
    		"[root] root" -> "[root] output.public_dns (expand)"
    		"[root] root" -> "[root] output.public_ip (expand)"
    		"[root] root" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)"
    	}
    }
    


We can display this by performing the following steps:


```bash
terraform graph | dot -Tsvg > graph.svg
```

    
    Command 'dot' not found, but can be installed with:
    
    sudo apt install graphviz
    





```bash
sudo apt install -y graphviz
```

    Reading package lists... 0%Reading package lists... 100%Reading package lists... Done
    Building dependency tree... 0%Building dependency tree... 0%Building dependency tree... 50%Building dependency tree... 50%Building dependency tree       
    Reading state information... 0%Reading state information... 0%Reading state information... Done
    The following packages were automatically installed and are no longer required:
      linux-headers-5.4.0-120 linux-headers-5.4.0-120-generic
      linux-image-5.4.0-120-generic linux-modules-5.4.0-120-generic
    Use 'sudo apt autoremove' to remove them.
    The following additional packages will be installed:
      fonts-liberation libann0 libcdt5 libcgraph6 libgts-0.7-5 libgts-bin libgvc6
      libgvpr2 liblab-gamut1 libpathplan4
    Suggested packages:
      graphviz-doc
    The following NEW packages will be installed:
      fonts-liberation graphviz libann0 libcdt5 libcgraph6 libgts-0.7-5 libgts-bin
      libgvc6 libgvpr2 liblab-gamut1 libpathplan4
    0 upgraded, 11 newly installed, 0 to remove and 0 not upgraded.
    Need to get 2,701 kB of archives.
    After this operation, 11.3 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 fonts-liberation all 1:1.07.4-11 [822 kB]
    Get:2 http://archive.ubuntu.com/ubuntu focal/universe amd64 libann0 amd64 1.1.2+doc-7build1 [26.0 kB]
    Get:3 http://archive.ubuntu.com/ubuntu focal/universe amd64 libcdt5 amd64 2.42.2-3build2 [18.7 kB]
    Get:4 http://archive.ubuntu.com/ubuntu focal/universe amd64 libcgraph6 amd64 2.42.2-3build2 [41.3 kB]
    Get:5 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgts-0.7-5 amd64 0.7.6+darcs121130-4 [150 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal/universe amd64 libpathplan4 amd64 2.42.2-3build2 [21.9 kB]
    Get:7 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgvc6 amd64 2.42.2-3build2 [647 kB]
    Get:8 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgvpr2 amd64 2.42.2-3build2 [167 kB]
    Get:9 http://archive.ubuntu.com/ubuntu focal/universe amd64 liblab-gamut1 amd64 2.42.2-3build2 [177 kB]
    Get:10 http://archive.ubuntu.com/ubuntu focal/universe amd64 graphviz amd64 2.42.2-3build2 [590 kB]
    Get:11 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgts-bin amd64 0.7.6+darcs121130-4 [41.3 kB]
    Fetched 2,701 kB in 1s (2,243 kB/s)[0m
    
    7[0;23r8[1ASelecting previously unselected package fonts-liberation.
    (Reading database ... 142715 files and directories currently installed.)
    Preparing to unpack .../00-fonts-liberation_1%3a1.07.4-11_all.deb ...
    7[24;0f[42mProgress: [  0%][49m[39m [..........................................................] 87[24;0f[42mProgress: [  2%][49m[39m [#.........................................................] 8Unpacking fonts-liberation (1:1.07.4-11) ...
    7[24;0f[42mProgress: [  4%][49m[39m [##........................................................] 8Selecting previously unselected package libann0.
    Preparing to unpack .../01-libann0_1.1.2+doc-7build1_amd64.deb ...
    7[24;0f[42mProgress: [  7%][49m[39m [###.......................................................] 8Unpacking libann0 (1.1.2+doc-7build1) ...
    7[24;0f[42mProgress: [  9%][49m[39m [#####.....................................................] 8Selecting previously unselected package libcdt5:amd64.
    Preparing to unpack .../02-libcdt5_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 11%][49m[39m [######....................................................] 8Unpacking libcdt5:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 13%][49m[39m [#######...................................................] 8Selecting previously unselected package libcgraph6:amd64.
    Preparing to unpack .../03-libcgraph6_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 16%][49m[39m [#########.................................................] 8Unpacking libcgraph6:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 18%][49m[39m [##########................................................] 8Selecting previously unselected package libgts-0.7-5:amd64.
    Preparing to unpack .../04-libgts-0.7-5_0.7.6+darcs121130-4_amd64.deb ...
    7[24;0f[42mProgress: [ 20%][49m[39m [###########...............................................] 8Unpacking libgts-0.7-5:amd64 (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 22%][49m[39m [############..............................................] 8Selecting previously unselected package libpathplan4:amd64.
    Preparing to unpack .../05-libpathplan4_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 24%][49m[39m [##############............................................] 8Unpacking libpathplan4:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 27%][49m[39m [###############...........................................] 8Selecting previously unselected package libgvc6.
    Preparing to unpack .../06-libgvc6_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 29%][49m[39m [################..........................................] 8Unpacking libgvc6 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 31%][49m[39m [##################........................................] 8Selecting previously unselected package libgvpr2:amd64.
    Preparing to unpack .../07-libgvpr2_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 33%][49m[39m [###################.......................................] 8Unpacking libgvpr2:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 36%][49m[39m [####################......................................] 8Selecting previously unselected package liblab-gamut1:amd64.
    Preparing to unpack .../08-liblab-gamut1_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 38%][49m[39m [#####################.....................................] 8Unpacking liblab-gamut1:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 40%][49m[39m [#######################...................................] 8Selecting previously unselected package graphviz.
    Preparing to unpack .../09-graphviz_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 42%][49m[39m [########################..................................] 8Unpacking graphviz (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 44%][49m[39m [#########################.................................] 8Selecting previously unselected package libgts-bin.
    Preparing to unpack .../10-libgts-bin_0.7.6+darcs121130-4_amd64.deb ...
    7[24;0f[42mProgress: [ 47%][49m[39m [###########################...............................] 8Unpacking libgts-bin (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 49%][49m[39m [############################..............................] 8Setting up liblab-gamut1:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 51%][49m[39m [#############################.............................] 87[24;0f[42mProgress: [ 53%][49m[39m [##############################............................] 8Setting up libgts-0.7-5:amd64 (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 56%][49m[39m [################################..........................] 87[24;0f[42mProgress: [ 58%][49m[39m [#################################.........................] 8Setting up libpathplan4:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 60%][49m[39m [##################################........................] 87[24;0f[42mProgress: [ 62%][49m[39m [####################################......................] 8Setting up libann0 (1.1.2+doc-7build1) ...
    7[24;0f[42mProgress: [ 64%][49m[39m [#####################################.....................] 87[24;0f[42mProgress: [ 67%][49m[39m [######################################....................] 8Setting up fonts-liberation (1:1.07.4-11) ...
    7[24;0f[42mProgress: [ 69%][49m[39m [#######################################...................] 87[24;0f[42mProgress: [ 71%][49m[39m [#########################################.................] 8Setting up libcdt5:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 73%][49m[39m [##########################################................] 87[24;0f[42mProgress: [ 76%][49m[39m [###########################################...............] 8Setting up libcgraph6:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 78%][49m[39m [#############################################.............] 87[24;0f[42mProgress: [ 80%][49m[39m [##############################################............] 8Setting up libgts-bin (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 82%][49m[39m [###############################################...........] 87[24;0f[42mProgress: [ 84%][49m[39m [################################################..........] 8Setting up libgvc6 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 87%][49m[39m [##################################################........] 87[24;0f[42mProgress: [ 89%][49m[39m [###################################################.......] 8Setting up libgvpr2:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 91%][49m[39m [####################################################......] 87[24;0f[42mProgress: [ 93%][49m[39m [######################################################....] 8Setting up graphviz (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 96%][49m[39m [#######################################################...] 87[24;0f[42mProgress: [ 98%][49m[39m [########################################################..] 8Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
    Processing triggers for man-db (2.9.1-1) ...
    Processing triggers for fontconfig (2.13.1-2ubuntu3) ...
    
    7[0;24r8[1A[J



```bash
terraform graph | dot -Tsvg > graph.svg
```

Now we can serve this file using the command
**Note**: Choose port number 31001 if you are user1, 31002 uf you are user2 etc ...

As student20:
```
python3 -m http.server --bind 0.0.0.0 31020
```


**Note:** This step will require intervention from your instructor ...

With a browser navigate to http://&lt;BASTION_HOST&gt;:&lt;:PORT&gt;/graph.svg
e.g. http://bastion-ls.mjbright.click:31020/graph.svg

You should see something similar to:

<!-- <div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div> -->

<img src="graph.svg" />

**Note**: You may have difficulties to view the svg, if so try with a different browser

See https://www.terraform.io/docs/commands/graph.html for more information about using the graph sub-command.

### Other ways of displaying the graph

#### graphvizOnline

Copy the ```terraform graph``` output and post it to the web page https://dreampuf.github.io/GraphvizOnline

#### Blast Radius

Another tool which can be used is ```blast radius``` at https://28mm.github.io/blast-radius-docs/

#### BrainBoard

Brainboard, https://www.brainboard.co, seems to be a really interesting option, but has now become a paid for service - after the 21 days free trial period.

### 17. Cleanup

Destroy the resources generated in this lab using ```terraform destroy```

This will now destroy the formerly created AWS vpc, and all subnets.

You should see something similar to

```
Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.example: Destroying... [id=i-0ee33d3ff92efccaa]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 10s elapsed]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 20s elapsed]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 30s elapsed]
aws_instance.example: Destruction complete after 40s
aws_key_pair.generated_key: Destroying... [id=my_key]
aws_security_group.secgroup-ssh: Destroying... [id=sg-08d41669346adc461]
aws_key_pair.generated_key: Destruction complete after 0s
aws_security_group.secgroup-ssh: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```

### 18. Inspecting the previous state

If you now perform a ```terraform show``` you will see no resources as they were just destroyed

If we look at files in the directory we should see the previous state has been stored as
terraform.tfstate.backup.


```bash
ls -al terraform.tfstate*
```

    -rw-rw-r-- 1 student student  181 Jan  9 14:15 terraform.tfstate
    -rw-rw-r-- 1 student student 7723 Jan  9 14:15 terraform.tfstate.backup


#### Look at terraform.tfstate

The new state is now empty of resources:


```bash
cat terraform.tfstate
```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 23,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {},
      "resources": [],
      "check_results": null
    }


#### Look at terraform.tfstate.backup

Inspect the previous state using:


```bash
cat terraform.tfstate.backup
```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 19,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {
        "private_ip": {
          "value": "172.31.16.89",
          "type": "string"
        },
        "public_dns": {
          "value": "ec2-13-57-20-240.us-west-1.compute.amazonaws.com",
          "type": "string"
        },
        "public_ip": {
          "value": "13.57.20.240",
          "type": "string"
        }
      },
      "resources": [
        {
          "mode": "managed",
          "type": "aws_instance",
          "name": "example",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "ami": "ami-00a3e4424e9ab3e56",
                "arn": "arn:aws:ec2:us-west-1:816376574968:instance/i-0ae9425e491550cda",
                "associate_public_ip_address": true,
                "availability_zone": "us-west-1c",
                "capacity_reservation_specification": [
                  {
                    "capacity_reservation_preference": "open",
                    "capacity_reservation_target": []
                  }
                ],
                "cpu_core_count": 1,
                "cpu_threads_per_core": 1,
                "credit_specification": [
                  {
                    "cpu_credits": "standard"
                  }
                ],
                "disable_api_stop": false,
                "disable_api_termination": false,
                "ebs_block_device": [],
                "ebs_optimized": false,
                "enclave_options": [
                  {
                    "enabled": false
                  }
                ],
                "ephemeral_block_device": [],
                "get_password_data": false,
                "hibernation": false,
                "host_id": null,
                "host_resource_group_arn": null,
                "iam_instance_profile": "",
                "id": "i-0ae9425e491550cda",
                "instance_initiated_shutdown_behavior": "stop",
                "instance_state": "running",
                "instance_type": "t2.micro",
                "ipv6_address_count": 0,
                "ipv6_addresses": [],
                "key_name": "my_key",
                "launch_template": [],
                "maintenance_options": [
                  {
                    "auto_recovery": "default"
                  }
                ],
                "metadata_options": [
                  {
                    "http_endpoint": "enabled",
                    "http_put_response_hop_limit": 1,
                    "http_tokens": "optional",
                    "instance_metadata_tags": "disabled"
                  }
                ],
                "monitoring": false,
                "network_interface": [],
                "outpost_arn": "",
                "password_data": "",
                "placement_group": "",
                "placement_partition_number": null,
                "primary_network_interface_id": "eni-06b93fa31818b764a",
                "private_dns": "ip-172-31-16-89.us-west-1.compute.internal",
                "private_dns_name_options": [
                  {
                    "enable_resource_name_dns_a_record": false,
                    "enable_resource_name_dns_aaaa_record": false,
                    "hostname_type": "ip-name"
                  }
                ],
                "private_ip": "172.31.16.89",
                "public_dns": "ec2-13-57-20-240.us-west-1.compute.amazonaws.com",
                "public_ip": "13.57.20.240",
                "root_block_device": [
                  {
                    "delete_on_termination": true,
                    "device_name": "/dev/sda1",
                    "encrypted": false,
                    "iops": 100,
                    "kms_key_id": "",
                    "tags": {},
                    "throughput": 0,
                    "volume_id": "vol-01f0b4cfdd3eff669",
                    "volume_size": 8,
                    "volume_type": "gp2"
                  }
                ],
                "secondary_private_ips": [],
                "security_groups": [
                  "simple security group - for ssh Ingress only"
                ],
                "source_dest_check": true,
                "subnet_id": "subnet-01f855549f3efdd85",
                "tags": {
                  "LabName": "2.Workflow"
                },
                "tags_all": {
                  "LabName": "2.Workflow"
                },
                "tenancy": "default",
                "timeouts": null,
                "user_data": null,
                "user_data_base64": null,
                "user_data_replace_on_change": false,
                "volume_tags": null,
                "vpc_security_group_ids": [
                  "sg-0496213da9e7902ed"
                ]
              },
              "sensitive_attributes": [],
              "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6MTIwMDAwMDAwMDAwMCwidXBkYXRlIjo2MDAwMDAwMDAwMDB9LCJzY2hlbWFfdmVyc2lvbiI6IjEifQ==",
              "dependencies": [
                "aws_key_pair.generated_key",
                "aws_security_group.secgroup-ssh"
              ]
            }
          ]
        },
        {
          "mode": "managed",
          "type": "aws_key_pair",
          "name": "generated_key",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "arn": "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key",
                "fingerprint": "74:3b:95:8c:5a:48:ed:ce:f4:72:5d:84:3d:a9:2b:d9",
                "id": "my_key",
                "key_name": "my_key",
                "key_name_prefix": "",
                "key_pair_id": "key-0707e00e9686e982b",
                "key_type": "rsa",
                "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy0t43evpn+ETsZIruhCp4hVuanhhLAT+wzyBiXspINJGfuiXs+jgsw02SfY8Um0UTPAWKlqCvrcoDy6l1lhMhWqaJP0ox88wg8O9DsUmNU33NkEUQ8ntSegug3ORaK6P5YxaORu6FSiYDyDY1dxGqW3nneqKTrlOHlagg/60B8kkH1HR1lJeWO/lLe4zL+gyU0JquPTW1nNOB8yDyIQx0i28wDEan4P9PHlTgn7PlcWsW31hGQKgXzpKJtZvppPfU+dnXUIdfqqwZb9HWBuL3Tm+19klaWmpWi1nf6eHW3epT8ocVNVsnR7dOUX9jut5PhCct/jCJKxkoYvzWIe47TAcpNObuN9ManaSqjv2kEzzCibWBEnE8TRrOgVZM2HjXGOicMyTiUnI682rSbzHl65OmbGkO86VXI6ROD7EoJj4gvli9A/YDjbQRq2ic4YaUtPghbaEc9nilZdRbP55b34VxEsWmqBBhCbDfQHVGo6A+1P9HxztfgVjTngkuRDE= student@tf",
                "tags": null,
                "tags_all": {}
              },
              "sensitive_attributes": [],
              "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ=="
            }
          ]
        },
        {
          "mode": "managed",
          "type": "aws_security_group",
          "name": "secgroup-ssh",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "arn": "arn:aws:ec2:us-west-1:816376574968:security-group/sg-0496213da9e7902ed",
                "description": "Managed by Terraform",
                "egress": [],
                "id": "sg-0496213da9e7902ed",
                "ingress": [
                  {
                    "cidr_blocks": [
                      "0.0.0.0/0"
                    ],
                    "description": "",
                    "from_port": 22,
                    "ipv6_cidr_blocks": [],
                    "prefix_list_ids": [],
                    "protocol": "tcp",
                    "security_groups": [],
                    "self": false,
                    "to_port": 22
                  }
                ],
                "name": "simple security group - for ssh Ingress only",
                "name_prefix": "",
                "owner_id": "816376574968",
                "revoke_rules_on_delete": false,
                "tags": {},
                "tags_all": {},
                "timeouts": null,
                "vpc_id": "vpc-0c4ad4047839bc08f"
              },
              "sensitive_attributes": [],
              "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6OTAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIxIn0="
            }
          ]
        }
      ],
      "check_results": null
    }


#### Show terraform.tfstate.backup


```bash
terraform show terraform.tfstate.backup
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-0ae9425e491550cda"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-0ae9425e491550cda"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-06b93fa31818b764a"
        private_dns                          = "ip-172-31-16-89.us-west-1.compute.internal"
        private_ip                           = "172.31.16.89"
        public_dns                           = "ec2-13-57-20-240.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.20.240"
        secondary_private_ips                = []
        security_groups                      = [
            "simple security group - for ssh Ingress only",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-0496213da9e7902ed",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-01f0b4cfdd3eff669"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }
    
    # aws_key_pair.generated_key:
    resource "aws_key_pair" "generated_key" {
        arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key"
        fingerprint = "74:3b:95:8c:5a:48:ed:ce:f4:72:5d:84:3d:a9:2b:d9"
        id          = "my_key"
        key_name    = "my_key"
        key_pair_id = "key-0707e00e9686e982b"
        key_type    = "rsa"
        public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy0t43evpn+ETsZIruhCp4hVuanhhLAT+wzyBiXspINJGfuiXs+jgsw02SfY8Um0UTPAWKlqCvrcoDy6l1lhMhWqaJP0ox88wg8O9DsUmNU33NkEUQ8ntSegug3ORaK6P5YxaORu6FSiYDyDY1dxGqW3nneqKTrlOHlagg/60B8kkH1HR1lJeWO/lLe4zL+gyU0JquPTW1nNOB8yDyIQx0i28wDEan4P9PHlTgn7PlcWsW31hGQKgXzpKJtZvppPfU+dnXUIdfqqwZb9HWBuL3Tm+19klaWmpWi1nf6eHW3epT8ocVNVsnR7dOUX9jut5PhCct/jCJKxkoYvzWIe47TAcpNObuN9ManaSqjv2kEzzCibWBEnE8TRrOgVZM2HjXGOicMyTiUnI682rSbzHl65OmbGkO86VXI6ROD7EoJj4gvli9A/YDjbQRq2ic4YaUtPghbaEc9nilZdRbP55b34VxEsWmqBBhCbDfQHVGo6A+1P9HxztfgVjTngkuRDE= student@tf"
        tags_all    = {}
    }
    
    # aws_security_group.secgroup-ssh:
    resource "aws_security_group" "secgroup-ssh" {
        arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-0496213da9e7902ed"
        description            = "Managed by Terraform"
        egress                 = []
        id                     = "sg-0496213da9e7902ed"
        ingress                = [
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 22
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 22
            },
        ]
        name                   = "simple security group - for ssh Ingress only"
        owner_id               = "816376574968"
        revoke_rules_on_delete = false
        tags                   = {}
        tags_all               = {}
        vpc_id                 = "vpc-0c4ad4047839bc08f"
    }
    
    
    Outputs:
    
    private_ip = "172.31.16.89"
    public_dns = "ec2-13-57-20-240.us-west-1.compute.amazonaws.com"
    public_ip = "13.57.20.240"


<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

- In this exercise we again went through the workflow of init, plan, apply steps to create an "*aws_instance*" resource.
- We saw how we can use the *TLS* provider to create a key, and then an aws_key_pair to be able to connect to our VM
- Later we saw how to use and exising ssh key file
- We learnt about the TF_DATA_DIR allowing us to use a common location for downloaded modules & providers
- We output the *aws_instance.example.public_ip* as a variable *public_ip* and then tried to connect using ssh
- The ssh connect failed as we had not opened the ssh port 
- We created and assigned a security group to the instance definition
- We re-applied the config - which created/attached the security group without recreating the aws_instance.
- We then added a key_pair definition to the config
- We could then connect using the vm.pem ssh key
- We created a graphic representing our infrastructure
- We then destroyed our infrastructure and compared the terraform.tfstate with the backup



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab2



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Ambitious **Stretch Goal 1:** Diagramming

With your own AWS account - as an ambitious stretch goal, look at modelling arbitrary AWS resources using

https://stelligent.com/2020/06/15/continuous-diagrams-as-code-for-aws/

https://github.com/PaulDuvall/diagrams-as-code

<hr/>
<!--
<img src="/images/ThickBlueBar.png" />
<img src="/images/LOGO.jpg" width=200 />
-->
<img src="../images/ThickBlueBar.png" />
<img src="../images/LOGO.jpg" width=200 />




```bash
#cd $NB_DIR
#cd ~/src/mjbright.tf-scenarios-private/ServeUpLabs/content/tf-labs/2.Workflow

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]







<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Terraform Workflow



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Background:
You should already have the following:

1. A login to the Amazon AWS EC2 *Bastion* instance running Ubuntu Linux



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 1.1 Saving disk space (ONLY NEEDED IF RUNNING ON A SHARED VM)

**Note:** to save disk space you can now remove the terraform binary and use the one located at ```/usr/local/bin/terraform```.
You may need to run 'hash -r' in your bash/zsh shell so that the binary is now found in that location.

**Note:** Also please run the command ```export TF_DATA_DIR=~/dot.terraform``` and add this file into your ```~/.bashrc``` file.  This will avoid making a local copy of the huge AWS provider in each labs directory which we use.

*IFF* you have environment variable **TF_DATA_DIR** set to ~/dot.terraform then *terraform init* will download plugins and modules to that directory.

This is recommended as this will avoid having many many copies of the 163MBy aws provider in *.terraform* littered across all labs directories for each user.

Add the line
```export TF_DATA_DIR=~/dot.terraform```

<!--
Using either

- A ssh command-line client using the provided ```.pem``` key
- Putty, or compatible, line client using the provided ```.ppk``` key
-->

<!--
**Note** that you will have to change the name of the instance to one provided to you by the instructor. 
-->





<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.1 Create the Terraform configuration

### 1. Make a directory called ‘labs’ underneath the home directory.
### 2. Change into the directory.
### 3. Make a directory called lab2, change to that directory




```bash
mkdir -p ~/labs/lab2
cd ~/labs/lab2
```



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2.1.1 Create a file named amis.tf

Create amis.tf with the content shown below.

In the file we define one variable of type map which is assigned a default value mapping the AWS region (string) to an AMI image (string).

the keys of a map are always of type *string*, declaring map(*string*) declares that the values returned by the map will be of type *string*

**Note**: we do not need to specify the type here, but it is good practice.


```bash
cat amis.tf
```

    variable "ami_instance" {
        description = "A mapping from AWS region to Amazon Machine Image"
        type = map(string)
        
        default = {
            "eu-north-1"     = "ami-0567220a328fe4fee"
            "ap-south-1"     = "ami-0237472cf337d9529"
            "eu-west-3"      = "ami-0df03c7641cf41947"
            "eu-west-2"      = "ami-00f94dc949fea2adf"
            "eu-west-1"      = "ami-0e41581acd7dedd99"
            "ap-northeast-2" = "ami-0f4362c71ffaf7759"
            "ap-northeast-1" = "ami-0d5db3e2a1b98ca94"
            "sa-east-1"      = "ami-0065a65613972a22a"
            "ca-central-1"   = "ami-0dbe45195223e250b"
            "ap-southeast-1" = "ami-0c199cae95cea87f0"
            "ap-southeast-2" = "ami-0c0483bc96aef8b2f"
            "eu-central-1"   = "ami-040a1551f9c9d11ad"
            "us-east-1"      = "ami-0d5ae5525eb033d0a"
            "us-east-2"      = "ami-0a7f2b5b6b87eaa1b"
            "us-west-1"      = "ami-00a3e4424e9ab3e56"
            "us-west-2"      = "ami-09c6723c6c24250c9"
        }
    }




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2.1.2 Create the main.tf

In this example we will use
- a map type to map from the AWS region we are using to the particular ami (*Amazon Machine Image*) to use for our *aws_instance*
- an automatcally generated **TLS** key

**Note**: In this example we will
- use the automatically generated **TLS** key to then create an **aws_key_pair** resource.
- extract rsa_pub and pem keys
- use the pem key to connect to our instance using ssh

Later we will see how we can connect using an existing ssh key pair

**Note:** Although presented as a single file here, you are recommended to break it up into separate files e.g. provider.tf, main.tf, variables.tf and outputs.tf

Create the file with the following content:


```bash
cat main.tf
```

    
    terraform {
      required_version = ">= 1.3.0"
    
      required_providers {
        aws = {
          version = "~> 4.40"
        }
      }
    }
    
    provider "aws" {
        region = var.region
    }
    
    variable "region" {
        description = "The region to use"
    }
    
    # NOTE: The AWS 'key pair' is the public/private key pair which
    #       can be used to enable connectivity to EC2 instances
    variable "key_name" {
        description = "The name of the AWS 'key pair' to create"
        default = "my_key"
    }
    
    # An aws_instance is an 'AWS EC2' resource: a virtual machine
    # In our config we can refer to this instance as:
    #     aws_instance.example
    resource "aws_instance" "example" {
        ami = lookup(var.ami_instance,var.region)
        #ami = "ami-0e81aa4c57820bb57"
        instance_type = "t2.micro"
        
        tags = { LabName = "2.Workflow" }
        key_name      = aws_key_pair.generated_key.key_name
    }
    
    # Create a TLS private key  resource
    resource "tls_private_key" "mykey" {
        algorithm = "RSA"
        rsa_bits  = 4096
    }
    
    # Create an AWS 'key pair' resource usable for ssh from the TLS private key
    resource "aws_key_pair" "generated_key" {
        key_name   = var.key_name
        public_key = tls_private_key.mykey.public_key_openssh
    }
    
    
    output  "ssh_rsa_pub_key" { value = tls_private_key.mykey.public_key_openssh }
    
    # NOTE: we mark this element as sensitive information,
    #       to be able to output the value
    output  "ssh_pem_key"     {
      value = tls_private_key.mykey.private_key_pem
      sensitive = true
    }
    
    output  "public_ip"       { value = aws_instance.example.public_ip }
    


Note that you can also use the ```terraform fmt``` command to ```prettify``` your code - by setting indentation correctly.

The command lists the Terraform files it modifies.


```bash
terraform fmt
```

    amis.tf
    main.tf




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.2 Initialize the provider

#### Refer to the init documentation

First refer to the documentation at https://www.terraform.io/docs/commands/init.html.

Investigate the options to this command.


### Set TF_DATA_DIR

Add the entry
```export TF_DATA_DIR=~/dot.terraform```

to the end of your .bashrc file

Source the file ```source ~/.bashrc``` and re-perform ```terraform init```

**Note**: If that environment variable is not set and exported then a new *.terraform* directory will have been created in the directory where you ran *terraform init*.

But the Provider is large - currently more than ```200 MBytes``` so we would prefer to download the provider in a common location, rather than as a sub-directory of each Terraform configuration we create.

#### Terraform init

Run the following command:

This command initializes the terraform directory structure.

You will see output similar to the following showing, note that

- Terraform detected that "*aws*" is specified as a provider and so downloads the appropriate *provider plugin*.



```bash
terraform init
```

    
    Initializing the backend...
    
    Initializing provider plugins...
    - Finding hashicorp/aws versions matching "~> 4.40"...
    - Finding latest version of hashicorp/tls...
    - Installing hashicorp/tls v4.0.4...
    - Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
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


We can see that the aws provider plugin has been downloaded into the ~/dot.terraform folder

(where some older versions may also be present)


```bash
 find ~/dot.terraform -iname '*aws*'

```

    /home/student/dot.terraform/providers/registry.terraform.io/hashicorp/aws/4.49.0/linux_amd64/terraform-provider-aws_v4.49.0_x5




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.3. Run a Terraform plan

#### Refer to the plan documentation

First refer to the documentation at https://www.terraform.io/docs/commands/plan.html.

Investigate the options to this command.

#### Terraform plan

Note that in the above configuration we set the region to the '*region*' variable.

We also declare that variable but we don't give it a value.

So we will find that when we perform a ```terraform plan``` or ```terraform apply``` we are prompted to provide a value for var.region.

Note that the ```description``` used (```The region to use```) in the ```region``` variable definition is used as the prompt for the value below:

```
terraform plan
var.region
  The region to use

  Enter a value:
  ```

You will be prompted to enter a value for the *region* variable as we gave it no value in our aws.tf file.

Type *us-west-1* and press *&lt;ENTER&gt;*

**Note**: alternatively we could have invoked terraform as, ```terraform plan -var region=us-west-1```, passing in the variable value

### Terraform plan actions

- *Terraform plan* will first examine the state of the components managed by this Terraform workspace - as defined in your ```*.tf``` configuration
- It will then update the ```terraform.tfstate``` file to represent this actual state.
- It will then compare the configuration which represents the *desired state* with the *actual state*
- It will report to you any differences
- It will not *apply* or make any changes

#### Reviewing the plan output

This should print out what actions terraform will take.

Look at the output and in particular the *summary line*:

```
Plan: 1 to add, 0 to change, 0 to destroy
```

It is important to know when deploying real infrastructure what changes are to be made, the summary line can be a quick indicator that something might not be as you expect.

When in production, a line of the form

Plan: 0 to add, 10 to change, **31 to destroy**

might make you **think twice!!**

But don't worry a *terraform plan* is safe and will not apply any changes.

#### Adding a default value to the *region* variable

Tired of being prompted to enter a value for the *region* variable?

Let's set a default value in our *main.tf* configuration file. Modify the variable definition as follows in that file:

```
variable "region" {
    description = "The region to use"
    default="us-west-1"
}
```

#### Saving the plan output

We can re-run the plan command as many times as we like, it will always compare the current state of the system with your configuration.

We can also save the output using the *-out* option, e.g. as


```bash
terraform plan -out plan.out
```

    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      + create
    
    Terraform will perform the following actions:
    
      # aws_instance.example will be created
      + resource "aws_instance" "example" {
          + ami                                  = "ami-00a3e4424e9ab3e56"
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
          + key_name                             = "my_key"
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
          + tags                                 = {
              + "LabName" = "2.Workflow"
            }
          + tags_all                             = {
              + "LabName" = "2.Workflow"
            }
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
    
      # aws_key_pair.generated_key will be created
      + resource "aws_key_pair" "generated_key" {
          + arn             = (known after apply)
          + fingerprint     = (known after apply)
          + id              = (known after apply)
          + key_name        = "my_key"
          + key_name_prefix = (known after apply)
          + key_pair_id     = (known after apply)
          + key_type        = (known after apply)
          + public_key      = (known after apply)
          + tags_all        = (known after apply)
        }
    
      # tls_private_key.mykey will be created
      + resource "tls_private_key" "mykey" {
          + algorithm                     = "RSA"
          + ecdsa_curve                   = "P224"
          + id                            = (known after apply)
          + private_key_openssh           = (sensitive value)
          + private_key_pem               = (sensitive value)
          + private_key_pem_pkcs8         = (sensitive value)
          + public_key_fingerprint_md5    = (known after apply)
          + public_key_fingerprint_sha256 = (known after apply)
          + public_key_openssh            = (known after apply)
          + public_key_pem                = (known after apply)
          + rsa_bits                      = 4096
        }
    
    Plan: 3 to add, 0 to change, 0 to destroy.
    
    Changes to Outputs:
      + public_ip       = (known after apply)
      + ssh_pem_key     = (sensitive value)
      + ssh_rsa_pub_key = (known after apply)
    [90m
    ───────────────────────────────────────────────────────────────────────────────
    
    Saved the plan to: plan.out
    
    To perform exactly these actions, run the following command to apply:
        terraform apply "plan.out"


**Note**: The generated plan.out file is a binary file intended to be used as an optional parameter to the *terraform apply* comand.



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.4. Apply the configuration

#### Refer to the apply documentation

First refer to the documentation at https://www.terraform.io/docs/commands/apply.html.

Investigate the options to this command.

#### Terraform apply

Now apply this config as before

Assuming that this works correctly, AWS will create a new VM instance

**Note**: We could also use the plan.out file we created earlier using the command *terraform apply plan.out*

**Warning**: The plan.out file will only be valid until the next state-modification, i.e. ```terraform apply``` or ```terraform destroy```.  After such a command the plan.out file should not be reused as it is no longer valid - terraform *should* detect this and refuse to apply the plan.

The *apply* will first build a *plan*, unless a plan file was provided

It will then inform you of the changes to be made, with a *summary line* as before, but this time you will be asked if you want to apply the changes.

You should see something like:

```
Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

If that looks fine to you we can proceed, type *yes* and then *&lt;ENTER&gt;*.

Terraform will then use the *aws provider plugin* to create the appropriate resources - in this case an EC2 virtual machine, taking 20 seconds or so.

```
aws_instance.example: Creating...
aws_instance.example: Still creating... [10s elapsed]
aws_instance.example: Still creating... [20s elapsed]
aws_instance.example: Creation complete after 22s [id=i-0be7b55b802975868]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.5. Re-apply the configuration

Now let's re-run the apply to see what happens.

You should see something like:


```bash
terraform apply 
```

    tls_private_key.mykey: Refreshing state... [id=8ec77021b97cac2bebfc2551824fdeaaf9359299]
    aws_key_pair.generated_key: Refreshing state... [id=my_key]
    aws_instance.example: Refreshing state... [id=i-01e0aa7b482e69908]
    
    No changes. Your infrastructure matches the configuration.
    
    Terraform has compared your real infrastructure against your configuration and
    found no differences, so no changes are needed.
    
    Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    
    Outputs:
    
    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT


Note that this time nothing changes - why is that?



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.6. Inspect the terraform.tfstate file


```bash
 cat terraform.tfstate

```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 5,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {
        "public_ip": {
          "value": "13.57.185.56",
          "type": "string"
        },
        "ssh_pem_key": {
          "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
          "type": "string",
          "sensitive": true
        },
    ....


What information does it contain?

What format is this file in?

Well since it's in that format we can parse it using jq, e.g. to get the private ip address of the VM:


```bash
jq -M '.resources[].instances[].attributes.private_ip' terraform.tfstate
```

    "172.31.29.108"
    null
    null


The above matches also on resources not of type "*aws_instance*".

We can select only the "*aws_instance*" resources by detecting the presence of the *ami* attribute (Amazon Machine Image) as shown below:


```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes.private_ip' \
    terraform.tfstate 
```

    "172.31.29.108"


Below are some more examples:


```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes.public_ip'\
    terraform.tfstate 
```

    "13.57.185.56"



```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes |
  .public_dns'\
    terraform.tfstate 
```

    "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"



```bash
jq -M '.resources[].instances[] |
  select(.attributes.ami) |
  .attributes |
  { public_dns, public_ip, private_ip }' \
    terraform.tfstate
```

    {
      "public_dns": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
      "public_ip": "13.57.185.56",
      "private_ip": "172.31.29.108"
    }


Of course there are other *terraform* ways to obtain this information


```bash
terraform output
```

    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT



```bash
terraform show
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-01e0aa7b482e69908"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-01e0aa7b482e69908"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-01fe4ed51b2e080d7"
        private_dns                          = "ip-172-31-29-108.us-west-1.compute.internal"
        private_ip                           = "172.31.29.108"
        public_dns                           = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.185.56"
        secondary_private_ips                = []
        security_groups                      = [
            "default",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-07e7db9f93d86103e",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-062272a8c172bfbcd"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }
    
    # aws_key_pair.generated_key:
    resource "aws_key_pair" "generated_key" {
        arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key"
        fingerprint = "31:07:72:7c:21:09:58:62:f3:53:c7:6f:ef:a6:a1:05"
        id          = "my_key"
        key_name    = "my_key"
        key_pair_id = "key-0fde9c933239986df"
        key_type    = "rsa"
        public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ=="
        tags        = {}
        tags_all    = {}
    }
    
    # tls_private_key.mykey:
    resource "tls_private_key" "mykey" {
        algorithm                     = "RSA"
        ecdsa_curve                   = "P224"
        id                            = "8ec77021b97cac2bebfc2551824fdeaaf9359299"
        private_key_openssh           = (sensitive value)
        private_key_pem               = (sensitive value)
        private_key_pem_pkcs8         = (sensitive value)
        public_key_fingerprint_md5    = "55:2b:31:bb:16:a9:b3:c1:35:df:38:e6:11:64:af:8e"
        public_key_fingerprint_sha256 = "SHA256:2W9TUM5xWaBqados7kQUnR5P6Z0mAZ7LqXL4i5ttHek"
        public_key_openssh            = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
        EOT
        public_key_pem                = <<-EOT
            -----BEGIN PUBLIC KEY-----
            MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAowH8NyOxTtaItgPko4uk
            hVnBnOlx7WhBGm0pCxZ51CYVYLjde3W919QWjD0bMh6pj6EIOun95ZJTIO1BIn4+
            WZNWjWJwtZS5pZhlOvb5aU1RviMGyegjEK/qyN9ZHLddLr1Fx/DR4OQyxVAe+X6Z
            g2WkyZc5XzyLjuPhope3cpJ5DrGFKnlJyHngoKwdOyk/vQcZOxvo8kiHzzfA9l2B
            hitoY5TFp9yvxomuJQ7XypmhIP+eCimApmWK+U1HDP3tXbaJnW+8RIsGBkrCaINq
            kmHWzNXtq+UrFgWT/eebyMYOWdQ9lL7zrBomC/D3oxb0JKc919FvfMVXcMKuCEKS
            Qu7CtdyS0EA6NAT5+HU0PrmB8X2wmXPuRSmBTgF5avMgKd3kbxC13ENLrPe1u8HM
            axOpaKKWUEyj74xHI07M2E7V1p2f3YOPD4m/T+3P3TNsFlypwb983wHkRZ3LOlEQ
            oNSZ0CI5Gm343Vz+6WjapazyiGDiLzxBgdBj7mHzco1F+RsMdowBIRTPQsTtwkR4
            R5MxgZaIiMrAWPpVQ6whrtZk+VAG2isgKJFeFByaF4cDTRkPBHgt0YXsT9Airut5
            5v+lhsxhbem5NYF7f72xn+7toU+5z2AwxMd4tgC+IX43ZJUVXoNlFjDR88c+ScI7
            qsz101OBufGcHLqxueGfsw0CAwEAAQ==
            -----END PUBLIC KEY-----
        EOT
        rsa_bits                      = 4096
    }
    
    
    Outputs:
    
    public_ip = "13.57.185.56"
    ssh_pem_key = (sensitive value)
    ssh_rsa_pub_key = <<-EOT
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    EOT



```bash
terraform state list
```

    aws_instance.example
    aws_key_pair.generated_key
    tls_private_key.mykey



```bash
terraform state show aws_instance.example
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-01e0aa7b482e69908"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-01e0aa7b482e69908"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-01fe4ed51b2e080d7"
        private_dns                          = "ip-172-31-29-108.us-west-1.compute.internal"
        private_ip                           = "172.31.29.108"
        public_dns                           = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.185.56"
        secondary_private_ips                = []
        security_groups                      = [
            "default",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-07e7db9f93d86103e",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-062272a8c172bfbcd"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }



```bash
grep public_ip terraform.tfstate
```

        "public_ip": {
                "associate_public_ip_address": true,
                "public_ip": "13.57.185.56",



```bash
terraform show | grep "^public_ip"
```

    public_ip = "13.57.185.56"


would have got us the information in a more direct but less programmatic manner


### 11. Connecting to your VM

#### Get the public address of your VM using one of the above methods




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.  Connect to the VM



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.1  Create & use a key pair in the VM config

We could refer to an existing ```AWS key pair``` to allow connection using ssh.

In our example we had Terraform create the ```TLS private key``` and ```AWS key pair``` for us.

This is very convenient and will allow us to create/destroy the key pair along with any other resources of this config.

We can obtain the keypem using the ```ssh_pem_key``` output we declared:

``` terraform output ssh_pem_key | grep -v EOT > key.pem
chmod 600 key.pem```

### Create a key.pem ```local_file``` resource

or a better way would be to create a local file with this value, we can do this by adding a ```local_file``` resource into our configuration

Add the following lines, then perform a ```terraform plan``` and ```terraform apply``` - note in doing so that a single new resource, the ```local_file``` resource will be added:

```resource "local_file" "pem_key" {
  filename        = "key.pem"
  content         = tls_private_key.mykey.private_key_pem
  file_permission = 0600
}```




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 2.7.2  Connect to the VM


Try to connect to that address from the bastion using the ssh client, using the provided vm.pem key:


```bash
pwd
ls -al key.pem
```

    /home/student/labs/lab2
    -rw------- 1 student student 3243 Jan  9 13:51 key.pem



```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP uptime
```

    ssh: connect to host 13.57.185.56 port 22: Connection timed out




### ssh connection timeout !!

**Note**: The connection times out ... because we haven't opened port 22 yet ... as we didn't create an *AWS* security group yet 

**Note:** By default AWS doesn't allow any incoming or outgoing traffic, which is a good best practice.  With this ```least privilege``` security approach we must explicitly create a ```security group``` specifying which tcp/udp ports are to be enabled for ```ingress``` and ```traffic```

### 12. Edit the file main.tf

Add the following lines to create a security group allowing incoming ```SSH``` traffic on port 22:


```bash

```

    resource "aws_security_group" "secgroup-ssh" {
      name = "simple security group - for ssh Ingress only"
    
      # Enable incoming ssh connection:
      ingress {
        from_port   = "22"
        to_port     = "22"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    


also add the following line into the "aws_instance" resource definition:

```
vpc_security_group_ids = [aws_security_group.secgroup-ssh.id]
```




Then perform a ```terraform apply```.

Note the summary line of the proposed changes:

```
tls_private_key.mykey: Refreshing state... [id=77d192e85f856403494c160f78933012b0f02c8c]
aws_key_pair.generated_key: Refreshing state... [id=my_key]
aws_instance.example: Refreshing state... [id=i-05331b82bf9a7ad2f]
aws_security_group.secgroup-ssh: Creating...
aws_security_group.secgroup-ssh: Creation complete after 5s [id=sg-0058898a0755cdd94]
aws_instance.example: Modifying... [id=i-05331b82bf9a7ad2f]
aws_instance.example: Modifications complete after 6s [id=i-05331b82bf9a7ad2f]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.
```

Note that the ```security group``` is added, and that the ```aws_instance``` is changed (without needing to destroy/recreate the VM)

```Plan: 1 to add, 1 to change, 0 to destroy.```


```bash
terraform output public_ip 

IP=$( terraform output public_ip  | sed 's/"//g' )
```

    "13.57.185.56"


Note that this does not replace our VM instance already created, it makes a change to the instance resource and adds a new EC2 security group resource.


Now try again to connect to the public address.

This time you should be prompted with

```Are you sure you want to continue connecting (yes/no)?```

Answer 'yes' and you should then be connected to the VM.


```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP uptime
```

     14:01:17 up 35 min,  0 users,  load average: 0.00, 0.00, 0.00



```bash
ssh -i key.pem -o ConnectTimeout=4 ubuntu@$IP \
  'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'
```

    hostname[ip-172-31-29-108]: Linux/4.15.0-1052-aws 14:01:22 up 35 min, 0 users, load average: 0.00, 0.00, 0.00


**Success !!**

### 13. Specifying output variables

Now let's see how we can output specific variables

Add the following lines to the *main.tf* file:


```bash

```

    output  "private_ip"    { value = aws_instance.example.private_ip }
    output  "public_dns"    { value = aws_instance.example.public_dns }


Re-run ```terraform apply```, you should see the output fields on the console.

### terraform output

At any time we can view the ```outputs``` using the ```terraform output``` command:

**Note:** the terraform output command only reads the outputs from the ```terraform.tfstate```, so it is possible that the values are out of date if the configuration has ```drifted```, e.g. if someone has deleted an AWS resource bypassing ```terraform```.


```bash
terraform output
```

    private_ip = "172.31.29.108"
    public_dns = "ec2-13-57-185-56.us-west-1.compute.amazonaws.com"
    public_ip = "13.57.185.56"
    ssh_pem_key = <sensitive>
    ssh_rsa_pub_key = <<EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==
    
    EOT


Look at the new terraform.state file, you should see the output fields there also in json format.

Perform a ```diff terraform.tfstate terraform.tfstate.backup``` to see the difference.

We can also use Python to extract those fields explicitly from the json-formated *terraform.tfstate* file:


```bash
python3 -c \
  'import sys, json;
print(json.dumps(json.load(sys.stdin)["outputs"],indent=2))' \
  < terraform.tfstate
```

    {
      "private_ip": {
        "value": "172.31.29.108",
        "type": "string"
      },
      "public_dns": {
        "value": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
        "type": "string"
      },
      "public_ip": {
        "value": "13.57.185.56",
        "type": "string"
      },
      "ssh_pem_key": {
        "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
        "type": "string",
        "sensitive": true
      },
      "ssh_rsa_pub_key": {
        "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==\n",
        "type": "string"
      }
    }


or you may use the *jq* tool:


```bash
jq -M '.outputs' terraform.tfstate
```

    {
      "private_ip": {
        "value": "172.31.29.108",
        "type": "string"
      },
      "public_dns": {
        "value": "ec2-13-57-185-56.us-west-1.compute.amazonaws.com",
        "type": "string"
      },
      "public_ip": {
        "value": "13.57.185.56",
        "type": "string"
      },
      "ssh_pem_key": {
        "value": "-----BEGIN RSA PRIVATE KEY-----\n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\n-----END RSA PRIVATE KEY-----\n",
        "type": "string",
        "sensitive": true
      },
      "ssh_rsa_pub_key": {
        "value": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjAfw3I7FO1oi2A+Sji6SFWcGc6XHtaEEabSkLFnnUJhVguN17db3X1BaMPRsyHqmPoQg66f3lklMg7UEifj5Zk1aNYnC1lLmlmGU69vlpTVG+IwbJ6CMQr+rI31kct10uvUXH8NHg5DLFUB75fpmDZaTJlzlfPIuO4+Gil7dyknkOsYUqeUnIeeCgrB07KT+9Bxk7G+jySIfPN8D2XYGGK2hjlMWn3K/Gia4lDtfKmaEg/54KKYCmZYr5TUcM/e1dtomdb7xEiwYGSsJog2qSYdbM1e2r5SsWBZP955vIxg5Z1D2UvvOsGiYL8PejFvQkpz3X0W98xVdwwq4IQpJC7sK13JLQQDo0BPn4dTQ+uYHxfbCZc+5FKYFOAXlq8yAp3eRvELXcQ0us97W7wcxrE6loopZQTKPvjEcjTszYTtXWnZ/dg48Pib9P7c/dM2wWXKnBv3zfAeRFncs6URCg1JnQIjkabfjdXP7paNqlrPKIYOIvPEGB0GPuYfNyjUX5Gwx2jAEhFM9CxO3CRHhHkzGBloiIysBY+lVDrCGu1mT5UAbaKyAokV4UHJoXhwNNGQ8EeC3RhexP0CKu63nm/6WGzGFt6bk1gXt/vbGf7u2hT7nPYDDEx3i2AL4hfjdklRVeg2UWMNHzxz5JwjuqzPXTU4G58ZwcurG54Z+zDQ==\n",
        "type": "string"
      }
    }


Later we will see how we can execute commands using provisioners, which we could also use to output specific information.

### 14. using an existing ssh key file

Previously we saw how we could auto-generate a *TLS key* and then an *aws_key_pair* resource allowing us to connect to our VM using ssh.

Those keys are part of the resources managed from Terraform and will be destroyed when the config is destroyed.

In this section we will look at how we can use and existing ssh key file, or aws_key_pair, indepedently of this Terraform configuration.

#### Remove the tls_private_key definition and outputs

We will not auto-generate the TLS key this time so we will

- Remove the resource from the main.tf file.
- Remove also the 2 output lines for "*ssh_rsa_pub_key*" "*ssh_pem_key*" which can no longer be used.
- Delete the local mykey.pem file

#### Modify the public_key attribute setting

We will now modify the aws_key_pair definition resource to obtain the public_key definition from a local file:

```
    public_key = file("~/.ssh/id_rsa.pub")
```

Change also the name of the *aws_key_pair* resource by changing the *default* value of the *key_name* variable to me "*my_rsa_key*"

**Note:** You may need to generate the ssh key first - do this with command:

```ssh-keygen -t rsa -N ''```

#### Taint the ```aws_instance``` resource

We need to destroy/re-create the ```aws_instance``` resource.

We can do this by using ```terraform destroy``` then ```terraform apply``` but this would destroy/recreate all resources of the configuration.

We can avoid this by either
- Performing the destroy only on ```aws_instance.example``` as ```terraform destroy -target aws_instance.example``` before performing ```terraform apply```
- ```Tainting``` the ```aws_instance.example``` so that it will be recreated at the next ```terraform apply```

Taint the resource using commands:
```terraform taint aws_instance.example```

#### Re-apply the configuration

**Note:** You may need to remove the ```local_file``` ```pem_key``` resource you created earlier

Run ```terraform apply``` with this new configuration.

**Note:**
- that the *tls-private-key* resource is deleted
- The *aws_key_pair* and *aws_instance* resources are destroyed and then re-created

#### Connect to the VM using the local key

Note that the new instance will have changed IP address.

set the IP variable to that value and try to connect using the following ssh command.

**Note** that now we use the ~/.ssh/id_rsa **private_key**


You will again be prompted to accept the key (for the known_hosts file):

```
Are you sure you want to continue connecting (yes/no)?
```

Answer 'yes' and you should then be connected to the VM.


```bash
ssh -i ~/.ssh/id_rsa -o ConnectTimeout=4 ubuntu@"13.57.20.240" \
    uptime
```

     14:07:04 up 1 min,  0 users,  load average: 0.27, 0.09, 0.03



```bash
ssh -i ~/.ssh/id_rsa -o ConnectTimeout=4 ubuntu@"13.57.20.240" \
    'echo hostname[$(hostname)]: $(uname -s)/$(uname -r) $(uptime)'
```

    hostname[ip-172-31-16-89]: Linux/4.15.0-1052-aws 14:07:08 up 1 min, 0 users, load average: 0.27, 0.09, 0.03


**Success !!**


### 15. Tagging resources

We can also add tags to resources, using literal strings or variables or data sources.

Note that the tags we specified earlier are associated with our VM instance.

You can verify this using either
- aws ec2 describe-instances
- /usr/local/bin/get_instances.sh

e.g.

```
/usr/local/bin/get_instances.sh
{"id":"i-0e5fe7594eed0330d","image":"ami-00a3e4424e9ab3e56","state":"running","Tags":[{"Key":"LabName","Value":"2.Workflow"}],"LaunchTime":"2021-02-02T13:55:01.000Z"}
```

Apply this new configuration and then compare the tfstate with the backup.
You should see that the tags have been added to the resource state.


### 16. Create a graph of resources in the current config
We can generate a graphviz format file representing the graph of resources represented by the current configuration.
**Note:** We speak here of the configuration as represented by the group of .tf files, not the actual state


```bash
terraform graph
```

    digraph {
    	compound = "true"
    	newrank = "true"
    	subgraph "root" {
    		"[root] aws_instance.example (expand)" [label = "aws_instance.example", shape = "box"]
    		"[root] aws_key_pair.generated_key (expand)" [label = "aws_key_pair.generated_key", shape = "box"]
    		"[root] aws_security_group.secgroup-ssh (expand)" [label = "aws_security_group.secgroup-ssh", shape = "box"]
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"]" [label = "provider[\"registry.terraform.io/hashicorp/aws\"]", shape = "diamond"]
    		"[root] var.ami_instance" [label = "var.ami_instance", shape = "note"]
    		"[root] var.key_name" [label = "var.key_name", shape = "note"]
    		"[root] var.region" [label = "var.region", shape = "note"]
    		"[root] aws_instance.example (expand)" -> "[root] aws_key_pair.generated_key (expand)"
    		"[root] aws_instance.example (expand)" -> "[root] aws_security_group.secgroup-ssh (expand)"
    		"[root] aws_instance.example (expand)" -> "[root] var.ami_instance"
    		"[root] aws_key_pair.generated_key (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
    		"[root] aws_key_pair.generated_key (expand)" -> "[root] var.key_name"
    		"[root] aws_security_group.secgroup-ssh (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
    		"[root] output.private_ip (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] output.public_dns (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] output.public_ip (expand)" -> "[root] aws_instance.example (expand)"
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)" -> "[root] aws_instance.example (expand)"
    		"[root] provider[\"registry.terraform.io/hashicorp/aws\"]" -> "[root] var.region"
    		"[root] root" -> "[root] output.private_ip (expand)"
    		"[root] root" -> "[root] output.public_dns (expand)"
    		"[root] root" -> "[root] output.public_ip (expand)"
    		"[root] root" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)"
    	}
    }
    


We can display this by performing the following steps:


```bash
terraform graph | dot -Tsvg > graph.svg
```

    
    Command 'dot' not found, but can be installed with:
    
    sudo apt install graphviz
    





```bash
sudo apt install -y graphviz
```

    Reading package lists... 0%Reading package lists... 100%Reading package lists... Done
    Building dependency tree... 0%Building dependency tree... 0%Building dependency tree... 50%Building dependency tree... 50%Building dependency tree       
    Reading state information... 0%Reading state information... 0%Reading state information... Done
    The following packages were automatically installed and are no longer required:
      linux-headers-5.4.0-120 linux-headers-5.4.0-120-generic
      linux-image-5.4.0-120-generic linux-modules-5.4.0-120-generic
    Use 'sudo apt autoremove' to remove them.
    The following additional packages will be installed:
      fonts-liberation libann0 libcdt5 libcgraph6 libgts-0.7-5 libgts-bin libgvc6
      libgvpr2 liblab-gamut1 libpathplan4
    Suggested packages:
      graphviz-doc
    The following NEW packages will be installed:
      fonts-liberation graphviz libann0 libcdt5 libcgraph6 libgts-0.7-5 libgts-bin
      libgvc6 libgvpr2 liblab-gamut1 libpathplan4
    0 upgraded, 11 newly installed, 0 to remove and 0 not upgraded.
    Need to get 2,701 kB of archives.
    After this operation, 11.3 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 fonts-liberation all 1:1.07.4-11 [822 kB]
    Get:2 http://archive.ubuntu.com/ubuntu focal/universe amd64 libann0 amd64 1.1.2+doc-7build1 [26.0 kB]
    Get:3 http://archive.ubuntu.com/ubuntu focal/universe amd64 libcdt5 amd64 2.42.2-3build2 [18.7 kB]
    Get:4 http://archive.ubuntu.com/ubuntu focal/universe amd64 libcgraph6 amd64 2.42.2-3build2 [41.3 kB]
    Get:5 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgts-0.7-5 amd64 0.7.6+darcs121130-4 [150 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal/universe amd64 libpathplan4 amd64 2.42.2-3build2 [21.9 kB]
    Get:7 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgvc6 amd64 2.42.2-3build2 [647 kB]
    Get:8 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgvpr2 amd64 2.42.2-3build2 [167 kB]
    Get:9 http://archive.ubuntu.com/ubuntu focal/universe amd64 liblab-gamut1 amd64 2.42.2-3build2 [177 kB]
    Get:10 http://archive.ubuntu.com/ubuntu focal/universe amd64 graphviz amd64 2.42.2-3build2 [590 kB]
    Get:11 http://archive.ubuntu.com/ubuntu focal/universe amd64 libgts-bin amd64 0.7.6+darcs121130-4 [41.3 kB]
    Fetched 2,701 kB in 1s (2,243 kB/s)[0m
    
    7[0;23r8[1ASelecting previously unselected package fonts-liberation.
    (Reading database ... 142715 files and directories currently installed.)
    Preparing to unpack .../00-fonts-liberation_1%3a1.07.4-11_all.deb ...
    7[24;0f[42mProgress: [  0%][49m[39m [..........................................................] 87[24;0f[42mProgress: [  2%][49m[39m [#.........................................................] 8Unpacking fonts-liberation (1:1.07.4-11) ...
    7[24;0f[42mProgress: [  4%][49m[39m [##........................................................] 8Selecting previously unselected package libann0.
    Preparing to unpack .../01-libann0_1.1.2+doc-7build1_amd64.deb ...
    7[24;0f[42mProgress: [  7%][49m[39m [###.......................................................] 8Unpacking libann0 (1.1.2+doc-7build1) ...
    7[24;0f[42mProgress: [  9%][49m[39m [#####.....................................................] 8Selecting previously unselected package libcdt5:amd64.
    Preparing to unpack .../02-libcdt5_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 11%][49m[39m [######....................................................] 8Unpacking libcdt5:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 13%][49m[39m [#######...................................................] 8Selecting previously unselected package libcgraph6:amd64.
    Preparing to unpack .../03-libcgraph6_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 16%][49m[39m [#########.................................................] 8Unpacking libcgraph6:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 18%][49m[39m [##########................................................] 8Selecting previously unselected package libgts-0.7-5:amd64.
    Preparing to unpack .../04-libgts-0.7-5_0.7.6+darcs121130-4_amd64.deb ...
    7[24;0f[42mProgress: [ 20%][49m[39m [###########...............................................] 8Unpacking libgts-0.7-5:amd64 (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 22%][49m[39m [############..............................................] 8Selecting previously unselected package libpathplan4:amd64.
    Preparing to unpack .../05-libpathplan4_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 24%][49m[39m [##############............................................] 8Unpacking libpathplan4:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 27%][49m[39m [###############...........................................] 8Selecting previously unselected package libgvc6.
    Preparing to unpack .../06-libgvc6_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 29%][49m[39m [################..........................................] 8Unpacking libgvc6 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 31%][49m[39m [##################........................................] 8Selecting previously unselected package libgvpr2:amd64.
    Preparing to unpack .../07-libgvpr2_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 33%][49m[39m [###################.......................................] 8Unpacking libgvpr2:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 36%][49m[39m [####################......................................] 8Selecting previously unselected package liblab-gamut1:amd64.
    Preparing to unpack .../08-liblab-gamut1_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 38%][49m[39m [#####################.....................................] 8Unpacking liblab-gamut1:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 40%][49m[39m [#######################...................................] 8Selecting previously unselected package graphviz.
    Preparing to unpack .../09-graphviz_2.42.2-3build2_amd64.deb ...
    7[24;0f[42mProgress: [ 42%][49m[39m [########################..................................] 8Unpacking graphviz (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 44%][49m[39m [#########################.................................] 8Selecting previously unselected package libgts-bin.
    Preparing to unpack .../10-libgts-bin_0.7.6+darcs121130-4_amd64.deb ...
    7[24;0f[42mProgress: [ 47%][49m[39m [###########################...............................] 8Unpacking libgts-bin (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 49%][49m[39m [############################..............................] 8Setting up liblab-gamut1:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 51%][49m[39m [#############################.............................] 87[24;0f[42mProgress: [ 53%][49m[39m [##############################............................] 8Setting up libgts-0.7-5:amd64 (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 56%][49m[39m [################################..........................] 87[24;0f[42mProgress: [ 58%][49m[39m [#################################.........................] 8Setting up libpathplan4:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 60%][49m[39m [##################################........................] 87[24;0f[42mProgress: [ 62%][49m[39m [####################################......................] 8Setting up libann0 (1.1.2+doc-7build1) ...
    7[24;0f[42mProgress: [ 64%][49m[39m [#####################################.....................] 87[24;0f[42mProgress: [ 67%][49m[39m [######################################....................] 8Setting up fonts-liberation (1:1.07.4-11) ...
    7[24;0f[42mProgress: [ 69%][49m[39m [#######################################...................] 87[24;0f[42mProgress: [ 71%][49m[39m [#########################################.................] 8Setting up libcdt5:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 73%][49m[39m [##########################################................] 87[24;0f[42mProgress: [ 76%][49m[39m [###########################################...............] 8Setting up libcgraph6:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 78%][49m[39m [#############################################.............] 87[24;0f[42mProgress: [ 80%][49m[39m [##############################################............] 8Setting up libgts-bin (0.7.6+darcs121130-4) ...
    7[24;0f[42mProgress: [ 82%][49m[39m [###############################################...........] 87[24;0f[42mProgress: [ 84%][49m[39m [################################################..........] 8Setting up libgvc6 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 87%][49m[39m [##################################################........] 87[24;0f[42mProgress: [ 89%][49m[39m [###################################################.......] 8Setting up libgvpr2:amd64 (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 91%][49m[39m [####################################################......] 87[24;0f[42mProgress: [ 93%][49m[39m [######################################################....] 8Setting up graphviz (2.42.2-3build2) ...
    7[24;0f[42mProgress: [ 96%][49m[39m [#######################################################...] 87[24;0f[42mProgress: [ 98%][49m[39m [########################################################..] 8Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
    Processing triggers for man-db (2.9.1-1) ...
    Processing triggers for fontconfig (2.13.1-2ubuntu3) ...
    
    7[0;24r8[1A[J



```bash
terraform graph | dot -Tsvg > graph.svg
```

Now we can serve this file using the command
**Note**: Choose port number 31001 if you are user1, 31002 uf you are user2 etc ...

As student20:
```
python3 -m http.server --bind 0.0.0.0 31020
```


**Note:** This step will require intervention from your instructor ...

With a browser navigate to http://&lt;BASTION_HOST&gt;:&lt;:PORT&gt;/graph.svg
e.g. http://bastion-ls.mjbright.click:31020/graph.svg

You should see something similar to:

<!-- <div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div> -->

<img src="graph.svg" />

**Note**: You may have difficulties to view the svg, if so try with a different browser

See https://www.terraform.io/docs/commands/graph.html for more information about using the graph sub-command.

### Other ways of displaying the graph

#### graphvizOnline

Copy the ```terraform graph``` output and post it to the web page https://dreampuf.github.io/GraphvizOnline

#### Blast Radius

Another tool which can be used is ```blast radius``` at https://28mm.github.io/blast-radius-docs/

#### BrainBoard

Brainboard, https://www.brainboard.co, seems to be a really interesting option, but has now become a paid for service - after the 21 days free trial period.

### 17. Cleanup

Destroy the resources generated in this lab using ```terraform destroy```

This will now destroy the formerly created AWS vpc, and all subnets.

You should see something similar to

```
Plan: 0 to add, 0 to change, 3 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.example: Destroying... [id=i-0ee33d3ff92efccaa]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 10s elapsed]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 20s elapsed]
aws_instance.example: Still destroying... [id=i-0ee33d3ff92efccaa, 30s elapsed]
aws_instance.example: Destruction complete after 40s
aws_key_pair.generated_key: Destroying... [id=my_key]
aws_security_group.secgroup-ssh: Destroying... [id=sg-08d41669346adc461]
aws_key_pair.generated_key: Destruction complete after 0s
aws_security_group.secgroup-ssh: Destruction complete after 0s

Destroy complete! Resources: 3 destroyed.
```

### 18. Inspecting the previous state

If you now perform a ```terraform show``` you will see no resources as they were just destroyed

If we look at files in the directory we should see the previous state has been stored as
terraform.tfstate.backup.


```bash
ls -al terraform.tfstate*
```

    -rw-rw-r-- 1 student student  181 Jan  9 14:15 terraform.tfstate
    -rw-rw-r-- 1 student student 7723 Jan  9 14:15 terraform.tfstate.backup


#### Look at terraform.tfstate

The new state is now empty of resources:


```bash
cat terraform.tfstate
```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 23,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {},
      "resources": [],
      "check_results": null
    }


#### Look at terraform.tfstate.backup

Inspect the previous state using:


```bash
cat terraform.tfstate.backup
```

    {
      "version": 4,
      "terraform_version": "1.3.7",
      "serial": 19,
      "lineage": "663fc346-1482-a45e-65bc-45b045af7ba6",
      "outputs": {
        "private_ip": {
          "value": "172.31.16.89",
          "type": "string"
        },
        "public_dns": {
          "value": "ec2-13-57-20-240.us-west-1.compute.amazonaws.com",
          "type": "string"
        },
        "public_ip": {
          "value": "13.57.20.240",
          "type": "string"
        }
      },
      "resources": [
        {
          "mode": "managed",
          "type": "aws_instance",
          "name": "example",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "ami": "ami-00a3e4424e9ab3e56",
                "arn": "arn:aws:ec2:us-west-1:816376574968:instance/i-0ae9425e491550cda",
                "associate_public_ip_address": true,
                "availability_zone": "us-west-1c",
                "capacity_reservation_specification": [
                  {
                    "capacity_reservation_preference": "open",
                    "capacity_reservation_target": []
                  }
                ],
                "cpu_core_count": 1,
                "cpu_threads_per_core": 1,
                "credit_specification": [
                  {
                    "cpu_credits": "standard"
                  }
                ],
                "disable_api_stop": false,
                "disable_api_termination": false,
                "ebs_block_device": [],
                "ebs_optimized": false,
                "enclave_options": [
                  {
                    "enabled": false
                  }
                ],
                "ephemeral_block_device": [],
                "get_password_data": false,
                "hibernation": false,
                "host_id": null,
                "host_resource_group_arn": null,
                "iam_instance_profile": "",
                "id": "i-0ae9425e491550cda",
                "instance_initiated_shutdown_behavior": "stop",
                "instance_state": "running",
                "instance_type": "t2.micro",
                "ipv6_address_count": 0,
                "ipv6_addresses": [],
                "key_name": "my_key",
                "launch_template": [],
                "maintenance_options": [
                  {
                    "auto_recovery": "default"
                  }
                ],
                "metadata_options": [
                  {
                    "http_endpoint": "enabled",
                    "http_put_response_hop_limit": 1,
                    "http_tokens": "optional",
                    "instance_metadata_tags": "disabled"
                  }
                ],
                "monitoring": false,
                "network_interface": [],
                "outpost_arn": "",
                "password_data": "",
                "placement_group": "",
                "placement_partition_number": null,
                "primary_network_interface_id": "eni-06b93fa31818b764a",
                "private_dns": "ip-172-31-16-89.us-west-1.compute.internal",
                "private_dns_name_options": [
                  {
                    "enable_resource_name_dns_a_record": false,
                    "enable_resource_name_dns_aaaa_record": false,
                    "hostname_type": "ip-name"
                  }
                ],
                "private_ip": "172.31.16.89",
                "public_dns": "ec2-13-57-20-240.us-west-1.compute.amazonaws.com",
                "public_ip": "13.57.20.240",
                "root_block_device": [
                  {
                    "delete_on_termination": true,
                    "device_name": "/dev/sda1",
                    "encrypted": false,
                    "iops": 100,
                    "kms_key_id": "",
                    "tags": {},
                    "throughput": 0,
                    "volume_id": "vol-01f0b4cfdd3eff669",
                    "volume_size": 8,
                    "volume_type": "gp2"
                  }
                ],
                "secondary_private_ips": [],
                "security_groups": [
                  "simple security group - for ssh Ingress only"
                ],
                "source_dest_check": true,
                "subnet_id": "subnet-01f855549f3efdd85",
                "tags": {
                  "LabName": "2.Workflow"
                },
                "tags_all": {
                  "LabName": "2.Workflow"
                },
                "tenancy": "default",
                "timeouts": null,
                "user_data": null,
                "user_data_base64": null,
                "user_data_replace_on_change": false,
                "volume_tags": null,
                "vpc_security_group_ids": [
                  "sg-0496213da9e7902ed"
                ]
              },
              "sensitive_attributes": [],
              "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6MTIwMDAwMDAwMDAwMCwidXBkYXRlIjo2MDAwMDAwMDAwMDB9LCJzY2hlbWFfdmVyc2lvbiI6IjEifQ==",
              "dependencies": [
                "aws_key_pair.generated_key",
                "aws_security_group.secgroup-ssh"
              ]
            }
          ]
        },
        {
          "mode": "managed",
          "type": "aws_key_pair",
          "name": "generated_key",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "arn": "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key",
                "fingerprint": "74:3b:95:8c:5a:48:ed:ce:f4:72:5d:84:3d:a9:2b:d9",
                "id": "my_key",
                "key_name": "my_key",
                "key_name_prefix": "",
                "key_pair_id": "key-0707e00e9686e982b",
                "key_type": "rsa",
                "public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy0t43evpn+ETsZIruhCp4hVuanhhLAT+wzyBiXspINJGfuiXs+jgsw02SfY8Um0UTPAWKlqCvrcoDy6l1lhMhWqaJP0ox88wg8O9DsUmNU33NkEUQ8ntSegug3ORaK6P5YxaORu6FSiYDyDY1dxGqW3nneqKTrlOHlagg/60B8kkH1HR1lJeWO/lLe4zL+gyU0JquPTW1nNOB8yDyIQx0i28wDEan4P9PHlTgn7PlcWsW31hGQKgXzpKJtZvppPfU+dnXUIdfqqwZb9HWBuL3Tm+19klaWmpWi1nf6eHW3epT8ocVNVsnR7dOUX9jut5PhCct/jCJKxkoYvzWIe47TAcpNObuN9ManaSqjv2kEzzCibWBEnE8TRrOgVZM2HjXGOicMyTiUnI682rSbzHl65OmbGkO86VXI6ROD7EoJj4gvli9A/YDjbQRq2ic4YaUtPghbaEc9nilZdRbP55b34VxEsWmqBBhCbDfQHVGo6A+1P9HxztfgVjTngkuRDE= student@tf",
                "tags": null,
                "tags_all": {}
              },
              "sensitive_attributes": [],
              "private": "eyJzY2hlbWFfdmVyc2lvbiI6IjEifQ=="
            }
          ]
        },
        {
          "mode": "managed",
          "type": "aws_security_group",
          "name": "secgroup-ssh",
          "provider": "provider[\"registry.terraform.io/hashicorp/aws\"]",
          "instances": [
            {
              "schema_version": 1,
              "attributes": {
                "arn": "arn:aws:ec2:us-west-1:816376574968:security-group/sg-0496213da9e7902ed",
                "description": "Managed by Terraform",
                "egress": [],
                "id": "sg-0496213da9e7902ed",
                "ingress": [
                  {
                    "cidr_blocks": [
                      "0.0.0.0/0"
                    ],
                    "description": "",
                    "from_port": 22,
                    "ipv6_cidr_blocks": [],
                    "prefix_list_ids": [],
                    "protocol": "tcp",
                    "security_groups": [],
                    "self": false,
                    "to_port": 22
                  }
                ],
                "name": "simple security group - for ssh Ingress only",
                "name_prefix": "",
                "owner_id": "816376574968",
                "revoke_rules_on_delete": false,
                "tags": {},
                "tags_all": {},
                "timeouts": null,
                "vpc_id": "vpc-0c4ad4047839bc08f"
              },
              "sensitive_attributes": [],
              "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6OTAwMDAwMDAwMDAwfSwic2NoZW1hX3ZlcnNpb24iOiIxIn0="
            }
          ]
        }
      ],
      "check_results": null
    }


#### Show terraform.tfstate.backup


```bash
terraform show terraform.tfstate.backup
```

    # aws_instance.example:
    resource "aws_instance" "example" {
        ami                                  = "ami-00a3e4424e9ab3e56"
        arn                                  = "arn:aws:ec2:us-west-1:816376574968:instance/i-0ae9425e491550cda"
        associate_public_ip_address          = true
        availability_zone                    = "us-west-1c"
        cpu_core_count                       = 1
        cpu_threads_per_core                 = 1
        disable_api_stop                     = false
        disable_api_termination              = false
        ebs_optimized                        = false
        get_password_data                    = false
        hibernation                          = false
        id                                   = "i-0ae9425e491550cda"
        instance_initiated_shutdown_behavior = "stop"
        instance_state                       = "running"
        instance_type                        = "t2.micro"
        ipv6_address_count                   = 0
        ipv6_addresses                       = []
        key_name                             = "my_key"
        monitoring                           = false
        primary_network_interface_id         = "eni-06b93fa31818b764a"
        private_dns                          = "ip-172-31-16-89.us-west-1.compute.internal"
        private_ip                           = "172.31.16.89"
        public_dns                           = "ec2-13-57-20-240.us-west-1.compute.amazonaws.com"
        public_ip                            = "13.57.20.240"
        secondary_private_ips                = []
        security_groups                      = [
            "simple security group - for ssh Ingress only",
        ]
        source_dest_check                    = true
        subnet_id                            = "subnet-01f855549f3efdd85"
        tags                                 = {
            "LabName" = "2.Workflow"
        }
        tags_all                             = {
            "LabName" = "2.Workflow"
        }
        tenancy                              = "default"
        user_data_replace_on_change          = false
        vpc_security_group_ids               = [
            "sg-0496213da9e7902ed",
        ]
    
        capacity_reservation_specification {
            capacity_reservation_preference = "open"
        }
    
        credit_specification {
            cpu_credits = "standard"
        }
    
        enclave_options {
            enabled = false
        }
    
        maintenance_options {
            auto_recovery = "default"
        }
    
        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
            instance_metadata_tags      = "disabled"
        }
    
        private_dns_name_options {
            enable_resource_name_dns_a_record    = false
            enable_resource_name_dns_aaaa_record = false
            hostname_type                        = "ip-name"
        }
    
        root_block_device {
            delete_on_termination = true
            device_name           = "/dev/sda1"
            encrypted             = false
            iops                  = 100
            tags                  = {}
            throughput            = 0
            volume_id             = "vol-01f0b4cfdd3eff669"
            volume_size           = 8
            volume_type           = "gp2"
        }
    }
    
    # aws_key_pair.generated_key:
    resource "aws_key_pair" "generated_key" {
        arn         = "arn:aws:ec2:us-west-1:816376574968:key-pair/my_key"
        fingerprint = "74:3b:95:8c:5a:48:ed:ce:f4:72:5d:84:3d:a9:2b:d9"
        id          = "my_key"
        key_name    = "my_key"
        key_pair_id = "key-0707e00e9686e982b"
        key_type    = "rsa"
        public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy0t43evpn+ETsZIruhCp4hVuanhhLAT+wzyBiXspINJGfuiXs+jgsw02SfY8Um0UTPAWKlqCvrcoDy6l1lhMhWqaJP0ox88wg8O9DsUmNU33NkEUQ8ntSegug3ORaK6P5YxaORu6FSiYDyDY1dxGqW3nneqKTrlOHlagg/60B8kkH1HR1lJeWO/lLe4zL+gyU0JquPTW1nNOB8yDyIQx0i28wDEan4P9PHlTgn7PlcWsW31hGQKgXzpKJtZvppPfU+dnXUIdfqqwZb9HWBuL3Tm+19klaWmpWi1nf6eHW3epT8ocVNVsnR7dOUX9jut5PhCct/jCJKxkoYvzWIe47TAcpNObuN9ManaSqjv2kEzzCibWBEnE8TRrOgVZM2HjXGOicMyTiUnI682rSbzHl65OmbGkO86VXI6ROD7EoJj4gvli9A/YDjbQRq2ic4YaUtPghbaEc9nilZdRbP55b34VxEsWmqBBhCbDfQHVGo6A+1P9HxztfgVjTngkuRDE= student@tf"
        tags_all    = {}
    }
    
    # aws_security_group.secgroup-ssh:
    resource "aws_security_group" "secgroup-ssh" {
        arn                    = "arn:aws:ec2:us-west-1:816376574968:security-group/sg-0496213da9e7902ed"
        description            = "Managed by Terraform"
        egress                 = []
        id                     = "sg-0496213da9e7902ed"
        ingress                = [
            {
                cidr_blocks      = [
                    "0.0.0.0/0",
                ]
                description      = ""
                from_port        = 22
                ipv6_cidr_blocks = []
                prefix_list_ids  = []
                protocol         = "tcp"
                security_groups  = []
                self             = false
                to_port          = 22
            },
        ]
        name                   = "simple security group - for ssh Ingress only"
        owner_id               = "816376574968"
        revoke_rules_on_delete = false
        tags                   = {}
        tags_all               = {}
        vpc_id                 = "vpc-0c4ad4047839bc08f"
    }
    
    
    Outputs:
    
    private_ip = "172.31.16.89"
    public_dns = "ec2-13-57-20-240.us-west-1.compute.amazonaws.com"
    public_ip = "13.57.20.240"


<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

- In this exercise we again went through the workflow of init, plan, apply steps to create an "*aws_instance*" resource.
- We saw how we can use the *TLS* provider to create a key, and then an aws_key_pair to be able to connect to our VM
- Later we saw how to use and exising ssh key file
- We learnt about the TF_DATA_DIR allowing us to use a common location for downloaded modules & providers
- We output the *aws_instance.example.public_ip* as a variable *public_ip* and then tried to connect using ssh
- The ssh connect failed as we had not opened the ssh port 
- We created and assigned a security group to the instance definition
- We re-applied the config - which created/attached the security group without recreating the aws_instance.
- We then added a key_pair definition to the config
- We could then connect using the vm.pem ssh key
- We created a graphic representing our infrastructure
- We then destroyed our infrastructure and compared the terraform.tfstate with the backup



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Solutions

Solutions are available in the *github* repo at ```https://github.com/mjbright/tf-scenarios``` under Solutions at https://github.com/mjbright/tf-scenarios/tree/main/Solutions/lab2



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Ambitious **Stretch Goal 1:** Diagramming

With your own AWS account - as an ambitious stretch goal, look at modelling arbitrary AWS resources using

https://stelligent.com/2020/06/15/continuous-diagrams-as-code-for-aws/

https://github.com/PaulDuvall/diagrams-as-code

<hr/>
<!--
<img src="../../../static/images/ThickBlueBar.png" />
<img src="../../../static/images/LOGO.jpg" width=200 />
-->
<img src="../images/ThickBlueBar.png" />
<img src="../images/LOGO.jpg" width=200 />




```bash
#cd $NB_DIR
#cd ~/src/mjbright.tf-scenarios-private/ServeUpLabs/content/tf-labs/2.Workflow

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]



