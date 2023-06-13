# dap-secret-webhook

---
![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)
![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

dap-secret-webhook is a Kubernetes pod mutating webhook for using CaraML Secrets in Flyte.

## Introduction

dap-secret-webhook is a Kubernetes pod mutating webhook for using CaraML Secrets in Flyte.

The webhook is deployed using a deployment resource which requires the following to operate
- ServiceAccount with roles to operate on `Secrets` and `MutatingWebhookConfiguration`
- Env var
  - Configuration to create MutatingWebhookConfiguration programmatically
  - MLP host
  - Secrets with TLS

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| caraml-dev | <caraml-dev@caraml.dev> |  |

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.7.1, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.18+** – This chart was tested with GKE v1.20.x and with [k3d](https://github.com/rancher/k3d) v1.21.x,
but it's possible it works with earlier k8s versions too

## Configuration

The following table lists the configurable parameters of the Observation Service chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.extraEnvs | list | `[]` | Additional env var for webhook, see https://github.com/caraml-dev/dap-secret-webhook for full list of configurable |
| deployment.image.pullPolicy | string | `"IfNotPresent"` |  |
| deployment.image.repository | string | `"ghcr.io/caraml-dev/dap-secret-webhook"` |  |
| deployment.image.tag | string | `"0.0.1"` |  |
| deployment.replicaCount | int | `1` |  |
| deployment.resources.requests.cpu | string | `"250m"` |  |
| deployment.resources.requests.memory | string | `"128Mi"` |  |
| deployment.service.port | int | `443` |  |
| deployment.service.type | string | `"ClusterIP"` |  |
| deployment.webhook.caCertPath | string | `"/etc/tls-certs/caCert.pem"` |  |
| deployment.webhook.mlpApiHost | string | `""` | The endpoint of MLP API. Default will be set with to mlp local cluster |
| deployment.webhook.serverCertPath | string | `"/etc/tls-certs/serverCert.pem"` |  |
| deployment.webhook.serverKeyPath | string | `"/etc/tls-certs/serverKey.pem"` |  |
| fullnameOverride | string | `""` |  |
| mlp.enabled | bool | `true` |  |
| nameOverride | string | `""` |  |
| rbac.create | bool | `true` | Specifies whether roles should be granted to |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | If create is false, existing service account name is required in the release namespace |
| tls.create | bool | `true` | This can be set as false and the corresponding certs mounted in deployment.env |
| tls.secretName | string | `""` | webhook is required |
| tls.serviceAccountName | string | `""` | Service account is expected to be in the same namespace as the webhook and job |