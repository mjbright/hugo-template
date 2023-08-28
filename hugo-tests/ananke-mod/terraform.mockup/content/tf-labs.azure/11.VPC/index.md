---
title: 'Lab 11. VPC (Virtual Private Cloud)'
date: 2019-02-11T19:27:37+10:00
weight: 110
---


## Background:
In this exercise we will demonstrate creation of a VPC


## Tasks:

### 1. Make a directory called ‘labs/lab11’ underneath the home directory.
### 2. Change into the directory.

### 3. Create a file named main.tf with the following content

```tf
provider "aws" {
        region = var.region
}

```

### 4. Create a file named instance.tf with the following content
```tf
resource "aws_instance" "example" {
  ami           = "ami-0e81aa4c57820bb57"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.main-public-1.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # the public SSH key
  key_name = "terraform-course-keypair"
}

resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "us-west-1a"
    size = 20
    type = "gp2"
    tags = {
        Name = "extra volume data"
    }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.example.id}"
}

resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-ssh"
  description = "security group that allows ssh and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}

```

Note how this file defines the instance, a EBS raw disk volume which is attached/mounted on the instance.


### 4. Create a file named outputs.tf with the following content
```tf
output "public_ip" {
  value = aws_instance.example.public_ip
}

output "public_dns" {
  value = aws_instance.example.public_dns
}

```

To output instance ip/dns information for connectiing.

### 5. Create a file named vars.tf with the following content
```tf

variable "region" {
  default = "us-west-1"
}

```

### 6. Create a file named vpc.tf with the following content

```tf
# Internet VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "main"
    }
}

# Subnets
resource "aws_subnet" "main-public-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"

    tags = {
        Name = "main-public-1"
    }
}

resource "aws_subnet" "main-public-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1b"
    tags = {
        Name = "main-public-2"
    }
}

resource "aws_subnet" "main-private-1" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.4.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-1a"

    tags = {
        Name = "main-private-1"
    }
}

resource "aws_subnet" "main-private-2" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.5.0/24"
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-1b"

    tags = {
        Name = "main-private-2"
    }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main.id}"
   tags = {
        Name = "main"
    }
}

# route tables
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags = {
        Name = "main-public-1"
    }
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

resource "aws_route_table_association" "main-public-2-a" {
    subnet_id = "${aws_subnet.main-public-2.id}"
    route_table_id = "${aws_route_table.main-public.id}"
}

```

### 7. Study the above vpc creation information and also the EBS definition

### 8. Apply the configuration
Run the following command:
```bash
> terraform apply
```
Assuming that this works correctly, AWS will create a new VM instance

### 9. Connect to the instance

```bash
ssh ubuntu@<public_dns>
```

Once connected look at ip networking information and disk block information using commands:

```bash
> ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc fq_codel state UP group default qlen 1000
    link/ether 06:9a:61:8a:9f:b7 brd ff:ff:ff:ff:ff:ff
    inet 10.0.1.171/24 brd 10.0.1.255 scope global dynamic eth0
       valid_lft 2660sec preferred_lft 2660sec
    inet6 fe80::49a:61ff:fe8a:9fb7/64 scope link
       valid_lft forever preferred_lft forever
```

#### Let's check that our new EBS volume is present on the instance

```bash

>  sudo parted --list
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvda: 8590MB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  8590MB  8589MB  primary  ext4         boot


Error: /dev/xvdh: unrecognised disk label
Model: Xen Virtual Block Device (xvd)
Disk /dev/xvdh: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: unknown
Disk Flags:

```

#### We can see that the disk exists, now let's create a filesystem on the raw device and mount it.

First create an ext4 filesystem on the device:
```bash
sudo mkfs.ext4 /dev/xvdh
```

Create a new mountpoint
```bash
sudo mkdir /mnt/extra
```

Mount the device new mountpoint
```bash
sudo mount /dev/xvdh /mnt/extra
```

Verify that the mount looks correct
```bash
df -h /mnt/extra/
```

You should see something similar to:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/xvdh        20G   45M   19G   1% /mnt/extra
```

### 15. Cleanup

```bash
> terraform destroy
```

