# timber-fluentd

---
![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)
![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Fluentd service - Fluentd service that supports UPI logs parsing

## Introduction

This Helm chart installs Timber-Fluentd and all its dependencies in a Kubernetes cluster.

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
| annotations | object | `{}` | Annotations to add to fluentd pod |
| autoscaling | object | `{"enabled":false,"maxReplicas":2,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | HPA scaling configuration for Observation Service fluentd |
| autoscaling.enabled | bool | `false` | Toggle to enable HPA scaling |
| autoscaling.maxReplicas | int | `2` | Maximum replicas for HPA scaling |
| autoscaling.minReplicas | int | `1` | Minimum replicas for HPA scaling |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | CPU utilization percentage threshold to activate HPA scaling |
| extraEnvs | list | `[]` | List of extra environment variables to add to fluentd container |
| extraLabels | object | `{}` | List of extra labels to add to fluentd K8s resources |
| fluentdConfig | string | `""` | Fluentd config to be mounted as fluentd/etc/fluent.conf |
| gcpServiceAccount.account | string | `""` | Base64 encoded service account json |
| gcpServiceAccount.enabled | bool | `false` | Flag to toggle flushing Observation logs to BQ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| image.registry | string | `"ghcr.io"` | Docker registry for fluentd image |
| image.repository | string | `"caraml-dev/timber/fluentd"` | Docker image repository for fluentd |
| image.tag | string | `"v0.0.0-build.16-01ac82e"` | Docker image tag for fluentd |
| nameOverride | string | `""` |  |
| pvcConfig | object | `{"mountPath":"/cache","name":"cache-volume","storage":"3Gi"}` | PVC configurations for fluentd StatefulSet storage |
| replicaCount | int | `1` |  |
| resources | object | `{}` | Resources requests and limits for fluentd StatefulSet. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |