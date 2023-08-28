---
title:  Lab 4c.Docker
date:   1673285531
weight: 44
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we will investigate the use of another Provider - the Docker Provider - which will allow us to quickly deploy configurations

You can find information about the Provider here: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4c’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, versions.tf



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4c.1 Create a "docker_container" resource



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.1.1. Configure Terraform and Docker Providers

We will first define the version of Terraform and the Docker Provider

The versions.tf file should contain:


```bash

```

    
    terraform {
      required_providers {
        docker = {
          #source = "terraform-providers/docker"
          source = "kreuzwerker/docker"
        }
      }
      required_version = ">= 1.0"
    }  
    
    provider "docker" {
      host = "unix:///var/run/docker.sock"
    }
    




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.1.2. Configure the Docker container resource

We will create a single running Docker container using a test Docker image *mjbright/docker-demo:1*

The Docker container will listen on Port 80 (internally), we will expose this at Port 8080

Note: We define a Volume, but we will not actually use this in the application

The main.tf file should contain:



```bash

```

    variable "user" {
        description = "A unique user-name to be used as part of container names"
    }
    
    variable "port0" {
        description = "A unique starting port to be used to expose our containers"
    }
    
    resource "docker_container" "docker_app" {
      image = "mjbright/docker-demo:1"
    
      name  = "${var.user}_docker_app"
      restart = "always"
    
      volumes {
        container_path  = "/tmp"
        # replace the host_path with full path for your project directory starting from root directory /
        host_path = "/tmp/demo"
        read_only = false
      }
    
      ports {
        internal = 80
        external = var.port0
      }
      
      # not working? tags = { LabName = "4c.Docker" }
    }    




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4c.2 Apply the config



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.1 Check for any running containers

First check for any running containers using ```docker ps```

There may be some, hopefully they won't be listening on the Port you intend to use (TF_VAR_port0)



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.2 Apply your config

Apply the config and you should notice that the Docker container is created very quickly



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.3 Check for the running container

Check for your container using ```docker ps```

If you are student20 for example you should see a container called student20_docker_app exposed on port 8020:


```bash
docker ps
```

    CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                  NAMES
    1cfb2ba43d2a   mjbright/docker-demo:1   "/app/demo-binary -l…"   11 seconds ago   Up 10 seconds   0.0.0.0:8200->80/tcp   student20_docker_app




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.4 Curl the container


```bash
curl 127.0.0.1:8200
```

    [1;34m
                                                    .---------.                                          
                                                   .///++++/:.                                          
                                                   .///+++//:.                                          
                                                   .///+++//:.                                          
                                 ``````````````````.:///////:.                       `                  
                                 .-///////:://+++//::///////-.                      .--.                
                                 .:::///:::///+++///:::///:::.                     .:ss+-`              
                                 .:::///:::///+++///:::///:::.                    `.ossss:.             
                                 .:///////:/+++oo++/:///////:.                    .-ssssss:.            
                        .-:::::::--///////--:::::::--///////--:::::::-.           `-sssssso.........``  
                        .::////:::://+++///:::///:::///+++//:/::////::.           `.+ssssss/++ooooo+/:.`
                        .::////:::://+++///:::///:::///+++//:/::////::.            `.+sssooooooooooo/-` 
                        .::////:::://+++///:::///:::///+++//:/::////::.           ``.:osoooooooo+/:-.`  
                ````````.-:::::::--///////--:::::::-:///////--:::::::-.``````...-:/+ssoo+:-----..``     
                .-+++oooooooooooooooooooooooooooooooooooooooooooooooooooooooosssssssoooo-.              
          `     .-ooossssssssssssssssssssssss+ssssssssssssssssossssssssssssssssssoooooo:.        `      
        ``...```.-+++++/:--/+oosssssssoo++/:-.-:+oosssssso+/:..-:/+oossssssssoo+:--://-.`   ```...`     
     ````````````.-:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-..```````````````  
                 .-////++++++++++++++++++++++++++++++++++++++++++++++++++//////////:.`                  
                 `.:////++++++++++++++++oss+++++++++++++++++++++++++++///////////:-.                    
                  `.:////++++++++++++++os.+h+++++++++++++++++++++++/////////////-.`                     
                   `.://///++++++++++//+soos+++++++++++++++++++///////////////-.`                       
                    `.--------:::://+o/+++++++++++++++++++/////////////////:-.`                         
                      `-sdmmmmmmmNNNNNmo+++++++++++/////////////////////:-.``                           
                        `-+hmmmmmmmmmmmms///////////////////////////::-.``                              
                          ``-+ydmmmmmmmmmds////////////////////::--.``                                  
                             ``.-/oshdmmmmmmho+////////::::--..```                                      
                                  ````..-:::///---.....````                                             
    
    pod [0;33m1cfb2ba43d2a@172.17.0.2[0;0m [0;34mimage[0;0m[mjbright/docker-demo:1] Request from 172.17.0.1:45068


### 4c.3 Create 6 containers

First destroy the previous container using Terraform

Then modify your main.tf to now create 6 containers running image

- mjbright/docker-demo:1
- mjbright/docker-demo:2
- etc ...

**Note**: They will each need to have a unique name and to expose on a unique external Port

**Note**: If you remove the ```external``` line in the ```port``` block, Docker will automatically assign a non-conflicting port to each container.

### 4c.4 Cleanup


```bash
 terraform destroy

```

    docker_container.docker_app: Refreshing state... [id=1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # docker_container.docker_app will be destroyed
      - resource "docker_container" "docker_app" {
          - attach                                      = false [90m-> [90mnull
          - command                                     = [
              - "/app/demo-binary",
              - "-l",
              - "80",
              - "-L",
              - "0",
              - "-R",
              - "0",
            ] [90m-> [90mnull
          - container_read_refresh_timeout_milliseconds = 15000 [90m-> [90mnull
          - cpu_shares                                  = 0 [90m-> [90mnull
          - dns                                         = [] [90m-> [90mnull
          - dns_opts                                    = [] [90m-> [90mnull
          - dns_search                                  = [] [90m-> [90mnull
          - entrypoint                                  = [] [90m-> [90mnull
          - env                                         = [] [90m-> [90mnull
          - gateway                                     = "172.17.0.1" [90m-> [90mnull
          - group_add                                   = [] [90m-> [90mnull
          - hostname                                    = "1cfb2ba43d2a" [90m-> [90mnull
          - id                                          = "1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452" [90m-> [90mnull
          - image                                       = "sha256:c6bb37f7e86b749a53e59ca0fa246b2dc4fe1c2efd9ee7429a1fa85c7bd3685e" [90m-> [90mnull
          - init                                        = false [90m-> [90mnull
          - ip_address                                  = "172.17.0.2" [90m-> [90mnull
          - ip_prefix_length                            = 16 [90m-> [90mnull
          - ipc_mode                                    = "private" [90m-> [90mnull
          - links                                       = [] [90m-> [90mnull
          - log_driver                                  = "json-file" [90m-> [90mnull
          - log_opts                                    = {} [90m-> [90mnull
          - logs                                        = false [90m-> [90mnull
          - max_retry_count                             = 0 [90m-> [90mnull
          - memory                                      = 0 [90m-> [90mnull
          - memory_swap                                 = 0 [90m-> [90mnull
          - must_run                                    = true [90m-> [90mnull
          - name                                        = "student20_docker_app" [90m-> [90mnull
          - network_data                                = [
              - {
                  - gateway                   = "172.17.0.1"
                  - global_ipv6_address       = ""
                  - global_ipv6_prefix_length = 0
                  - ip_address                = "172.17.0.2"
                  - ip_prefix_length          = 16
                  - ipv6_gateway              = ""
                  - network_name              = "bridge"
                },
            ] [90m-> [90mnull
          - network_mode                                = "default" [90m-> [90mnull
          - privileged                                  = false [90m-> [90mnull
          - publish_all_ports                           = false [90m-> [90mnull
          - read_only                                   = false [90m-> [90mnull
          - remove_volumes                              = true [90m-> [90mnull
          - restart                                     = "always" [90m-> [90mnull
          - rm                                          = false [90m-> [90mnull
          - runtime                                     = "runc" [90m-> [90mnull
          - security_opts                               = [] [90m-> [90mnull
          - shm_size                                    = 64 [90m-> [90mnull
          - start                                       = true [90m-> [90mnull
          - stdin_open                                  = false [90m-> [90mnull
          - stop_timeout                                = 0 [90m-> [90mnull
          - storage_opts                                = {} [90m-> [90mnull
          - sysctls                                     = {} [90m-> [90mnull
          - tmpfs                                       = {} [90m-> [90mnull
          - tty                                         = false [90m-> [90mnull
          - wait                                        = false [90m-> [90mnull
          - wait_timeout                                = 60 [90m-> [90mnull
          - working_dir                                 = "/app" [90m-> [90mnull
    
          - ports {
              - external = 8200 [90m-> [90mnull
              - internal = 80 [90m-> [90mnull
              - ip       = "0.0.0.0" [90m-> [90mnull
              - protocol = "tcp" [90m-> [90mnull
            }
    
          - volumes {
              - container_path = "/tmp" [90m-> [90mnull
              - host_path      = "/tmp/demo" [90m-> [90mnull
              - read_only      = false [90m-> [90mnull
            }
        }
    
    Plan: 0 to add, 0 to change, 1 to destroy.
    docker_container.docker_app: Destroying... [id=1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452]
    docker_container.docker_app: Destruction complete after 1s
    
    Destroy complete! Resources: 1 destroyed.
    


To destroy the containers

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of another Provider - Docker

We then
1. Created a single Docker container exposing it's web server on port 8080
2. Created multiple Docker containers exposing their web servers on port 8080, 8081, etc ...

**Note**: The Docker Provider is very quick as it acts locally - this can be useful to able to test out Terraform concepts/syntax without the delays and costs of using a distant Cloud Provider.


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]




<hr/>
<!-- ![](/images/LOGO_v2_CROPPED.jpg) -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we will investigate the use of another Provider - the Docker Provider - which will allow us to quickly deploy configurations

You can find information about the Provider here: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 1. Make a directory called ‘lab4c’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, versions.tf



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4c.1 Create a "docker_container" resource



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.1.1. Configure Terraform and Docker Providers

We will first define the version of Terraform and the Docker Provider

The versions.tf file should contain:


```bash

```

    
    terraform {
      required_providers {
        docker = {
          #source = "terraform-providers/docker"
          source = "kreuzwerker/docker"
        }
      }
      required_version = ">= 1.0"
    }  
    
    provider "docker" {
      host = "unix:///var/run/docker.sock"
    }
    




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.1.2. Configure the Docker container resource

We will create a single running Docker container using a test Docker image *mjbright/docker-demo:1*

The Docker container will listen on Port 80 (internally), we will expose this at Port 8080

Note: We define a Volume, but we will not actually use this in the application

The main.tf file should contain:



```bash

```

    variable "user" {
        description = "A unique user-name to be used as part of container names"
    }
    
    variable "port0" {
        description = "A unique starting port to be used to expose our containers"
    }
    
    resource "docker_container" "docker_app" {
      image = "mjbright/docker-demo:1"
    
      name  = "${var.user}_docker_app"
      restart = "always"
    
      volumes {
        container_path  = "/tmp"
        # replace the host_path with full path for your project directory starting from root directory /
        host_path = "/tmp/demo"
        read_only = false
      }
    
      ports {
        internal = 80
        external = var.port0
      }
      
      # not working? tags = { LabName = "4c.Docker" }
    }    




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4c.2 Apply the config



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.1 Check for any running containers

First check for any running containers using ```docker ps```

There may be some, hopefully they won't be listening on the Port you intend to use (TF_VAR_port0)



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.2 Apply your config

Apply the config and you should notice that the Docker container is created very quickly



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.3 Check for the running container

Check for your container using ```docker ps```

If you are student20 for example you should see a container called student20_docker_app exposed on port 8020:


```bash
docker ps
```

    CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                  NAMES
    1cfb2ba43d2a   mjbright/docker-demo:1   "/app/demo-binary -l…"   11 seconds ago   Up 10 seconds   0.0.0.0:8200->80/tcp   student20_docker_app




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4c.2.4 Curl the container


```bash
curl 127.0.0.1:8200
```

    [1;34m
                                                    .---------.                                          
                                                   .///++++/:.                                          
                                                   .///+++//:.                                          
                                                   .///+++//:.                                          
                                 ``````````````````.:///////:.                       `                  
                                 .-///////:://+++//::///////-.                      .--.                
                                 .:::///:::///+++///:::///:::.                     .:ss+-`              
                                 .:::///:::///+++///:::///:::.                    `.ossss:.             
                                 .:///////:/+++oo++/:///////:.                    .-ssssss:.            
                        .-:::::::--///////--:::::::--///////--:::::::-.           `-sssssso.........``  
                        .::////:::://+++///:::///:::///+++//:/::////::.           `.+ssssss/++ooooo+/:.`
                        .::////:::://+++///:::///:::///+++//:/::////::.            `.+sssooooooooooo/-` 
                        .::////:::://+++///:::///:::///+++//:/::////::.           ``.:osoooooooo+/:-.`  
                ````````.-:::::::--///////--:::::::-:///////--:::::::-.``````...-:/+ssoo+:-----..``     
                .-+++oooooooooooooooooooooooooooooooooooooooooooooooooooooooosssssssoooo-.              
          `     .-ooossssssssssssssssssssssss+ssssssssssssssssossssssssssssssssssoooooo:.        `      
        ``...```.-+++++/:--/+oosssssssoo++/:-.-:+oosssssso+/:..-:/+oossssssssoo+:--://-.`   ```...`     
     ````````````.-:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::-..```````````````  
                 .-////++++++++++++++++++++++++++++++++++++++++++++++++++//////////:.`                  
                 `.:////++++++++++++++++oss+++++++++++++++++++++++++++///////////:-.                    
                  `.:////++++++++++++++os.+h+++++++++++++++++++++++/////////////-.`                     
                   `.://///++++++++++//+soos+++++++++++++++++++///////////////-.`                       
                    `.--------:::://+o/+++++++++++++++++++/////////////////:-.`                         
                      `-sdmmmmmmmNNNNNmo+++++++++++/////////////////////:-.``                           
                        `-+hmmmmmmmmmmmms///////////////////////////::-.``                              
                          ``-+ydmmmmmmmmmds////////////////////::--.``                                  
                             ``.-/oshdmmmmmmho+////////::::--..```                                      
                                  ````..-:::///---.....````                                             
    
    pod [0;33m1cfb2ba43d2a@172.17.0.2[0;0m [0;34mimage[0;0m[mjbright/docker-demo:1] Request from 172.17.0.1:45068


### 4c.3 Create 6 containers

First destroy the previous container using Terraform

Then modify your main.tf to now create 6 containers running image

- mjbright/docker-demo:1
- mjbright/docker-demo:2
- etc ...

**Note**: They will each need to have a unique name and to expose on a unique external Port

**Note**: If you remove the ```external``` line in the ```port``` block, Docker will automatically assign a non-conflicting port to each container.

### 4c.4 Cleanup


```bash
 terraform destroy

```

    docker_container.docker_app: Refreshing state... [id=1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # docker_container.docker_app will be destroyed
      - resource "docker_container" "docker_app" {
          - attach                                      = false [90m-> [90mnull
          - command                                     = [
              - "/app/demo-binary",
              - "-l",
              - "80",
              - "-L",
              - "0",
              - "-R",
              - "0",
            ] [90m-> [90mnull
          - container_read_refresh_timeout_milliseconds = 15000 [90m-> [90mnull
          - cpu_shares                                  = 0 [90m-> [90mnull
          - dns                                         = [] [90m-> [90mnull
          - dns_opts                                    = [] [90m-> [90mnull
          - dns_search                                  = [] [90m-> [90mnull
          - entrypoint                                  = [] [90m-> [90mnull
          - env                                         = [] [90m-> [90mnull
          - gateway                                     = "172.17.0.1" [90m-> [90mnull
          - group_add                                   = [] [90m-> [90mnull
          - hostname                                    = "1cfb2ba43d2a" [90m-> [90mnull
          - id                                          = "1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452" [90m-> [90mnull
          - image                                       = "sha256:c6bb37f7e86b749a53e59ca0fa246b2dc4fe1c2efd9ee7429a1fa85c7bd3685e" [90m-> [90mnull
          - init                                        = false [90m-> [90mnull
          - ip_address                                  = "172.17.0.2" [90m-> [90mnull
          - ip_prefix_length                            = 16 [90m-> [90mnull
          - ipc_mode                                    = "private" [90m-> [90mnull
          - links                                       = [] [90m-> [90mnull
          - log_driver                                  = "json-file" [90m-> [90mnull
          - log_opts                                    = {} [90m-> [90mnull
          - logs                                        = false [90m-> [90mnull
          - max_retry_count                             = 0 [90m-> [90mnull
          - memory                                      = 0 [90m-> [90mnull
          - memory_swap                                 = 0 [90m-> [90mnull
          - must_run                                    = true [90m-> [90mnull
          - name                                        = "student20_docker_app" [90m-> [90mnull
          - network_data                                = [
              - {
                  - gateway                   = "172.17.0.1"
                  - global_ipv6_address       = ""
                  - global_ipv6_prefix_length = 0
                  - ip_address                = "172.17.0.2"
                  - ip_prefix_length          = 16
                  - ipv6_gateway              = ""
                  - network_name              = "bridge"
                },
            ] [90m-> [90mnull
          - network_mode                                = "default" [90m-> [90mnull
          - privileged                                  = false [90m-> [90mnull
          - publish_all_ports                           = false [90m-> [90mnull
          - read_only                                   = false [90m-> [90mnull
          - remove_volumes                              = true [90m-> [90mnull
          - restart                                     = "always" [90m-> [90mnull
          - rm                                          = false [90m-> [90mnull
          - runtime                                     = "runc" [90m-> [90mnull
          - security_opts                               = [] [90m-> [90mnull
          - shm_size                                    = 64 [90m-> [90mnull
          - start                                       = true [90m-> [90mnull
          - stdin_open                                  = false [90m-> [90mnull
          - stop_timeout                                = 0 [90m-> [90mnull
          - storage_opts                                = {} [90m-> [90mnull
          - sysctls                                     = {} [90m-> [90mnull
          - tmpfs                                       = {} [90m-> [90mnull
          - tty                                         = false [90m-> [90mnull
          - wait                                        = false [90m-> [90mnull
          - wait_timeout                                = 60 [90m-> [90mnull
          - working_dir                                 = "/app" [90m-> [90mnull
    
          - ports {
              - external = 8200 [90m-> [90mnull
              - internal = 80 [90m-> [90mnull
              - ip       = "0.0.0.0" [90m-> [90mnull
              - protocol = "tcp" [90m-> [90mnull
            }
    
          - volumes {
              - container_path = "/tmp" [90m-> [90mnull
              - host_path      = "/tmp/demo" [90m-> [90mnull
              - read_only      = false [90m-> [90mnull
            }
        }
    
    Plan: 0 to add, 0 to change, 1 to destroy.
    docker_container.docker_app: Destroying... [id=1cfb2ba43d2a5ca4994608535f9a6a5904befc7ef74fc7be209a3cae04ea9452]
    docker_container.docker_app: Destruction complete after 1s
    
    Destroy complete! Resources: 1 destroyed.
    


To destroy the containers

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of another Provider - Docker

We then
1. Created a single Docker container exposing it's web server on port 8080
2. Created multiple Docker containers exposing their web servers on port 8080, 8081, etc ...

**Note**: The Docker Provider is very quick as it acts locally - this can be useful to able to test out Terraform concepts/syntax without the delays and costs of using a distant Cloud Provider.


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]




<hr/>
<!-- ![](../../../static/images/LOGO_v2_CROPPED.jpg) -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />
