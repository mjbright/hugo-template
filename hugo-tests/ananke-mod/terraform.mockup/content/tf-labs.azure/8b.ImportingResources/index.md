---
title: 'Lab 8b. Importing Foreign Resources'
date: 2019-02-11T19:27:37+10:00
weight: 100
---


## Background:

In this lab, we will see how we can import AWS resources which were not created by Terraform itself so that Terraform can be subsequently used to manage these resources.

**Note**: Be careful not to manage resource both *outside* and *inside* Terraform

We will look at importing resources using
- the ```terraform import``` command

Tasks.
- As before, create a new directory lab 8b, and create three files, resources.tf, main.tf and vars.tf.

## Tasks

## 1. Importing a resource using ```terraform import```

#### First we will check if there are any instances running

Use the command ```/usr/bin/get_instances.sh -ir``` to determine if there are already running instances.

If there are any you may wish to return to previous lab directories and perform ```terraform destroy``` to delete these resources.

The important thing is to know what instances if any are currently running

You should have no Terraform managed resources in the current workspace, verify this

```
> terraform show
No state.
```

#### Launch a new instance using the aws client

Launch a new aws_instance using the aws cli client using the following command:

```
aws ec2 run-instances --count 1 --tag-specifications 'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```

**Note**: that we added a tag to identify this as a non-Terraform resource

**Note**: You may need to wait a minute for the VM to be visible ( in the running state )

then verify the running instances again using
```/usr/bin/get_instances.sh -ir```

Again, you should have no Terraform managed resources in the current workspace, verify this


#### Create a resource file for the running instance (not yet managed by Terraform)

We can create a simple terraform resource to be able to import this instance so it can be managed by terraform.

Create a new file import.tf with the **following form** with the **appropriate values** for the instance **you created** earlier:

```tf
resource "aws_instance" "imported_item" {
    ami = "YOUR_IMAGE_ID"
    instance_type = "YOUR_TYPE"
}
```

You can now import your resource - use your instance id in place of ```i-0a9bebf576ac2e4b8 ``` in the below command:
```
$ terraform import aws_instance.imported_item i-0a9bebf576ac2e4b8 
aws_instance.item: Importing from ID "i-0a9bebf576ac2e4b8"...
aws_instance.item: Import prepared!
  Prepared aws_instance for import
aws_instance.item: Refreshing state... [id=i-0a9bebf576ac2e4b8]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

Now verify that you can see the instance using ```terraform show```

#### Now we can destroy the instance

You succeeded, you can now cleanup using ```terraform destroy```

Remove, or rename import.tf as import.tf.bak


## 2. Importing resources using ```dtan4/terraforming```

The tool terraforming has already been installed for you

Note: it suffices to install ruby, and them 'gem install terraforming'

#### Create again an aws instance using the command

First verify that no instances are running:
```/usr/bin/get_instances.sh -ir```

Now launch a new instance using the aws cli tool:

```
aws ec2 run-instances --count 1 --tag-specifications 'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```
then verify the running instances again using
```/usr/bin/get_instances.sh -ir```


#### Create a configuration file using *terraforming*

Create a terraform configuration of any ec2 instances using command:

```
terraforming ec2 > tf_import.tf
```

Inspect this file

#### Apply the new configuration

Apply the new configuration and verify that terraform is now managing this instance

**Note**: If the file contains old-syntax "tags {", replace with the new-syntax "tags = {"

**Note**: You may also need to remove the *private_ip* line from the configuration

#### Now we can destroy the instance

You succeeded, you can now cleanup using ```terraform destroy```


# **Stretch Goal**: Import other resource types


Try now to import other resource types, such as an S3 bucket, using *terraform import*' and/or '*terraforming*' tools




