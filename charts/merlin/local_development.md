# Local Development

CaraML chart by default deploys merlin on a local Minikube cluster. Use this guide to generate the prerequisites for the same.

If you already have existing development cluster, You can add the relevant configs for imageBuilder under merlin values to install and use. Make sure you have the relevant cluster credentials uploaded to your vault.

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

Vault is needed to store the model cluster credential where models will be deployed. For local development, we will use the same Minikube cluster as model cluster. In production, you may have multiple model clusters. You can use the scripts added in the CaraML charts repo (`caraml/scripts/generate-cluster-creds.sh`) to generate the cluster credentials file in to merlin files, So that the chart will upload it to your local vault when you install CaraML.

```bash
> scripts/generate-cluster-creds.sh minikube dev
```

This will generate a cluster-credentials.json file under `charts/merlin/files` directory. That file will look like:

```json
{
  "name": "dev", # cluster name
  "master_ip": "https://kubernetes.default.svc:443",
  "certs": "",
  "client_certificate": "",
  "client_key": ""
}
```

## Install Merlin

```bash

helm repo add caraml https://caraml-dev.github.io/helm-charts/

helm install merlin caraml/merlin \
  --set merlin.oauthClientID=${OAUTH_CLIENT_ID} \
  --timeout=5m \
  --wait
```

### Check Merlin installation

```bash
kubectl get po
NAME                                          READY   STATUS      RESTARTS     AGE
caraml-postgresql-0                           1/1     Running     0            17m
merlin-0-24-0-caraml-59f5cddf69-t56vs         2/2     Running     4            15m
merlin-0-24-0-caraml-59f5cddf69-zrrqd         2/2     Running     4            15m
merlin-0-24-0-caraml-mlflow-fc54b7f88-hnwwt   1/1     Running     3            15m
merlin-0-24-0-setup-job-mshn8                 0/1     Completed   0            15m
mlp-0-2-0-caraml-d44699777-7xlr7              1/1     Running     4            15m
```

Once everything is Running, you can open Merlin in <http://merlin.mlp.${INGRESS_HOST}.nip.io/merlin>. From here, you can run Jupyter notebook examples by setting `merlin.set_url("merlin.mlp.${INGRESS_HOST}.nip.io")`.
