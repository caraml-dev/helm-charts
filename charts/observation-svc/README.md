# observation-svc

---
![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square)
![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Observation Service - Logging system for collecting ground truth observation result from ML prediction

## Introduction

This Helm chart installs [Timber-Observation-Service](https://github.com/caraml-dev/observation-service) and all its dependencies in a Kubernetes cluster.
It installs fluentd service optionally as a subchart.

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

For more configurable of fluentd, check out [Timber-Fluentd](https://github.com/caraml-dev/timber-fluentd)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fluentd.enabled | bool | `false` | Flag to toggle deployment of Observation Service fluentd |
| fluentd.extraEnvs | string | `nil` | List of extra environment variables to add to Observation Service fluentd container |
| fluentd.fluentdConfig | string | `""` | Fluentd.conf |
| fluentd.nameOverride | string | `"obs-fluentd"` |  |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| observationService.affinity | object | `{}` | Assign custom affinity rules to constrain pods to nodes. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| observationService.annotations | object | `{}` | Annotations to add to Observation Service pod |
| observationService.apiConfig | object | `{}` | Observation Service server configuration. |
| observationService.autoscaling | object | `{"enabled":false,"maxReplicas":2,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | HPA scaling configuration for Observation Service |
| observationService.autoscaling.enabled | bool | `false` | Toggle to enable HPA scaling |
| observationService.autoscaling.maxReplicas | int | `2` | Maximum replicas for HPA scaling |
| observationService.autoscaling.minReplicas | int | `1` | Minimum replicas for HPA scaling |
| observationService.autoscaling.targetCPUUtilizationPercentage | int | `80` | CPU utilization percentage threshold to activate HPA scaling |
| observationService.extraEnvs | list | `[]` | List of extra environment variables to add to Observation Service server container |
| observationService.extraLabels | object | `{}` | List of extra labels to add to Observation Service K8s resources |
| observationService.image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| observationService.image.registry | string | `"ghcr.io"` | Docker registry for Observation Service image |
| observationService.image.repository | string | `"caraml-dev/timber/observation-service"` | Docker image repository for Observation Service |
| observationService.image.tag | string | `"v0.0.0-build.15-b8afdb5"` | Docker image tag for Observation Service |
| observationService.ingress.class | string | `""` | Ingress class annotation to add to this Ingress rule, useful when there are multiple ingress controllers installed |
| observationService.ingress.enabled | bool | `false` | Enable ingress to provision Ingress resource for external access to Observation Service |
| observationService.ingress.host | string | `""` | Set host value to enable name based virtual hosting. This allows routing HTTP traffic to multiple host names at the same IP address. If no host is specified, the ingress rule applies to all inbound HTTP traffic through the IP address specified. https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting |
| observationService.livenessProbe.initialDelaySeconds | int | `60` | Liveness probe delay and thresholds |
| observationService.livenessProbe.path | string | `"/v1/internal/health/live"` | HTTP path for liveness check |
| observationService.livenessProbe.periodSeconds | int | `10` |  |
| observationService.livenessProbe.successThreshold | int | `1` |  |
| observationService.livenessProbe.timeoutSeconds | int | `5` |  |
| observationService.monitoring | object | `{"baseURL":"/v1/metrics","enabled":false}` | Service Monitor configuration for Observation Service |
| observationService.nodeSelector | object | `{}` | Define which nodes the pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| observationService.readinessProbe.initialDelaySeconds | int | `60` | Readiness probe delay and thresholds |
| observationService.readinessProbe.path | string | `"/v1/internal/health/ready"` | HTTP path for readiness check |
| observationService.readinessProbe.periodSeconds | int | `10` |  |
| observationService.readinessProbe.successThreshold | int | `1` |  |
| observationService.readinessProbe.timeoutSeconds | int | `5` |  |
| observationService.replicaCount | int | `1` |  |
| observationService.resources | object | `{}` | Resources requests and limits for Observation Service. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| observationService.service.externalPort | int | `9001` | Observation Service Kubernetes service port number |
| observationService.service.internalPort | int | `9001` | Observation Service container port number |
| observationService.service.type | string | `"ClusterIP"` |  |
| observationService.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |