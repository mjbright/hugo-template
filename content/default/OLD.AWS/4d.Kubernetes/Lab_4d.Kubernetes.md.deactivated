---
title:  Lab 4d.Kubernetes
date:   1673287334
weight: 46
---
```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]






<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Background:

Here, we will investigate the use of another Provider - the Kubernetes Provider

You can find information about the Provider here: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

A shared cluster has already been created on the Bastion host.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 0. Install MicroK8S - if needed
### 1. Make a directory called ‘lab4d’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, namespace.tf



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4d.1 Verify that the Kubernetes cluster is accessible

Verify that you can use kubectl to access the cluster by using the **kubectl get nodes** command.

You should see output of the form:



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Installing Microk8s

If you do not already have a Kubernetes installation, a quick easy way to install Kubernetes on Ubuntu is to install microk8s

### Install Microk8s

```sudo snap install microk8s --classic --channel=1.26```

### Check that you have a running node

```sudo microk8s kubectl get no```

you should see output equivalent to this:
```
NAME   STATUS   ROLES    AGE     VERSION
tf     Ready    <none>   7m37s   v1.26.0
```

### Enable use of microk8s as your normal user

Join the microk8s group:

```sudo usermod -a -G microk8s student```

### Log out and log in again

You must perform this step to start a new shell with microk8s group membership


```bash
microk8s kubectl get nodes
```

    NAME   STATUS   ROLES    AGE   VERSION
    tf     Ready    <none>   10m   v1.26.0


### Create an alias for kubectl

To avoid having to use the microk8s command, copy the microk8s config, to ```~/.kube/config``` if that **file doesn't exist already !!**



```bash
# alias kubectl='microk8s kubectl'

mkdir -p ~/.kube

[ ! -f ~/.kube/config ] && microk8s config > ~/.kube/config
```




```bash
kubectl get nodes
```

    NAME   STATUS   ROLES    AGE   VERSION
    tf     Ready    <none>   27m   v1.26.0




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4d.2 Create some "kubernetes" resources



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.1. Create the "*namespace.tf* config file

To prevent conflicts on our cluster we will first create a namespace dedicated to you

Create the namespace.tf as below, replacing *student20* by **your student user name**:

Create a main..tf config file as below:


```bash
cat main.tf
```

    
    provider "kubernetes" {
      config_path    = "~/.kube/config"
      config_context = "microk8s"
    }
    
    variable "user" {
        description = "To prevent conflicts please put your student user as the default value"
        default = "student"
    }
    
    locals {
        namespace = "${var.user}-namespace"
    }
    
    resource "kubernetes_namespace" "example" {
      metadata {
        name = local.namespace
      }
    }


Note how we have created a *local* variable for the namespace taking into account the **user** value.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.2. Intialize and then apply this config

After applying this config you should see that your student's namespace has been generated, e.g.


```bash
kubectl get ns

```

    NAME                STATUS   AGE
    kube-system         Active   29m
    kube-public         Active   29m
    kube-node-lease     Active   29m
    default             Active   29m
    student-namespace   Active   3s




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.3. Create the "*deployment.tf* config file

We will now create a Kubernetes deployment.

Create the file *deployment.tf* as below, or modify as you wish - but do use the **local.namespace** which we declared earlier


```bash
cat deploy.tf 

```

    resource "kubernetes_deployment" "k8s-demo" {
      metadata {
        name = "terraform-k8s-demo"
        namespace = local.namespace
        labels = {
          test = "k8s-demo"
        }
      }
    
      spec {
        replicas = 3
    
        selector {
          match_labels = {
            test = "k8s-demo"
          }
        }
    
        template {
          metadata {
            labels = {
              test = "k8s-demo"
            }
          }
    
          spec {
            container {
              image = "mjbright/k8s-demo:1"
              name  = "k8s-demo"
    
              liveness_probe {
                http_get {
                  path = "/1"
                  port = 80
    
                  http_header {
                    name  = "X-Custom-Header"
                    value = "Ignored"
                  }
                }
    
                initial_delay_seconds = 3
                period_seconds        = 3
              }
            }
          }
        }
      }
    }




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.4. Apply this config

After applying this config you should see that your student's namespace has some resources in it


```bash
kubectl get -n student-namespace all
```

    NAME                                      READY   STATUS    RESTARTS   AGE
    pod/terraform-k8s-demo-5df66b7c98-d7xn4   1/1     Running   0          25s
    pod/terraform-k8s-demo-5df66b7c98-5wblp   1/1     Running   0          25s
    pod/terraform-k8s-demo-5df66b7c98-r82fg   1/1     Running   0          25s
    
    NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/terraform-k8s-demo   3/3     3            3           25s
    
    NAME                                            DESIRED   CURRENT   READY   AGE
    replicaset.apps/terraform-k8s-demo-5df66b7c98   3         3         3       25s


You have successfully created a namespace containing a deployment



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.3 Experiment

Now experiment with this configuration

Refer to https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs, select "*Resources*" in the left-hand menu to investigate supported Kubernetes resource types.

Experiment, for example:

1. Verify that you can curl to the Pods
2. Create a file *service.tf* and define a Service for your deployment
3. Verify that you can curl to the Service
4. Modify the container image and re-apply, observe the rolling upgrade
5. Experiment with other Kubernetes resources

### 4d.4 Cleanup


```bash
terraform destroy 
```

    kubernetes_namespace.example: Refreshing state... [id=student-namespace]
    kubernetes_deployment.k8s-demo: Refreshing state... [id=student-namespace/terraform-k8s-demo]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # kubernetes_deployment.k8s-demo will be destroyed
      - resource "kubernetes_deployment" "k8s-demo" {
          - id               = "student-namespace/terraform-k8s-demo" [90m-> [90mnull
          - wait_for_rollout = true [90m-> [90mnull
    
          - metadata {
              - annotations      = {} [90m-> [90mnull
              - generation       = 1 [90m-> [90mnull
              - labels           = {
                  - "test" = "k8s-demo"
                } [90m-> [90mnull
              - name             = "terraform-k8s-demo" [90m-> [90mnull
              - namespace        = "student-namespace" [90m-> [90mnull
              - resource_version = "2915" [90m-> [90mnull
              - uid              = "f4217ea3-16ee-47c8-a181-e71b15d369d0" [90m-> [90mnull
            }
    
          - spec {
              - min_ready_seconds         = 0 [90m-> [90mnull
              - paused                    = false [90m-> [90mnull
              - progress_deadline_seconds = 600 [90m-> [90mnull
              - replicas                  = "3" [90m-> [90mnull
              - revision_history_limit    = 10 [90m-> [90mnull
    
              - selector {
                  - match_labels = {
                      - "test" = "k8s-demo"
                    } [90m-> [90mnull
                }
    
              - strategy {
                  - type = "RollingUpdate" [90m-> [90mnull
    
                  - rolling_update {
                      - max_surge       = "25%" [90m-> [90mnull
                      - max_unavailable = "25%" [90m-> [90mnull
                    }
                }
    
              - template {
                  - metadata {
                      - annotations = {} [90m-> [90mnull
                      - generation  = 0 [90m-> [90mnull
                      - labels      = {
                          - "test" = "k8s-demo"
                        } [90m-> [90mnull
                    }
    
                  - spec {
                      - active_deadline_seconds          = 0 [90m-> [90mnull
                      - automount_service_account_token  = true [90m-> [90mnull
                      - dns_policy                       = "ClusterFirst" [90m-> [90mnull
                      - enable_service_links             = true [90m-> [90mnull
                      - host_ipc                         = false [90m-> [90mnull
                      - host_network                     = false [90m-> [90mnull
                      - host_pid                         = false [90m-> [90mnull
                      - node_selector                    = {} [90m-> [90mnull
                      - restart_policy                   = "Always" [90m-> [90mnull
                      - share_process_namespace          = false [90m-> [90mnull
                      - termination_grace_period_seconds = 30 [90m-> [90mnull
    
                      - container {
                          - args                       = [] [90m-> [90mnull
                          - command                    = [] [90m-> [90mnull
                          - image                      = "mjbright/k8s-demo:1" [90m-> [90mnull
                          - image_pull_policy          = "IfNotPresent" [90m-> [90mnull
                          - name                       = "k8s-demo" [90m-> [90mnull
                          - stdin                      = false [90m-> [90mnull
                          - stdin_once                 = false [90m-> [90mnull
                          - termination_message_path   = "/dev/termination-log" [90m-> [90mnull
                          - termination_message_policy = "File" [90m-> [90mnull
                          - tty                        = false [90m-> [90mnull
    
                          - liveness_probe {
                              - failure_threshold     = 3 [90m-> [90mnull
                              - initial_delay_seconds = 3 [90m-> [90mnull
                              - period_seconds        = 3 [90m-> [90mnull
                              - success_threshold     = 1 [90m-> [90mnull
                              - timeout_seconds       = 1 [90m-> [90mnull
    
                              - http_get {
                                  - path   = "/1" [90m-> [90mnull
                                  - port   = "80" [90m-> [90mnull
                                  - scheme = "HTTP" [90m-> [90mnull
    
                                  - http_header {
                                      - name  = "X-Custom-Header" [90m-> [90mnull
                                      - value = "Ignored" [90m-> [90mnull
                                    }
                                }
                            }
    
                          - resources {
                              - limits   = {} [90m-> [90mnull
                              - requests = {} [90m-> [90mnull
                            }
                        }
                    }
                }
            }
        }
    
      # kubernetes_namespace.example will be destroyed
      - resource "kubernetes_namespace" "example" {
          - id = "student-namespace" [90m-> [90mnull
    
          - metadata {
              - annotations      = {} [90m-> [90mnull
              - generation       = 0 [90m-> [90mnull
              - labels           = {} [90m-> [90mnull
              - name             = "student-namespace" [90m-> [90mnull
              - resource_version = "2662" [90m-> [90mnull
              - uid              = "26e4cf09-406d-4500-8c85-51ec041301d5" [90m-> [90mnull
            }
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    kubernetes_namespace.example: Destroying... [id=student-namespace]
    kubernetes_deployment.k8s-demo: Destroying... [id=student-namespace/terraform-k8s-demo]
    kubernetes_deployment.k8s-demo: Destruction complete after 0s
    kubernetes_namespace.example: Destruction complete after 6s
    
    Destroy complete! Resources: 2 destroyed.
    


To destroy the Pods

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of another Provider - Kubernetes

We then
1. Created a Namespace
2. Created a Deployment


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

Here, we will investigate the use of another Provider - the Kubernetes Provider

You can find information about the Provider here: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

A shared cluster has already been created on the Bastion host.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## Tasks:
### 0. Install MicroK8S - if needed
### 1. Make a directory called ‘lab4d’ underneath the labs directory.
### 2. Change into the directory.
### 3. Create the following files: main.tf, namespace.tf



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4d.1 Verify that the Kubernetes cluster is accessible

Verify that you can use kubectl to access the cluster by using the **kubectl get nodes** command.

You should see output of the form:



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Installing Microk8s

If you do not already have a Kubernetes installation, a quick easy way to install Kubernetes on Ubuntu is to install microk8s

### Install Microk8s

```sudo snap install microk8s --classic --channel=1.26```

### Check that you have a running node

```sudo microk8s kubectl get no```

you should see output equivalent to this:
```
NAME   STATUS   ROLES    AGE     VERSION
tf     Ready    <none>   7m37s   v1.26.0
```

### Enable use of microk8s as your normal user

Join the microk8s group:

```sudo usermod -a -G microk8s student```

### Log out and log in again

You must perform this step to start a new shell with microk8s group membership


```bash
microk8s kubectl get nodes
```

    NAME   STATUS   ROLES    AGE   VERSION
    tf     Ready    <none>   10m   v1.26.0


### Create an alias for kubectl

To avoid having to use the microk8s command, copy the microk8s config, to ```~/.kube/config``` if that **file doesn't exist already !!**



```bash
# alias kubectl='microk8s kubectl'

mkdir -p ~/.kube

[ ! -f ~/.kube/config ] && microk8s config > ~/.kube/config
```




```bash
kubectl get nodes
```

    NAME   STATUS   ROLES    AGE   VERSION
    tf     Ready    <none>   27m   v1.26.0




<img align="left" src="../images/ThinBlueBar.png" /><br/>

# 4d.2 Create some "kubernetes" resources



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.1. Create the "*namespace.tf* config file

To prevent conflicts on our cluster we will first create a namespace dedicated to you

Create the namespace.tf as below, replacing *student20* by **your student user name**:

Create a main..tf config file as below:


```bash
cat main.tf
```

    
    provider "kubernetes" {
      config_path    = "~/.kube/config"
      config_context = "microk8s"
    }
    
    variable "user" {
        description = "To prevent conflicts please put your student user as the default value"
        default = "student"
    }
    
    locals {
        namespace = "${var.user}-namespace"
    }
    
    resource "kubernetes_namespace" "example" {
      metadata {
        name = local.namespace
      }
    }


Note how we have created a *local* variable for the namespace taking into account the **user** value.



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.2. Intialize and then apply this config

After applying this config you should see that your student's namespace has been generated, e.g.


```bash
kubectl get ns

```

    NAME                STATUS   AGE
    kube-system         Active   29m
    kube-public         Active   29m
    kube-node-lease     Active   29m
    default             Active   29m
    student-namespace   Active   3s




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.3. Create the "*deployment.tf* config file

We will now create a Kubernetes deployment.

Create the file *deployment.tf* as below, or modify as you wish - but do use the **local.namespace** which we declared earlier


```bash
cat deploy.tf 

```

    resource "kubernetes_deployment" "k8s-demo" {
      metadata {
        name = "terraform-k8s-demo"
        namespace = local.namespace
        labels = {
          test = "k8s-demo"
        }
      }
    
      spec {
        replicas = 3
    
        selector {
          match_labels = {
            test = "k8s-demo"
          }
        }
    
        template {
          metadata {
            labels = {
              test = "k8s-demo"
            }
          }
    
          spec {
            container {
              image = "mjbright/k8s-demo:1"
              name  = "k8s-demo"
    
              liveness_probe {
                http_get {
                  path = "/1"
                  port = 80
    
                  http_header {
                    name  = "X-Custom-Header"
                    value = "Ignored"
                  }
                }
    
                initial_delay_seconds = 3
                period_seconds        = 3
              }
            }
          }
        }
      }
    }




<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.2.4. Apply this config

After applying this config you should see that your student's namespace has some resources in it


```bash
kubectl get -n student-namespace all
```

    NAME                                      READY   STATUS    RESTARTS   AGE
    pod/terraform-k8s-demo-5df66b7c98-d7xn4   1/1     Running   0          25s
    pod/terraform-k8s-demo-5df66b7c98-5wblp   1/1     Running   0          25s
    pod/terraform-k8s-demo-5df66b7c98-r82fg   1/1     Running   0          25s
    
    NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/terraform-k8s-demo   3/3     3            3           25s
    
    NAME                                            DESIRED   CURRENT   READY   AGE
    replicaset.apps/terraform-k8s-demo-5df66b7c98   3         3         3       25s


You have successfully created a namespace containing a deployment



<img align="left" src="../images/ThinBlueBar.png" width="400" /><br/>

## 4d.3 Experiment

Now experiment with this configuration

Refer to https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs, select "*Resources*" in the left-hand menu to investigate supported Kubernetes resource types.

Experiment, for example:

1. Verify that you can curl to the Pods
2. Create a file *service.tf* and define a Service for your deployment
3. Verify that you can curl to the Service
4. Modify the container image and re-apply, observe the rolling upgrade
5. Experiment with other Kubernetes resources

### 4d.4 Cleanup


```bash
terraform destroy 
```

    kubernetes_namespace.example: Refreshing state... [id=student-namespace]
    kubernetes_deployment.k8s-demo: Refreshing state... [id=student-namespace/terraform-k8s-demo]
    
    Terraform used the selected providers to generate the following execution plan.
    Resource actions are indicated with the following symbols:
      - destroy
    
    Terraform will perform the following actions:
    
      # kubernetes_deployment.k8s-demo will be destroyed
      - resource "kubernetes_deployment" "k8s-demo" {
          - id               = "student-namespace/terraform-k8s-demo" [90m-> [90mnull
          - wait_for_rollout = true [90m-> [90mnull
    
          - metadata {
              - annotations      = {} [90m-> [90mnull
              - generation       = 1 [90m-> [90mnull
              - labels           = {
                  - "test" = "k8s-demo"
                } [90m-> [90mnull
              - name             = "terraform-k8s-demo" [90m-> [90mnull
              - namespace        = "student-namespace" [90m-> [90mnull
              - resource_version = "2915" [90m-> [90mnull
              - uid              = "f4217ea3-16ee-47c8-a181-e71b15d369d0" [90m-> [90mnull
            }
    
          - spec {
              - min_ready_seconds         = 0 [90m-> [90mnull
              - paused                    = false [90m-> [90mnull
              - progress_deadline_seconds = 600 [90m-> [90mnull
              - replicas                  = "3" [90m-> [90mnull
              - revision_history_limit    = 10 [90m-> [90mnull
    
              - selector {
                  - match_labels = {
                      - "test" = "k8s-demo"
                    } [90m-> [90mnull
                }
    
              - strategy {
                  - type = "RollingUpdate" [90m-> [90mnull
    
                  - rolling_update {
                      - max_surge       = "25%" [90m-> [90mnull
                      - max_unavailable = "25%" [90m-> [90mnull
                    }
                }
    
              - template {
                  - metadata {
                      - annotations = {} [90m-> [90mnull
                      - generation  = 0 [90m-> [90mnull
                      - labels      = {
                          - "test" = "k8s-demo"
                        } [90m-> [90mnull
                    }
    
                  - spec {
                      - active_deadline_seconds          = 0 [90m-> [90mnull
                      - automount_service_account_token  = true [90m-> [90mnull
                      - dns_policy                       = "ClusterFirst" [90m-> [90mnull
                      - enable_service_links             = true [90m-> [90mnull
                      - host_ipc                         = false [90m-> [90mnull
                      - host_network                     = false [90m-> [90mnull
                      - host_pid                         = false [90m-> [90mnull
                      - node_selector                    = {} [90m-> [90mnull
                      - restart_policy                   = "Always" [90m-> [90mnull
                      - share_process_namespace          = false [90m-> [90mnull
                      - termination_grace_period_seconds = 30 [90m-> [90mnull
    
                      - container {
                          - args                       = [] [90m-> [90mnull
                          - command                    = [] [90m-> [90mnull
                          - image                      = "mjbright/k8s-demo:1" [90m-> [90mnull
                          - image_pull_policy          = "IfNotPresent" [90m-> [90mnull
                          - name                       = "k8s-demo" [90m-> [90mnull
                          - stdin                      = false [90m-> [90mnull
                          - stdin_once                 = false [90m-> [90mnull
                          - termination_message_path   = "/dev/termination-log" [90m-> [90mnull
                          - termination_message_policy = "File" [90m-> [90mnull
                          - tty                        = false [90m-> [90mnull
    
                          - liveness_probe {
                              - failure_threshold     = 3 [90m-> [90mnull
                              - initial_delay_seconds = 3 [90m-> [90mnull
                              - period_seconds        = 3 [90m-> [90mnull
                              - success_threshold     = 1 [90m-> [90mnull
                              - timeout_seconds       = 1 [90m-> [90mnull
    
                              - http_get {
                                  - path   = "/1" [90m-> [90mnull
                                  - port   = "80" [90m-> [90mnull
                                  - scheme = "HTTP" [90m-> [90mnull
    
                                  - http_header {
                                      - name  = "X-Custom-Header" [90m-> [90mnull
                                      - value = "Ignored" [90m-> [90mnull
                                    }
                                }
                            }
    
                          - resources {
                              - limits   = {} [90m-> [90mnull
                              - requests = {} [90m-> [90mnull
                            }
                        }
                    }
                }
            }
        }
    
      # kubernetes_namespace.example will be destroyed
      - resource "kubernetes_namespace" "example" {
          - id = "student-namespace" [90m-> [90mnull
    
          - metadata {
              - annotations      = {} [90m-> [90mnull
              - generation       = 0 [90m-> [90mnull
              - labels           = {} [90m-> [90mnull
              - name             = "student-namespace" [90m-> [90mnull
              - resource_version = "2662" [90m-> [90mnull
              - uid              = "26e4cf09-406d-4500-8c85-51ec041301d5" [90m-> [90mnull
            }
        }
    
    Plan: 0 to add, 0 to change, 2 to destroy.
    kubernetes_namespace.example: Destroying... [id=student-namespace]
    kubernetes_deployment.k8s-demo: Destroying... [id=student-namespace/terraform-k8s-demo]
    kubernetes_deployment.k8s-demo: Destruction complete after 0s
    kubernetes_namespace.example: Destruction complete after 6s
    
    Destroy complete! Resources: 2 destroyed.
    


To destroy the Pods

<hr/>



<img align="left" src="../images/ThinBlueBar.png" /><br/>

# Summary

In this Exercise we looked at the use of another Provider - Kubernetes

We then
1. Created a Namespace
2. Created a Deployment


```bash

```

    2023-Jan-09:[TF-1.3.7] Lab updated on node tf[terraform 1.3.7]




<hr/>
<!-- ![](../../../static/images/LOGO_v2_CROPPED.jpg) -->
<img src="../images/LOGO_v2_CROPPED.jpg" width="200" />
