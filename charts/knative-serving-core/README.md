# knative-serving-core

---
![Version: 1.3.2](https://img.shields.io/badge/Version-1.3.2-informational?style=flat-square)
![AppVersion: v1.3.2](https://img.shields.io/badge/AppVersion-v1.3.2-informational?style=flat-square)

Installs Knative Serving core and CRDs.

## Introduction

This Helm chart installs [Knative Serving Core](https://knative.dev/docs/serving/) and it's CRDs. It is based off v1.3.2 of Knative serving release.

## Prerequisites

To use the charts here, [Helm](https://helm.sh/) must be configured for your
Kubernetes cluster. Setting up Kubernetes and Helm is outside the scope of
this README. Please refer to the Kubernetes and Helm documentation.

- **Helm 3.0+** – This chart was tested with Helm v3.9.0, but it is also expected to work with earlier Helm versions
- **Kubernetes 1.22+** – This chart was tested with GKE v1.22.x

## Installation

### Add Helm repository

```shell
helm repo add caraml https://caraml-dev.github.io/helm-charts
```

### Installing the chart

This command will install Knative release named `knative-serving` in the `knative-serving` namespace.
Do not try to install into other namespaces as it will break with other installations like Kserve.
Default chart values will be used for the installation:
```shell
$ helm install caraml/knative-serving-core --namespace knative-serving
```

You can (and most likely, should) override the default configuration with values suitable for your installation.
Refer to [Configuration](#configuration) section for the detailed description of available configuration keys.

### Uninstalling the chart

To uninstall `knative-serving-core` release:
```shell
$ helm uninstall -n knative-serving knative-serving-core
```

The command removes all the Kubernetes components associated with the chart and deletes the release,
except for postgresql PVC, those will have to be removed manually.

## Configuration

The following table lists the configurable parameters of the Knative Serving Core chart and their default values.

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| activator.autoscaling.enabled | bool | `true` | Enables autoscaling for activator deployment. |
| activator.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for activator. |
| activator.autoscaling.minReplicas | int | `1` | Minimum number of replicas for activator. |
| activator.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| activator.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/activator"` | Repository of the activator image |
| activator.image.sha | string | `"01270196a1eba7e5fd5fe34b877c82a7e8c93861de535a82342717d28f81d671"` | SHA256 of the activator image, either provide tag or SHA (SHA will be given priority) |
| activator.image.tag | string | `""` | Tag of the activator image, either provide tag or SHA (SHA will be given priority) |
| activator.replicaCount | int | `1` | Number of replicas for the activator deployment. |
| activator.resources | object | `{"limits":{"cpu":"1000m","memory":"600Mi"},"requests":{"cpu":"300m","memory":"100Mi"}}` | Resources requests and limits for activator. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| autoscaler.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler"` | Repository of the autoscaler image |
| autoscaler.image.sha | string | `"c5a03a236bfe2abdc7d40203d787668c8accaaf39062a86e68b4d403077835e2"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscaler.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscaler.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| autoscaler.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| autoscalerHpa.enabled | bool | `true` |  |
| autoscalerHpa.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/autoscaler-hpa"` | Repository of the autoscaler image |
| autoscalerHpa.image.sha | string | `"256373054915e035d3f5df214ca80eea7a235526c93348933f42acf0437bb1a2"` | SHA256 of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.image.tag | string | `""` | Tag of the autoscaler image, either provide tag or SHA (SHA will be given priority) |
| autoscalerHpa.replicaCount | int | `1` | Number of replicas for the autoscaler deployment. |
| autoscalerHpa.resources | object | `{"limits":{"cpu":"1000m","memory":"256Mi"},"requests":{"cpu":"500m","memory":"128Mi"}}` | Resources requests and limits for autoscaler. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| config | object | `{"autoscaler":{},"buckets":"1","defaults":{},"deployment":{"queueSidecarImage":"gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:2249dc873059c0dfc0783bce5f614a0d8ada3d4499d63aa1dffd19f2788ba64b"},"domain":{},"features":{},"gc":{},"leaderElection":{"lease-duration":"60s","renew-deadline":"40s","retry-period":"10s"},"logging":{"logging.request-log-template":""},"network":{},"observability":{},"tracing":{}}` | Please check out the Knative documentation in https://github.com/knative/serving/releases/download/knative-v1.0.1/serving-core.yaml |
| controller.autoscaling.enabled | bool | `true` | Enables autoscaling for controller deployment. |
| controller.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for controller. |
| controller.autoscaling.minReplicas | int | `1` | Minimum number of replicas for controller. |
| controller.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| controller.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/controller"` | Repository of the controller image |
| controller.image.sha | string | `"cc33e6392485e9d015886d4443324b9a41c17f6ce98b31ef4b19e47325a9a7e8"` | SHA256 of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.image.tag | string | `""` | Tag of the controller image, either provide tag or SHA (SHA will be given priority) |
| controller.replicaCount | int | `1` | Number of replicas for the controller deployment. |
| controller.resources | object | `{"limits":{"cpu":"1000m","memory":"1000Mi"},"requests":{"cpu":"500m","memory":"500Mi"}}` | Resources requests and limits for controller. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| domainMapping.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping"` | Repository of the domain mapping image |
| domainMapping.image.sha | string | `"00a26f25ef119952b0ecf890f9f9dcb877b5f5d496f43c44756b93343d71b66e"` | SHA256 of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| domainMapping.image.tag | string | `""` | Tag of the domain mapping image, either provide tag or SHA (SHA will be given priority) |
| domainMapping.replicaCount | int | `1` | Number of replicas for the domain mapping deployment. |
| domainMapping.resources | object | `{"limits":{"cpu":"300m","memory":"400Mi"},"requests":{"cpu":"30m","memory":"40Mi"}}` | Resources requests and limits for domain mapping. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| domainMappingWebhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/domain-mapping-webhook"` | Repository of the domain mapping webhook image |
| domainMappingWebhook.image.sha | string | `"f8f09d3a509b0c25d50be7532d4337a30df4ec5f51b9ed23ad9f21b3940c16ca"` | SHA256 of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| domainMappingWebhook.image.tag | string | `""` | Tag of the domain mapping webhook image, either provide tag or SHA (SHA will be given priority) |
| domainMappingWebhook.replicaCount | int | `1` | Number of replicas for the domain mapping webhook deployment. |
| domainMappingWebhook.resources | object | `{"limits":{"cpu":"500m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for domain mapping webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| global.affinity | object | `{}` | Assign custom affinity rules to the prometheus operator ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| global.extraPodLabels | object | `{}` | Extra pod labels in a map[string]string format, most likely to be used for the costing labels. |
| global.nodeSelector | object | `{}` | Define which Nodes the Pods are scheduled on. ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| global.tolerations | list | `[]` | If specified, the pod's tolerations. ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| monitoring.allNamespaces | bool | `true` |  |
| monitoring.enabled | bool | `false` |  |
| monitoring.podMonitor.metricRelabelings | object | `{}` |  |
| monitoring.podMonitor.selector.matchExpressions[0].key | string | `"{{ .Values.monitoring.selectorKey }}"` |  |
| monitoring.podMonitor.selector.matchExpressions[0].operator | string | `"Exists"` |  |
| monitoring.podMonitor.userMetricPortName | string | `"http-usermetric"` |  |
| monitoring.podMonitor.userPortName | string | `"user-port"` |  |
| monitoring.selectorKey | string | `"serving.knative.dev/revision"` |  |
| queueProxy.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/queue"` | Repository of the queue proxy image |
| queueProxy.image.sha | string | `"2249dc873059c0dfc0783bce5f614a0d8ada3d4499d63aa1dffd19f2788ba64b"` | SHA256 of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| queueProxy.image.tag | string | `""` | Tag of the queue proxy image, either provide tag or SHA (SHA will be given priority) |
| webhook.autoscaling.enabled | bool | `true` | Enables autoscaling for webhook deployment. |
| webhook.autoscaling.maxReplicas | int | `20` | Maximum number of replicas for webhook. |
| webhook.autoscaling.minReplicas | int | `1` | Minimum number of replicas for webhook. |
| webhook.autoscaling.targetCPUUtilizationPercentage | int | `50` | Target CPU utlisation before it scales up/down. |
| webhook.image.repository | string | `"gcr.io/knative-releases/knative.dev/serving/cmd/webhook"` | Repository of the webhook image |
| webhook.image.sha | string | `"b001a58cb7eac7fbae4d83d8a111fa0f6726d36e86844d5b1dc3c9b8fdd5710a"` | SHA256 of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.image.tag | string | `""` | Tag of the webhook image, either provide tag or SHA (SHA will be given priority) |
| webhook.replicaCount | int | `1` | Number of replicas for the webhook deployment. |
| webhook.resources | object | `{"limits":{"cpu":"200m","memory":"500Mi"},"requests":{"cpu":"100m","memory":"100Mi"}}` | Resources requests and limits for webhook. This should be set according to your cluster capacity and service level objectives. Reference: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
