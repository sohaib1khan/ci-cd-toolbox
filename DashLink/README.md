This repository contains a Flask application that can be deployed using **Skaffold** in a **Kubernetes** environment. This guide will walk you through the process of setting up a Kubernetes namespace, creating necessary secrets, and deploying the application with Skaffold.

&nbsp;

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup](#setup)
  - [Step 1: Clone the Repository](#step-1-clone-the-repository)
  - [Step 2: Create a Namespace](#step-2-create-a-namespace)
  - [Step 3: Create a Docker Registry Secret](#step-3-create-a-docker-registry-secret)
  - [Step 4: Run the Application with Skaffold](#step-4-run-the-application-with-skaffold)
  - [Step 5: Verify Deployment](#step-5-verify-deployment)
- [Teardown](#teardown)

* * *

## Prerequisites

Before you begin, make sure you have the following:

- **Kubernetes Cluster**: You should have access to a Kubernetes cluster (local, cloud, or K3s).
- **kubectl**: CLI tool for interacting with Kubernetes clusters. Install kubectl.
- **Skaffold**: CLI tool to facilitate continuous development in Kubernetes environments. Install Skaffold.
- **Docker**: For building and pushing images to your Docker registry.
- **Docker Registry**: You will need a private Docker registry (e.g., Docker Hub, GitHub Packages, or self-hosted).
- **Configured Docker Authentication**: Ensure that Docker is authenticated with your private registry (`docker login`).

* * *

## Project Structure

Here’s an overview of the repository structure:

```
.
├── app.py                # Flask application code
├── bookmarks.json         # Persistent data for the app
├── k18s_run.sh            # Helper script for generating Dockerfile and launching skaffold
├── k8s
│   ├── k8s-deployment.yaml # Kubernetes Deployment manifest
│   └── k8s-service.yaml    # Kubernetes Service manifest
├── run_setup.sh           # Another Flask app runner script
├── skaffold.yaml          # Skaffold configuration file
└── templates
    └── index.html         # HTML template for the Flask app

```

&nbsp;

* * *

## Setup

### Step 1: Clone the Repository

First, clone the repository to your local machine:

```
git git@github.com:sohaib1khan/kubernetes_craft.git
cd Skaffold_Deployments/dashlink

```

### Step 2: Create a Namespace

To isolate the application, it is recommended to deploy the app in a dedicated namespace. You can create a namespace for your app using the following command:

```
kubectl create namespace dashlink

```

### Step 3: Create a Docker Registry Secret

If you're using a private Docker registry, Kubernetes needs the credentials to pull the image. Create a secret to store these credentials.

1.  Ensure that Docker is logged in to your registry:

```
docker login YOUR_REGISTRY_URL

```

&nbsp; 2. Create a Kubernetes secret using the credentials stored in your Docker config:

```
kubectl create secret generic regcred \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson \
  --namespace dashlink

```

This will create a secret named `regcred` in the `dashlink` namespace. The deployment will reference this secret to pull the Docker image.

### Step 4: Run the Application with Skaffold

Skaffold helps to build, push, and deploy your app to Kubernetes easily. Make sure Skaffold is installed before proceeding.

1.  Open the `skaffold.yaml` file and ensure that the image registry is correctly set:

```
build:
  artifacts:
  - image: registry.YOUR_REGISTRY_URL/dashlink  # Replace with your private registry

```

&nbsp;  2. Run Skaffold to deploy the app to Kubernetes:

```
skaffold dev
```

Skaffold will build the Docker image, push it to your registry, and then apply the Kubernetes manifests (`k8s-deployment.yaml` and `k8s-service.yaml`).

### Step 5: Verify Deployment

1.  **Check Pod Status**: Ensure the pod is running successfully:

```
kubectl get pods --namespace dashlink

```

&nbsp; 2. **Check Service**: Get the external IP of the service:

```
kubectl get svc --namespace dashlink
```

Example output:

```
NAME               TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)
dashlink-service   LoadBalancer   10.43.127.43   192.168.1.204   5021:30295/TCP

```

Access the app at `http://<EXTERNAL-IP>:5021`.

&nbsp; 3.  **Logs**: You can check the logs of the running pod to make sure the Flask app is running:

```
kubectl logs <pod-name> --namespace dashlink

```

&nbsp;

* * *

## Teardown

To remove the deployment and all related resources:

1.  Stop Skaffold:
    
    If you ran Skaffold in dev mode, stop it by pressing `Ctrl+C`.
    
2.  Delete the namespace and all its resources:
    

```
kubectl delete namespace dashlink

```

This will delete the application, the secret, and any other resources created in the `dashlink` namespace.