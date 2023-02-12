# Local Development

CaraML chart by default deploys turing on a local Minikube cluster. Use this guide to generate the prerequisites for the same.

If you already have existing development cluster, You can add the relevant configs for imageBuilder under turing values to install and use. Make sure you have the relevant cluster credentials uploaded to your vault.

## Provision Minikube cluster

First, you need to have Minikube installed on your machine. To install it, please follow this [documentation](https://minikube.sigs.k8s.io/docs/start/).

Next, create a new Minikube cluster with Kubernetes v1.16.15:

```bash
export CLUSTER_NAME=dev
minikube start --cpus=4 --memory=8192 --kubernetes-version=v1.16.15 --driver=virtualbox
```

Lastly, we need to enable Minikube's LoadBalancer services by running `minikube tunnel` in another terminal.
If using a Kind cluster, Use `./scripts/install_metallib.sh` to install the prerequisite balancers before you install CaraML

## Generate Cluster Credentials

Vault is needed to store the model cluster credential where models will be deployed. For local development, we will use the same Minikube cluster as model cluster. In production, you may have multiple model clusters. You can use the scripts added in the CaraML charts repo (`./scripts/generate-cluster-creds.sh`) to generate the cluster credentials file in to turing files, So that the chart will upload it to your local vault when you install CaraML.

```bash
> scripts/generate-cluster-creds.sh minikube dev
```

This will generate a cluster-credentials.json file under `charts/turing/files` directory. That file will look like:

```json
{
  "name": "dev", # cluster name
  "master_ip": "https://kubernetes.default.svc:443",
  "certs": "",
  "client_certificate": "",
  "client_key": ""
}
```

## Install Turing

```bash

helm repo add caraml https://caraml-dev.github.io/helm-charts/

helm install turing caraml/turing \
  --set turing.ui.oauthClientID=${OAUTH_CLIENT_ID} \
  --timeout=5m \
  --wait
```

### Check Turing installation

```bash
kubectl get po
NAME                             READY   STATUS    RESTARTS   AGE
turing-64c9c75dfc-djs4t          1/1     Running   0          12m
turing-postgresql-0              1/1     Running   0          12m
merlin-64c9c75dfc-djs4t          1/1     Running   0          12m
merlin-mlflow-5c7dd6d9df-g2s6v   1/1     Running   0          12m
merlin-postgresql-0              1/1     Running   0          12m
mlp-6877d8567-msqg9              1/1     Running   0          15m
mlp-postgresql-0                 1/1     Running   0          15m
```

Once everything is Running, you can open Turing in <http://turing.mlp.${INGRESS_HOST}.nip.io/turing>. From here, you can run Jupyter notebook examples by setting `turing.set_url("turing.mlp.${INGRESS_HOST}.nip.io")`.
