# Local Development

CaraML chart by default deploys XP Management Service on a local Minikube cluster. Use this guide to generate the prerequisites for the same.

## Provision Minikube cluster

First, you need to have Minikube installed on your machine. To install it, please follow this [documentation](https://minikube.sigs.k8s.io/docs/start/).

Next, create a new Minikube cluster with Kubernetes v1.24.2:

```bash
export CLUSTER_NAME=dev
minikube start --cpus=4 --memory=8192 --kubernetes-version=v1.24.2 --driver=virtualbox
```

Lastly, we need to enable Minikube's LoadBalancer services by running `minikube tunnel` in another terminal.
If using a Kind cluster, Use `./scripts/install_metallib.sh` to install the prerequisite balancers before you install CaraML.

## Generate Cluster Credentials

Vault is needed to store the model cluster credential where models will be deployed. For local development, we will use the same Minikube cluster as model cluster. In production, you may have multiple model clusters. You can use the scripts added in the CaraML charts repo (`./scripts/generate-cluster-creds.sh`) to generate the cluster credentials file in to XP Management Service files, So that the chart will upload it to your local vault when you install CaraML.

```bash
> scripts/generate-cluster-creds.sh minikube dev
```

This will generate a cluster-credentials.json file under `charts/xp-management-service/files` directory. That file will look like:

```json
{
  "name": "dev", # cluster name
  "master_ip": "https://kubernetes.default.svc:443",
  "certs": "",
  "client_certificate": "",
  "client_key": ""
}
```

## Install XP Management Service

```bash
# Set postgresql persistence to false to ensure PVC gets deleted
helm install xp-management caraml/xp-management-service \
  --set xp.uiConfig.authConfig.oauthClientID=${OAUTH_CLIENT_ID} \
  --set xp-postgresql.persistence.enabled=false \
  --set mlp.postgresql.persistence.enabled=false \
  -f xp-management-service/values-global.yaml \
  --timeout=5m \
  --wait
```

Once everything is in `Running` status, you can open XP Management in <http://xp-management.mlp.${INGRESS_HOST}.nip.io/xp>.
