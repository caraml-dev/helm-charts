# xp-treatment

---
![Version: 0.1.17](https://img.shields.io/badge/Version-0.1.17-informational?style=flat-square)
![AppVersion: 0.12.1](https://img.shields.io/badge/AppVersion-0.12.1-informational?style=flat-square)

Treatment service - A part of XP system that is used to obtain the treatment configuration from active experiments

## Introduction

This Helm chart installs [XP Treatment-Service](https://github.com/caraml-dev/xp-treatment-service) and all its dependencies in a Kubernetes cluster.

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

The following table lists the configurable parameters of the XP Treatment Service chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| deployment.annotations | object | `{}` | Annotations to add to Treatment Service pod |
| deployment.apiConfig | object | `{"deploymentConfig":{"environmentType":"dev"},"managementService":{"authorizationEnabled":false,"url":null},"newRelicConfig":{"appName":"xp-treatment-service","enabled":false,"license":""},"port":8080,"segmenterConfig":{"s2_ids":{"maxS2CellLevel":14,"minS2CellLevel":10}},"sentryConfig":{"dsn":"","enabled":false,"labels":{"app":"xp-treatment-service"}}}` | Application configurations to pass to XP Treatment Service server container during application start-up |
| deployment.autoscaling.enabled | bool | `false` |  |
| deployment.autoscaling.maxReplicas | int | `2` |  |
| deployment.autoscaling.minReplicas | int | `1` |  |
| deployment.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| deployment.autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| deployment.extraArgs | list | `[]` | List of extra argumetns to add to XP Treatment Service server container |
| deployment.extraEnvs | list | `[]` | List of extra environment variables to add to XP Treatment Service server container |
| deployment.extraVolumeMounts | list | `[]` | Extra volume mounts to attach to XP Treatment Service server container. For example to mount the extra volume containing secrets |
| deployment.extraVolumes | list | `[]` | Extra volumes to attach to the Pod. For example, you can mount additional secrets to these volumes |
| deployment.image.pullPolicy | string | `"IfNotPresent"` | Docker image pull policy |
| deployment.image.registry | string | `"ghcr.io"` | Docker registry for XP Treatment Service image |
| deployment.image.repository | string | `"caraml-dev/xp/xp-treatment"` | Docker image repository for XP Treatment Service |
| deployment.image.tag | string | `"v0.12.1"` | Docker image tag for XP Treatment Service |
| deployment.livenessProbe.initialDelaySeconds | int | `60` | Liveness probe delay and thresholds |
| deployment.livenessProbe.path | string | `"/v1/internal/health/live"` | HTTP path for liveness check |
| deployment.livenessProbe.periodSeconds | int | `10` |  |
| deployment.livenessProbe.successThreshold | int | `1` |  |
| deployment.livenessProbe.timeoutSeconds | int | `5` |  |
| deployment.nodeSelector | object | `{}` |  |
| deployment.readinessProbe.initialDelaySeconds | int | `60` | Liveness probe delay and thresholds |
| deployment.readinessProbe.path | string | `"/v1/internal/health/ready"` | HTTP path for readiness check |
| deployment.readinessProbe.periodSeconds | int | `10` |  |
| deployment.readinessProbe.successThreshold | int | `1` |  |
| deployment.readinessProbe.timeoutSeconds | int | `5` |  |
| deployment.replicaCount | int | `1` |  |
| deployment.resources | object | `{}` | Resources requests and limits for XP Treatment Service API. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| deployment.service.externalPort | int | `8080` | XP Treatment Service Kubernetes service port number |
| deployment.service.internalPort | int | `8080` | XP Treatment Service container port number |
| deployment.service.type | string | `"ClusterIP"` |  |
| global.protocol | string | `"http"` |  |
| ingress.class | string | `""` | Ingress class annotation to add to this Ingress rule, useful when there are multiple ingress controllers installed |
| ingress.enabled | bool | `false` | Enable ingress to provision Ingress resource for external access to XP Treatment Service |
| ingress.host | string | `""` | Set host value to enable name based virtual hosting. This allows routing HTTP traffic to multiple host names at the same IP address. If no host is specified, the ingress rule applies to all inbound HTTP traffic through the IP address specified. https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting |
| swaggerUi.apiServer | string | `"http://127.0.0.1/v1"` | URL of API server |
| swaggerUi.enabled | bool | `false` |  |
| swaggerUi.image | object | `{"tag":"v3.47.1"}` | Docker tag for Swagger UI https://hub.docker.com/r/swaggerapi/swagger-ui |
| swaggerUi.service.externalPort | int | `8080` | Swagger UI Kubernetes service port number |
| swaggerUi.service.internalPort | int | `8081` | Swagger UI container port number |
