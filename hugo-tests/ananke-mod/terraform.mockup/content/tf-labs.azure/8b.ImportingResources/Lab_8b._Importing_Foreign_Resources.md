---
title:  Lab 8b. Importing Foreign Resources
date:   1673367425
weight: 82
---
<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

In this lab, we will see how we can import AWS resources which were not created by Terraform itself so that Terraform can be subsequently used to manage these resources.

**Note**: Be careful not to manage resource both *outside* and *inside* Terraform

We will look at importing resources using
- the ```terraform import``` command

Tasks.
- As before, create a new directory lab 8b, and create three files, resources.tf, main.tf and vars.tf.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 1. Importing a resource using ```terraform import```

### First Create a new lab directory and move to that directory



```bash
mkdir -p ~/labs/lab8b

cd       ~/labs/lab8b
```

Use the command ```/usr/local/bin/get_instances.sh -ir``` to determine if there are already running instances.

If there are any you may wish to return to previous lab directories and perform ```terraform destroy``` to delete these resources.

The important thing is to know what instances if any are currently running

You should have no Terraform managed resources in the current workspace, verify this

#### First we will check if there are any instances running

Use the command ```/usr/local/bin/get_instances.sh -ir``` to determine if there are already running instances.

If there are any you may wish to return to previous lab directories and perform ```terraform destroy``` to delete these resources.

The important thing is to know what instances if any are currently running

You should have no Terraform managed resources in the current workspace, verify this


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:0]-- All running instances -----------------





```bash
terraform show
```

    No state.


#### Launch a new instance using the aws client

Launch a new aws_instance using the aws cli client using the following command:


```bash
aws ec2 run-instances --count 1  --tag-specifications \
    'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' \
    --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```

    {
        "Groups": [],
        "Instances": [
            {
                "AmiLaunchIndex": 0,
                "ImageId": "ami-0e42deec9aa2c90ce",
                "InstanceId": "i-0c64a2a817f87d708",
                "InstanceType": "t2.micro",
                "LaunchTime": "2022-02-15T13:06:32+00:00",
                "Monitoring": {
                    "State": "disabled"
                },
                "Placement": {
                    "AvailabilityZone": "us-west-1b",
                    "GroupName": "",
                    "Tenancy": "default"
                },
                "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                "PrivateIpAddress": "172.31.10.166",
                "ProductCodes": [],
                "PublicDnsName": "",
                "State": {
                    "Code": 0,
                    "Name": "pending"
                },
                "StateTransitionReason": "",
                "SubnetId": "subnet-2c6ba676",
                "VpcId": "vpc-af4583c9",
                "Architecture": "x86_64",
                "BlockDeviceMappings": [],
                "ClientToken": "32c84294-4209-425d-9871-8941e601011a",
                "EbsOptimized": false,
                "EnaSupport": true,
                "Hypervisor": "xen",
                "NetworkInterfaces": [
                    {
                        "Attachment": {
                            "AttachTime": "2022-02-15T13:06:32+00:00",
                            "AttachmentId": "eni-attach-0358b187c0b434799",
                            "DeleteOnTermination": true,
                            "DeviceIndex": 0,
                            "Status": "attaching",
                            "NetworkCardIndex": 0
                        },
                        "Description": "",
                        "Groups": [
                            {
                                "GroupName": "default",
                                "GroupId": "sg-4ab88d3e"
                            }
                        ],
                        "Ipv6Addresses": [],
                        "MacAddress": "06:29:b3:6b:8e:07",
                        "NetworkInterfaceId": "eni-0406b21cd4b5e2417",
                        "OwnerId": "604682923221",
                        "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                        "PrivateIpAddress": "172.31.10.166",
                        "PrivateIpAddresses": [
                            {
                                "Primary": true,
                                "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                                "PrivateIpAddress": "172.31.10.166"
                            }
                        ],
                        "SourceDestCheck": true,
                        "Status": "in-use",
                        "SubnetId": "subnet-2c6ba676",
                        "VpcId": "vpc-af4583c9",
                        "InterfaceType": "interface"
                    }
                ],
                "RootDeviceName": "/dev/sda1",
                "RootDeviceType": "ebs",
                "SecurityGroups": [
                    {
                        "GroupName": "default",
                        "GroupId": "sg-4ab88d3e"
                    }
                ],
                "SourceDestCheck": true,
                "StateReason": {
                    "Code": "pending",
                    "Message": "pending"
                },
                "Tags": [
                    {
                        "Key": "aws-cli",
                        "Value": "true"
                    }
                ],
                "VirtualizationType": "hvm",
                "CpuOptions": {
                    "CoreCount": 1,
                    "ThreadsPerCore": 1
                },
                "CapacityReservationSpecification": {
                    "CapacityReservationPreference": "open"
                },
                "MetadataOptions": {
                    "State": "pending",
                    "HttpTokens": "optional",
                    "HttpPutResponseHopLimit": 1,
                    "HttpEndpoint": "enabled",
                    "HttpProtocolIpv6": "disabled"
                },
                "EnclaveOptions": {
                    "Enabled": false
                }
            }
        ],
        "OwnerId": "604682923221",
        "ReservationId": "r-066e67220866f7dcc"
    }


**Note**: that we added a tag to identify this as a non-Terraform resource

**Note**: You may need to wait a minute for the VM to be visible ( in the running state )

then verify the running instances again using


```bash
/usr/local/bin/get_instances.sh -ir
```


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:1]-- All running instances -----------------
    {"id":"i-0c64a2a817f87d708","image":"ami-0e42deec9aa2c90ce","state":"[00;32mrunning[00m","Tags":[{"Key":"aws-cli","Value":"true"}],"LaunchTime":"2022-02-15T13:06:32+00:00"}




Again, you should have no Terraform managed resources in the current workspace, verify this


#### Create a resource file for the running instance (not yet managed by Terraform)

We can create a simple terraform resource to be able to import this instance so it can be managed by terraform.

Create a new file import.tf with the **following form** with the **appropriate values** for the instance **you created** earlier:

```hcl
resource "aws_instance" "imported_item" {
    ami = "YOUR_IMAGE_ID"
    instance_type = "YOUR_TYPE"
}
```

You can now import your resource - use your instance id from the above output, e.g. *"i-06817c3963d2716c9"* in the command below:


```bash
terraform import aws_instance.imported_item 'i-0c64a2a817f87d708'
```

    aws_instance.imported_item: Importing from ID "i-0c64a2a817f87d708"...
    aws_instance.imported_item: Import prepared!
      Prepared aws_instance for import
    aws_instance.imported_item: Refreshing state... [id=i-0c64a2a817f87d708]
    
    Import successful!
    
    The resources that were imported are shown above. These resources are now in
    your Terraform state and will henceforth be managed by Terraform.
    


### Verify that terraform has imported the resource

Now verify that you can see the instance using 
- Looking at the newly created ```terraform.tfstate``` file
- Using the ```terraform show``` and ```terraform state list``` commands

### Reflect on this

Think about what we just did, we

- created an *AWS EC2 instance* without using Terraform

- we then created a dummy *import.tf* partially describing the resource, containing just
  - the *ami_id*
  - the *instance_type*
  
- we then ran the ```terraform import``` command referencing the instance *id* of the EC2 instance

Once we performed these steps the resource has now been imported into the terraform state.

We can use this mechanism to start to manage infrastructure resources previously generated outside of *Terraform*.

**NOTE:** Note also that this is not very functional, there are a lot of manual steps to take to import a single resource - but 3rd-party tools exist ...

#### Now we can destroy the instance

You succeeded, you can now cleanup using ```terraform destroy```

Remove, or rename import.tf as import.tf.bak

### Verify that the terraform state is empty

Check the ```terraform.tfstate``` file and run ```terraform state list``` to verify that we have now destroyed the resource.

### Note that independently of Terraform the VM instance is nevertheless present in AWS but ```Terminating```

Note that the ```/usr/local/bin/get_instances.sh -ir``` command shows ```Running``` instances only ... the previously destroyed instance may still be present but in the ```Terminated``` or other state-*

You can verify none ```Running``` instances using either of the commands
- ```/usr/local/bin/get_instances.sh```
- or ```aws ec2 describe-instances```




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2. Importing resources using ```GoogleCloudPlatform/terraformer```


Terraformer is a tool from Google for importing resources from various providers.

See the list at https://github.com/GoogleCloudPlatform/terraformer#table-of-contents

The tool terraformer-aws has already been installed for you as ``` /usr/local/bin/terraformer-aws```

#### Create again an aws instance using the command

First verify that no instances are running:


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:0]-- All running instances -----------------





```bash
aws ec2 run-instances --count 1 --tag-specifications \
    'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' \
    --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```

    {
        "Groups": [],
        "Instances": [
            {
                "AmiLaunchIndex": 0,
                "ImageId": "ami-0e42deec9aa2c90ce",
                "InstanceId": "i-094b2ad1b98336c11",
                "InstanceType": "t2.micro",
                "LaunchTime": "2022-02-15T13:40:55+00:00",
                "Monitoring": {
                    "State": "disabled"
                },
                "Placement": {
                    "AvailabilityZone": "us-west-1b",
                    "GroupName": "",
                    "Tenancy": "default"
                },
                "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                "PrivateIpAddress": "172.31.14.128",
                "ProductCodes": [],
                "PublicDnsName": "",
                "State": {
                    "Code": 0,
                    "Name": "pending"
                },
                "StateTransitionReason": "",
                "SubnetId": "subnet-2c6ba676",
                "VpcId": "vpc-af4583c9",
                "Architecture": "x86_64",
                "BlockDeviceMappings": [],
                "ClientToken": "b9e0b9ef-5123-4b45-822d-fc4bf8d7b045",
                "EbsOptimized": false,
                "EnaSupport": true,
                "Hypervisor": "xen",
                "NetworkInterfaces": [
                    {
                        "Attachment": {
                            "AttachTime": "2022-02-15T13:40:55+00:00",
                            "AttachmentId": "eni-attach-0260b8abdb86fb385",
                            "DeleteOnTermination": true,
                            "DeviceIndex": 0,
                            "Status": "attaching",
                            "NetworkCardIndex": 0
                        },
                        "Description": "",
                        "Groups": [
                            {
                                "GroupName": "default",
                                "GroupId": "sg-4ab88d3e"
                            }
                        ],
                        "Ipv6Addresses": [],
                        "MacAddress": "06:99:e5:66:85:8b",
                        "NetworkInterfaceId": "eni-08236b87d3d21c6c1",
                        "OwnerId": "604682923221",
                        "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                        "PrivateIpAddress": "172.31.14.128",
                        "PrivateIpAddresses": [
                            {
                                "Primary": true,
                                "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                                "PrivateIpAddress": "172.31.14.128"
                            }
                        ],
                        "SourceDestCheck": true,
                        "Status": "in-use",
                        "SubnetId": "subnet-2c6ba676",
                        "VpcId": "vpc-af4583c9",
                        "InterfaceType": "interface"
                    }
                ],
                "RootDeviceName": "/dev/sda1",
                "RootDeviceType": "ebs",
                "SecurityGroups": [
                    {
                        "GroupName": "default",
                        "GroupId": "sg-4ab88d3e"
                    }
                ],
                "SourceDestCheck": true,
                "StateReason": {
                    "Code": "pending",
                    "Message": "pending"
                },
                "Tags": [
                    {
                        "Key": "aws-cli",
                        "Value": "true"
                    }
                ],
                "VirtualizationType": "hvm",
                "CpuOptions": {
                    "CoreCount": 1,
                    "ThreadsPerCore": 1
                },
                "CapacityReservationSpecification": {
                    "CapacityReservationPreference": "open"
                },
                "MetadataOptions": {
                    "State": "pending",
                    "HttpTokens": "optional",
                    "HttpPutResponseHopLimit": 1,
                    "HttpEndpoint": "enabled",
                    "HttpProtocolIpv6": "disabled"
                },
                "EnclaveOptions": {
                    "Enabled": false
                }
            }
        ],
        "OwnerId": "604682923221",
        "ReservationId": "r-0a50cc2e96d44a710"
    }


### Import the new instance using ```terraformer-aws```

The ```terraformer-aws``` usage is documented at https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md

We will now use ```terraformer-aws``` to import all ```Running``` instances from the ```us-west-1``` region which we're using.

**Note:** It may also detect the previous ```Terminated``` instance as below, it will import only ```Running``` resources.


```bash
terraformer-aws import aws --resources=ec2_instance \
    --connect=true --regions=us-west-1 --profile ""
```

    2022/02/15 13:41:36 aws importing region us-west-1
    2022/02/15 13:41:39 aws importing... ec2_instance
    2022/02/15 13:41:41 aws done importing ec2_instance
    2022/02/15 13:41:41 Number of resources for service ec2_instance: 5
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-094b2ad1b98336c11_
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:47 Filtered number of resources for service ec2_instance: 1
    2022/02/15 13:41:47 aws Connecting.... 
    2022/02/15 13:41:47 aws save ec2_instance
    2022/02/15 13:41:47 aws save tfstate for ec2_instance



```bash
ll -tr generated/aws/ec2_instance
```

    total 28
    -rwxr-xr-x 1 student docker  123 Feb 15 13:41 [01;32mprovider.tf
    -rwxr-xr-x 1 student docker  114 Feb 15 13:41 [01;32moutputs.tf
    drwxr-xr-x 3 student docker 4096 Feb 15 13:41 [01;34m..
    -rwxr-xr-x 1 student docker 5417 Feb 15 13:41 [01;32mterraform.tfstate
    -rwxr-xr-x 1 student docker 1448 Feb 15 13:41 [01;32minstance.tf
    drwxr-xr-x 2 student docker 4096 Feb 15 13:41 [01;34m.


### Verify that the instance has been created

```Terraformer``` has created a subdirectory with the appropriate Terraform config files and a ```terraform.tfstate``` file.

This was a much nicer experience than using ```terraform import``` directly.


```bash
cd generated/aws/ec2_instance

terraform state list
```

    aws_instance.tfer--i-094b2ad1b98336c11_


### Browse the documentation

This is quite a powerful tool, facilitating the importing of resources into ```Terraform```

- discovery of resources by type, by region

- importing of resources from many provider types, not just AWS.

Take a look at the documentation at https://github.com/GoogleCloudPlatform/terraformer, 

### Delete the instance has been created

You will need to be in the ```generated/aws/ec2_instance``` directory of course to perform the ```terraform destroy```




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal**: Import other resource types


Try now to import other resource types, such as an S3 bucket, using *terraform import*' and/or '*terraforming*' tools

<hr/>
<!-- ![](/images/LOGO_v2_CROPPED.jpg) --> <img src="../../../static/images/LOGO_v2_CROPPED.jpg" width="200" />
<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

In this lab, we will see how we can import AWS resources which were not created by Terraform itself so that Terraform can be subsequently used to manage these resources.

**Note**: Be careful not to manage resource both *outside* and *inside* Terraform

We will look at importing resources using
- the ```terraform import``` command

Tasks.
- As before, create a new directory lab 8b, and create three files, resources.tf, main.tf and vars.tf.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 1. Importing a resource using ```terraform import```

### First Create a new lab directory and move to that directory



```bash
mkdir -p ~/labs/lab8b

cd       ~/labs/lab8b
```

Use the command ```/usr/local/bin/get_instances.sh -ir``` to determine if there are already running instances.

If there are any you may wish to return to previous lab directories and perform ```terraform destroy``` to delete these resources.

The important thing is to know what instances if any are currently running

You should have no Terraform managed resources in the current workspace, verify this

#### First we will check if there are any instances running

Use the command ```/usr/local/bin/get_instances.sh -ir``` to determine if there are already running instances.

If there are any you may wish to return to previous lab directories and perform ```terraform destroy``` to delete these resources.

The important thing is to know what instances if any are currently running

You should have no Terraform managed resources in the current workspace, verify this


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:0]-- All running instances -----------------





```bash
terraform show
```

    No state.


#### Launch a new instance using the aws client

Launch a new aws_instance using the aws cli client using the following command:


```bash
aws ec2 run-instances --count 1  --tag-specifications \
    'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' \
    --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```

    {
        "Groups": [],
        "Instances": [
            {
                "AmiLaunchIndex": 0,
                "ImageId": "ami-0e42deec9aa2c90ce",
                "InstanceId": "i-0c64a2a817f87d708",
                "InstanceType": "t2.micro",
                "LaunchTime": "2022-02-15T13:06:32+00:00",
                "Monitoring": {
                    "State": "disabled"
                },
                "Placement": {
                    "AvailabilityZone": "us-west-1b",
                    "GroupName": "",
                    "Tenancy": "default"
                },
                "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                "PrivateIpAddress": "172.31.10.166",
                "ProductCodes": [],
                "PublicDnsName": "",
                "State": {
                    "Code": 0,
                    "Name": "pending"
                },
                "StateTransitionReason": "",
                "SubnetId": "subnet-2c6ba676",
                "VpcId": "vpc-af4583c9",
                "Architecture": "x86_64",
                "BlockDeviceMappings": [],
                "ClientToken": "32c84294-4209-425d-9871-8941e601011a",
                "EbsOptimized": false,
                "EnaSupport": true,
                "Hypervisor": "xen",
                "NetworkInterfaces": [
                    {
                        "Attachment": {
                            "AttachTime": "2022-02-15T13:06:32+00:00",
                            "AttachmentId": "eni-attach-0358b187c0b434799",
                            "DeleteOnTermination": true,
                            "DeviceIndex": 0,
                            "Status": "attaching",
                            "NetworkCardIndex": 0
                        },
                        "Description": "",
                        "Groups": [
                            {
                                "GroupName": "default",
                                "GroupId": "sg-4ab88d3e"
                            }
                        ],
                        "Ipv6Addresses": [],
                        "MacAddress": "06:29:b3:6b:8e:07",
                        "NetworkInterfaceId": "eni-0406b21cd4b5e2417",
                        "OwnerId": "604682923221",
                        "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                        "PrivateIpAddress": "172.31.10.166",
                        "PrivateIpAddresses": [
                            {
                                "Primary": true,
                                "PrivateDnsName": "ip-172-31-10-166.us-west-1.compute.internal",
                                "PrivateIpAddress": "172.31.10.166"
                            }
                        ],
                        "SourceDestCheck": true,
                        "Status": "in-use",
                        "SubnetId": "subnet-2c6ba676",
                        "VpcId": "vpc-af4583c9",
                        "InterfaceType": "interface"
                    }
                ],
                "RootDeviceName": "/dev/sda1",
                "RootDeviceType": "ebs",
                "SecurityGroups": [
                    {
                        "GroupName": "default",
                        "GroupId": "sg-4ab88d3e"
                    }
                ],
                "SourceDestCheck": true,
                "StateReason": {
                    "Code": "pending",
                    "Message": "pending"
                },
                "Tags": [
                    {
                        "Key": "aws-cli",
                        "Value": "true"
                    }
                ],
                "VirtualizationType": "hvm",
                "CpuOptions": {
                    "CoreCount": 1,
                    "ThreadsPerCore": 1
                },
                "CapacityReservationSpecification": {
                    "CapacityReservationPreference": "open"
                },
                "MetadataOptions": {
                    "State": "pending",
                    "HttpTokens": "optional",
                    "HttpPutResponseHopLimit": 1,
                    "HttpEndpoint": "enabled",
                    "HttpProtocolIpv6": "disabled"
                },
                "EnclaveOptions": {
                    "Enabled": false
                }
            }
        ],
        "OwnerId": "604682923221",
        "ReservationId": "r-066e67220866f7dcc"
    }


**Note**: that we added a tag to identify this as a non-Terraform resource

**Note**: You may need to wait a minute for the VM to be visible ( in the running state )

then verify the running instances again using


```bash
/usr/local/bin/get_instances.sh -ir
```


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:1]-- All running instances -----------------
    {"id":"i-0c64a2a817f87d708","image":"ami-0e42deec9aa2c90ce","state":"[00;32mrunning[00m","Tags":[{"Key":"aws-cli","Value":"true"}],"LaunchTime":"2022-02-15T13:06:32+00:00"}




Again, you should have no Terraform managed resources in the current workspace, verify this


#### Create a resource file for the running instance (not yet managed by Terraform)

We can create a simple terraform resource to be able to import this instance so it can be managed by terraform.

Create a new file import.tf with the **following form** with the **appropriate values** for the instance **you created** earlier:

```hcl
resource "aws_instance" "imported_item" {
    ami = "YOUR_IMAGE_ID"
    instance_type = "YOUR_TYPE"
}
```

You can now import your resource - use your instance id from the above output, e.g. *"i-06817c3963d2716c9"* in the command below:


```bash
terraform import aws_instance.imported_item 'i-0c64a2a817f87d708'
```

    aws_instance.imported_item: Importing from ID "i-0c64a2a817f87d708"...
    aws_instance.imported_item: Import prepared!
      Prepared aws_instance for import
    aws_instance.imported_item: Refreshing state... [id=i-0c64a2a817f87d708]
    
    Import successful!
    
    The resources that were imported are shown above. These resources are now in
    your Terraform state and will henceforth be managed by Terraform.
    


### Verify that terraform has imported the resource

Now verify that you can see the instance using 
- Looking at the newly created ```terraform.tfstate``` file
- Using the ```terraform show``` and ```terraform state list``` commands

### Reflect on this

Think about what we just did, we

- created an *AWS EC2 instance* without using Terraform

- we then created a dummy *import.tf* partially describing the resource, containing just
  - the *ami_id*
  - the *instance_type*
  
- we then ran the ```terraform import``` command referencing the instance *id* of the EC2 instance

Once we performed these steps the resource has now been imported into the terraform state.

We can use this mechanism to start to manage infrastructure resources previously generated outside of *Terraform*.

**NOTE:** Note also that this is not very functional, there are a lot of manual steps to take to import a single resource - but 3rd-party tools exist ...

#### Now we can destroy the instance

You succeeded, you can now cleanup using ```terraform destroy```

Remove, or rename import.tf as import.tf.bak

### Verify that the terraform state is empty

Check the ```terraform.tfstate``` file and run ```terraform state list``` to verify that we have now destroyed the resource.

### Note that independently of Terraform the VM instance is nevertheless present in AWS but ```Terminating```

Note that the ```/usr/local/bin/get_instances.sh -ir``` command shows ```Running``` instances only ... the previously destroyed instance may still be present but in the ```Terminated``` or other state-*

You can verify none ```Running``` instances using either of the commands
- ```/usr/local/bin/get_instances.sh```
- or ```aws ec2 describe-instances```




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 2. Importing resources using ```GoogleCloudPlatform/terraformer```


Terraformer is a tool from Google for importing resources from various providers.

See the list at https://github.com/GoogleCloudPlatform/terraformer#table-of-contents

The tool terraformer-aws has already been installed for you as ``` /usr/local/bin/terraformer-aws```

#### Create again an aws instance using the command

First verify that no instances are running:


```bash
/usr/local/bin/get_instances.sh -ir
```

    
    -- 20_student [count:0]-- All running instances -----------------





```bash
aws ec2 run-instances --count 1 --tag-specifications \
    'ResourceType=instance,Tags=[{Key=aws-cli,Value=true}]' \
    --image-id ami-0e42deec9aa2c90ce --instance-type t2.micro
```

    {
        "Groups": [],
        "Instances": [
            {
                "AmiLaunchIndex": 0,
                "ImageId": "ami-0e42deec9aa2c90ce",
                "InstanceId": "i-094b2ad1b98336c11",
                "InstanceType": "t2.micro",
                "LaunchTime": "2022-02-15T13:40:55+00:00",
                "Monitoring": {
                    "State": "disabled"
                },
                "Placement": {
                    "AvailabilityZone": "us-west-1b",
                    "GroupName": "",
                    "Tenancy": "default"
                },
                "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                "PrivateIpAddress": "172.31.14.128",
                "ProductCodes": [],
                "PublicDnsName": "",
                "State": {
                    "Code": 0,
                    "Name": "pending"
                },
                "StateTransitionReason": "",
                "SubnetId": "subnet-2c6ba676",
                "VpcId": "vpc-af4583c9",
                "Architecture": "x86_64",
                "BlockDeviceMappings": [],
                "ClientToken": "b9e0b9ef-5123-4b45-822d-fc4bf8d7b045",
                "EbsOptimized": false,
                "EnaSupport": true,
                "Hypervisor": "xen",
                "NetworkInterfaces": [
                    {
                        "Attachment": {
                            "AttachTime": "2022-02-15T13:40:55+00:00",
                            "AttachmentId": "eni-attach-0260b8abdb86fb385",
                            "DeleteOnTermination": true,
                            "DeviceIndex": 0,
                            "Status": "attaching",
                            "NetworkCardIndex": 0
                        },
                        "Description": "",
                        "Groups": [
                            {
                                "GroupName": "default",
                                "GroupId": "sg-4ab88d3e"
                            }
                        ],
                        "Ipv6Addresses": [],
                        "MacAddress": "06:99:e5:66:85:8b",
                        "NetworkInterfaceId": "eni-08236b87d3d21c6c1",
                        "OwnerId": "604682923221",
                        "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                        "PrivateIpAddress": "172.31.14.128",
                        "PrivateIpAddresses": [
                            {
                                "Primary": true,
                                "PrivateDnsName": "ip-172-31-14-128.us-west-1.compute.internal",
                                "PrivateIpAddress": "172.31.14.128"
                            }
                        ],
                        "SourceDestCheck": true,
                        "Status": "in-use",
                        "SubnetId": "subnet-2c6ba676",
                        "VpcId": "vpc-af4583c9",
                        "InterfaceType": "interface"
                    }
                ],
                "RootDeviceName": "/dev/sda1",
                "RootDeviceType": "ebs",
                "SecurityGroups": [
                    {
                        "GroupName": "default",
                        "GroupId": "sg-4ab88d3e"
                    }
                ],
                "SourceDestCheck": true,
                "StateReason": {
                    "Code": "pending",
                    "Message": "pending"
                },
                "Tags": [
                    {
                        "Key": "aws-cli",
                        "Value": "true"
                    }
                ],
                "VirtualizationType": "hvm",
                "CpuOptions": {
                    "CoreCount": 1,
                    "ThreadsPerCore": 1
                },
                "CapacityReservationSpecification": {
                    "CapacityReservationPreference": "open"
                },
                "MetadataOptions": {
                    "State": "pending",
                    "HttpTokens": "optional",
                    "HttpPutResponseHopLimit": 1,
                    "HttpEndpoint": "enabled",
                    "HttpProtocolIpv6": "disabled"
                },
                "EnclaveOptions": {
                    "Enabled": false
                }
            }
        ],
        "OwnerId": "604682923221",
        "ReservationId": "r-0a50cc2e96d44a710"
    }


### Import the new instance using ```terraformer-aws```

The ```terraformer-aws``` usage is documented at https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md

We will now use ```terraformer-aws``` to import all ```Running``` instances from the ```us-west-1``` region which we're using.

**Note:** It may also detect the previous ```Terminated``` instance as below, it will import only ```Running``` resources.


```bash
terraformer-aws import aws --resources=ec2_instance \
    --connect=true --regions=us-west-1 --profile ""
```

    2022/02/15 13:41:36 aws importing region us-west-1
    2022/02/15 13:41:39 aws importing... ec2_instance
    2022/02/15 13:41:41 aws done importing ec2_instance
    2022/02/15 13:41:41 Number of resources for service ec2_instance: 5
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-094b2ad1b98336c11_
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:41 Refreshing state... aws_instance.tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:42 ERROR: Read resource response is null for resource aws_instance.tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0bee8fe5da641d83c_instance1
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0c6c9273dca5afed4_instance2
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0c64a2a817f87d708_
    2022/02/15 13:41:47 ERROR: Unable to refresh resource tfer--i-0ecc82123cb735e97_
    2022/02/15 13:41:47 Filtered number of resources for service ec2_instance: 1
    2022/02/15 13:41:47 aws Connecting.... 
    2022/02/15 13:41:47 aws save ec2_instance
    2022/02/15 13:41:47 aws save tfstate for ec2_instance



```bash
ll -tr generated/aws/ec2_instance
```

    total 28
    -rwxr-xr-x 1 student docker  123 Feb 15 13:41 [01;32mprovider.tf
    -rwxr-xr-x 1 student docker  114 Feb 15 13:41 [01;32moutputs.tf
    drwxr-xr-x 3 student docker 4096 Feb 15 13:41 [01;34m..
    -rwxr-xr-x 1 student docker 5417 Feb 15 13:41 [01;32mterraform.tfstate
    -rwxr-xr-x 1 student docker 1448 Feb 15 13:41 [01;32minstance.tf
    drwxr-xr-x 2 student docker 4096 Feb 15 13:41 [01;34m.


### Verify that the instance has been created

```Terraformer``` has created a subdirectory with the appropriate Terraform config files and a ```terraform.tfstate``` file.

This was a much nicer experience than using ```terraform import``` directly.


```bash
cd generated/aws/ec2_instance

terraform state list
```

    aws_instance.tfer--i-094b2ad1b98336c11_


### Browse the documentation

This is quite a powerful tool, facilitating the importing of resources into ```Terraform```

- discovery of resources by type, by region

- importing of resources from many provider types, not just AWS.

Take a look at the documentation at https://github.com/GoogleCloudPlatform/terraformer, 

### Delete the instance has been created

You will need to be in the ```generated/aws/ec2_instance``` directory of course to perform the ```terraform destroy```




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# **Stretch Goal**: Import other resource types


Try now to import other resource types, such as an S3 bucket, using *terraform import*' and/or '*terraforming*' tools

<hr/>
<!-- ![](../../../static/images/LOGO_v2_CROPPED.jpg) --> <img src="../../../static/images/LOGO_v2_CROPPED.jpg" width="200" />
