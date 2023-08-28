---
title: 'Lab 8. Setting up web servers with Terraform'
date: 2019-02-11T19:27:37+10:00
weight: 100
---


## Background:

Here, we learn how to create and provision some simple web servers.

This code deploys multiple web servers in AWS, each with a different Name tag. Each web server always returns "Hello, World" on port 8080.

## Tasks:

### 1. Make a directory called ‘lab8’ underneath the labs directory.

### 2. Change into the directory.

Create the following files: main.tf, vars.tf

In the main.tf specify your provider as aws, then add the following lines:
```tf
resource "aws_instance" "web_server" {
  count = length(var.names)
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]

  # To keep this example simple, we run a web server as a User Data script. In real-world usage, you would typically
  # install the web server and its dependencies in the AMI.
  user_data = <<-EOF
              #!/bin/bash
              echo ${var.server_text} > /tmp/index.html
              cd /tmp/
              nohup busybox httpd -f -p ${var.http_port} &
              EOF

  tags = {
    Name = element(var.names, count.index)
  }
}

```

Then add a Provider data source to get possible images:
```tf
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

```

Then add a security group to control Ingress/Egress traffic
```tf
resource "aws_security_group" "web_server" {
  name_prefix = "exercise-03-example"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.web_server.id

  # To keep this example simple, we allow SSH requests from any IP. In real-world usage, you should lock this down
  # to just the IPs of trusted servers (e.g., your office IPs).
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.web_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

```

#### Create a vars.tf file

- Create a vars.tf file to provide the following variables:

  * "aws_region"

  * "names": a list containing ["instance1", "instance2", "instance3"]

  * "key_name": can be empty string

  * "http_port": set to 8080

  * "server_text": the text to be sent back by your web server

#### Create an outputs.tf file

- Create a outputs.tf file to display public_ip, public_dns and private_ips

**Note**: You will need to output separately a list of each (list of public_ip,  ... list of private_ip)

### 3. Change to the top level lab directory.

### 4. The configuration when visualized should look like

<div>
    <object data="graph.svg" type="image/svg+xml">
    </object>
</div>



### 5. Initialize preview and apply the configuration

```bash
> terraform init
> terraform plan
> terraform apply`
```

### 6. Test your web servers

When you perform the apply you should see the public ip addresses of your servers.

Now check that you can curl to the port 8080, if that's the value you specified, on those 3 ip addresses

**Note**: You may need to wait a minute after the VMs have been created before the web servers will respond.

### 7. Implement a local-exec Provisioner

Now add a local-exec provisioner script into your main.tf file to output the public_ip and public_dns variables to a file "*./hosts.txt*"

**Note**: You can obtain the public_ip within the resource using ${self.public_ip}

**Note**: Provisioners are only executed at creation time so you will need to destroy, apply your config for this change to be made

Refer to https://sdorsett.github.io/post/2018-12-26-using-local-exec-and-remote-exec-provisioners-with-terraform/

### 8. Implement file and remote-exec Provisioners

Now add file and remote-exec provisioners into your main.tf file to modify the server text which has been written to /tmp/index.html

**Note**: Provisioners are only executed at creation time so you will need to destroy, apply your config for this change to be made

When you change this file, the curl response will immmediately take into account the change.

Refer to https://sdorsett.github.io/post/2018-12-26-using-local-exec-and-remote-exec-provisioners-with-terraform/

**Note**: for testing purposes you can connect to your VM, as ubuntu@public_ip, but you will first have to set the keypair value to "*terraform-course-keypair*" in vars.tf - reapplying this will destroy and recreate the VM.

```sh
ssh -i ~/.ssh/vms.pem ubuntu@your-public-ip
```

### 9. Cleanup
```bash
> terraform destroy
```
To destroy the formerly created AWS vpc, and all subnets.
```



